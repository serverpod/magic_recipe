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

  static const _cacheLifetime = Duration(days: 1);
  static const _recipeInstructions = '''
Always put the title of the recipe in the first line, and then the instructions. The recipe should be easy to follow and include all necessary steps. Please provide a detailed recipe. Only put the title in the first line, no markup.''';

  /// Generates a recipe using the provided ingredients.
  ///
  /// [userId] is required to associate the recipe with the user.
  /// [ingredients] must not be empty.
  Future<Recipe> generateRecipe(
    Session session,
    String userId,
    String ingredients,
  ) async {
    _validateIngredients(ingredients);

    final cacheKey = generateCacheKey(ingredients);

    // Get the cached recipe if it exists.
    final cached = await _getCachedRecipe(session, cacheKey, userId);
    if (cached != null) return cached;

    final response = await generateContent(
      _buildTextPrompt(ingredients),
      attachments: [],
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
    );

    return await _saveRecipe(session, recipe, userId, cacheKey);
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

  /// Generates a cache key for the given ingredients.
  String generateCacheKey(String ingredients) {
    return 'recipe-$ingredients';
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
}
