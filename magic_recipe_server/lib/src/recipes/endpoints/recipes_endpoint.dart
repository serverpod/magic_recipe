import 'package:magic_recipe_server/src/generated/protocol.dart';
import 'package:magic_recipe_server/src/recipes/recipes.dart';
import 'package:serverpod/serverpod.dart';

/// This is the endpoint that will be used to generate a recipe using the
/// Google Gemini API. It extends the Endpoint class and implements the
/// generateRecipe method.
/// Endpoint for AI-powered recipe generation using Gemini.
/// Uses dependency-injected RecipeAIService, or falls back to API key from passwords.
class RecipesEndpoint extends Endpoint {
  /// Optionally pass in a custom AI service for testing/mocking.
  RecipesEndpoint([RecipeAIService? aiService]) : _aiService = aiService;

  final RecipeAIService? _aiService;

  /// Gets the AI service, using the injected service if one was provided,
  /// otherwise constructs a production RecipeAIService from the API key in passwords.
  RecipeAIService _getAIService(Session session) {
    if (_aiService != null) return _aiService;

    final apiKey = session.passwords['geminiApiKey'];
    if (apiKey == null) {
      throw RecipeException('Gemini API key not configured');
    }

    return RecipeAIService.fromApiKey(apiKey);
  }

  /// Accepts a string containing ingredients and returns a generated Recipe.
  Future<Recipe> generateRecipe(Session session, String ingredients) async {
    final aiService = _getAIService(session);
    return await aiService.generateRecipe(session, ingredients);
  }
}
