import 'dart:typed_data';

import 'package:dartantic_ai/dartantic_ai.dart';
import 'package:serverpod/serverpod.dart';
import 'package:magic_recipe_server/src/generated/protocol.dart';
import 'package:magic_recipe_server/src/recipes/recipes.dart';

/// Abstract service for AI-powered recipe generation.
///
/// This defines the interface for recipe generation services, making it easy
/// to swap implementations for testing or different AI providers.
abstract class RecipeAIService {
  const RecipeAIService();

  factory RecipeAIService.fromApiKey(String apiKey) {
    return ProductionRecipeAIService(apiKey: apiKey);
  }

  static const _storageId = 'public';
  static const _cacheLifetime = Duration(days: 1);
  static const _recipeInstructions = '''
Always put the title of the recipe in the first line, and then the instructions. The recipe should be easy to follow and include all necessary steps. Please provide a detailed recipe. Only put the title in the first line, no markup.''';

  /// Generates a recipe using the provided ingredients.
  ///
  /// [userId] is required to associate the recipe with the user.
  /// [ingredients] must not be empty.
  /// [imagePath] is optional and should be a valid path to an uploaded image.
  Future<Recipe> generateRecipe(
    Session session,
    String userId,
    String ingredients,
    String? imagePath,
  ) async {
    _validateIngredients(ingredients);

    final cacheKey = generateCacheKey(ingredients, imagePath);

    // Get the cached recipe if it exists.
    final cached = await _getCachedRecipe(session, cacheKey, userId);
    if (cached != null) return cached;

    // Get the attachments if they exist.
    final attachments = await _getAttachments(session, imagePath);

    final response = await generateContent(
      _buildTextPrompt(ingredients),
      attachments: attachments,
    );

    if (response.output.isEmpty) {
      throw RecipeException('Empty response from AI service');
    }

    final recipe = Recipe(
      author: 'Gemini',
      text: response.output,
      date: DateTime.now(),
      ingredients: ingredients,
      userId: userId,
      imagePath: imagePath,
    );

    return await _saveRecipe(
      session,
      recipe,
      userId,
      cacheKey,
    );
  }

  /// Generates a recipe stream using the provided ingredients and optional image.
  ///
  /// Handles caching, generation, and persistence automatically.
  /// [userId] is required to associate the recipe with the user.
  /// [ingredients] must not be empty.
  /// [imagePath] is optional and should be a valid path to an uploaded image.
  Stream<Recipe> generateRecipeStream(
    Session session,
    String userId,
    String ingredients,
    String? imagePath,
  ) async* {
    _validateIngredients(ingredients);

    final cacheKey = generateCacheKey(ingredients, imagePath);

    final cached = await _getCachedRecipe(session, cacheKey, userId);
    if (cached != null) {
      yield cached;
      return;
    }

    final attachments = await _getAttachments(session, imagePath);

    var recipe = Recipe(
      author: 'Gemini',
      text: '',
      date: DateTime.now(),
      ingredients: ingredients,
      userId: userId,
      imagePath: imagePath,
    );

    await for (final chunk in generateContentStream(
      _buildTextPrompt(ingredients),
      attachments: attachments,
    )) {
      recipe = recipe.copyWith(text: recipe.text + chunk.output);
      yield recipe;
    }

    final saved = await _saveRecipe(session, recipe, userId, cacheKey);
    yield saved;
  }

  String _buildTextPrompt(String ingredients) {
    return 'Generate a recipe using the following ingredients: $ingredients. '
        '$_recipeInstructions';
  }

  void _validateIngredients(String ingredients) {
    if (ingredients.trim().isEmpty) {
      throw RecipeException('Ingredients cannot be empty');
    }
  }

  /// Generates content using the AI service.
  Future<ChatResult<String>> generateContent(
    String prompt, {
    List<Part> attachments = const [],
  });

  /// Generates content stream using the AI service.
  Stream<ChatResult<String>> generateContentStream(
    String prompt, {
    List<DataPart> attachments = const [],
  });

  /// Builds the prompt for the AI service.
  Future<List<DataPart>> _getAttachments(
    Session session,
    String? imagePath,
  ) async {
    if (imagePath == null) return [];

    final imageData = await _loadImage(session, imagePath);
    return [DataPart(imageData, mimeType: 'image/jpeg')];
  }

  /// Loads an image from the storage.
  Future<Uint8List> _loadImage(Session session, String path) async {
    final imageData = await session.storage.retrieveFile(
      storageId: _storageId,
      path: path,
    );

    if (imageData == null) {
      throw RecipeException('Image not found: $path');
    }

    return imageData.buffer.asUint8List();
  }

  /// Generates a cache key for the given ingredients.
  String generateCacheKey(String ingredients, String? imagePath) {
    return 'recipe-$ingredients${imagePath ?? ''}';
  }

  /// Gets a cached recipe if available, otherwise returns null.
  Future<Recipe?> _getCachedRecipe(
    Session session,
    String cacheKey,
    String userId,
  ) async {
    final cached = await session.caches.local.get<Recipe>(cacheKey);
    if (cached == null) return null;

    session.log('Cache hit for key: $cacheKey');
    return await Recipe.db.insertRow(
      session,
      cached.copyWith(userId: userId),
    );
  }

  /// Saves a recipe to cache and database.
  Future<Recipe> _saveRecipe(
    Session session,
    Recipe recipe,
    String userId,
    String cacheKey,
  ) async {
    await session.caches.local.put(
      cacheKey,
      recipe,
      lifetime: _cacheLifetime,
    );

    return await Recipe.db.insertRow(
      session,
      recipe.copyWith(userId: userId),
    );
  }
}

/// Production implementation using Gemini AI.
class ProductionRecipeAIService extends RecipeAIService {
  ProductionRecipeAIService({
    required String apiKey,
    String modelName = 'gemini-2.5-flash-lite',
  }) : _agent = _createAgent(apiKey, modelName);

  final Agent _agent;

  static Agent _createAgent(String apiKey, String modelName) {
    return Agent.forProvider(
      GoogleProvider(apiKey: apiKey),
      chatModelName: modelName,
    );
  }

  @override
  Future<ChatResult<String>> generateContent(
    String prompt, {
    List<Part> attachments = const [],
  }) {
    return _agent.send(
      prompt,
      attachments: attachments,
    );
  }

  @override
  Stream<ChatResult<String>> generateContentStream(
    String prompt, {
    List<DataPart> attachments = const [],
  }) {
    return _agent.sendStream(
      prompt,
      attachments: attachments,
    );
  }
}
