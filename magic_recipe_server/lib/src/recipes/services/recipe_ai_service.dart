import 'package:dartantic_ai/dartantic_ai.dart';
import 'package:dartantic_interface/dartantic_interface.dart';
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

  static const _recipeInstructions = '''
Always put the title of the recipe in the first line, and then the instructions. The recipe should be easy to follow and include all necessary steps. Please provide a detailed recipe. Only put the title in the first line, no markup.''';

  /// Generates a recipe using the provided ingredients.
  ///
  /// [ingredients] must not be empty.
  Future<Recipe> generateRecipe(
    Session session,
    String ingredients,
  ) async {
    _validateIngredients(ingredients);

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
    );

    return recipe;
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
