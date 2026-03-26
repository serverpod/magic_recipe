import 'package:magic_recipe_server/src/generated/protocol.dart';
import 'package:magic_recipe_server/src/recipes/recipes.dart';
import 'package:serverpod/serverpod.dart';

/// Endpoint for AI-powered recipe generation using Gemini.
/// Uses dependency-injected RecipeAIService, or falls back to API key from passwords.
class RecipesEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

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

  /// Gets the user id from the session.
  String _getUserId(Session session) {
    final userId = session.authenticated?.userIdentifier;
    if (userId == null) {
      throw RecipeException('User not authenticated');
    }
    return userId;
  }

  /// Accepts a string containing ingredients and returns a generated Recipe.
  Future<Recipe> generateRecipe(Session session, String ingredients) async {
    final aiService = _getAIService(session);
    final userId = _getUserId(session);

    return await aiService.generateRecipe(session, userId, ingredients);
  }

  /// Returns a list of all recipes.
  Future<List<Recipe>> getRecipes(Session session) async {
    final userId = _getUserId(session);

    return Recipe.db.find(
      session,
      where: (t) => t.deletedAt.equals(null) & t.userId.equals(userId),
      orderBy: (t) => t.date,
      orderDescending: true,
    );
  }

  /// Delete a recipe by its [recipeId].
  Future<void> deleteRecipe(Session session, int recipeId) async {
    final userId = _getUserId(session);
    final recipe = await Recipe.db.findById(session, recipeId);

    if (recipe == null) {
      throw RecipeException('Recipe not found');
    }

    if (recipe.userId != userId) {
      throw RecipeException(
        'Unauthorized: You can only delete your own recipes',
      );
    }

    await Recipe.db.updateRow(
      session,
      recipe.copyWith(deletedAt: DateTime.now()),
    );
  }
}
