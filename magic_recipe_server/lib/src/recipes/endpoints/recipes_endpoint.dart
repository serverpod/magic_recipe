import 'package:serverpod/serverpod.dart';
import 'package:magic_recipe_server/src/generated/protocol.dart';
import 'package:magic_recipe_server/src/recipes/recipes.dart';

class RecipesEndpoint extends Endpoint {
  RecipesEndpoint([RecipeAIService? aiService]) : _aiService = aiService;

  @override
  bool get requireLogin => true;

  final RecipeAIService? _aiService;

  RecipeAIService _getAIService(Session session) {
    if (_aiService != null) return _aiService;

    final apiKey = session.passwords['gemini'];
    if (apiKey == null) {
      throw RecipeException('Gemini API key not configured');
    }

    return RecipeAIService.fromApiKey(apiKey);
  }

  Future<Recipe> generateRecipe(Session session, String ingredients) async {
    final aiService = _getAIService(session);
    final userId = _getUserId(session);
    return await aiService.generateRecipe(session, userId, ingredients);
  }

  Future<List<Recipe>> getRecipes(Session session) async {
    final userId = _getUserId(session);

    return Recipe.db.find(
      session,
      where: (t) => t.deletedAt.equals(null) & t.userId.equals(userId),
      orderBy: (t) => t.date,
      orderDescending: true,
    );
  }

  Future<void> deleteRecipe(Session session, int recipeId) async {
    final userId = _getUserId(session);
    final recipe = await Recipe.db.findById(session, recipeId);

    if (recipe == null) {
      throw RecipeException('Recipe not found');
    }

    if (recipe.userId != userId) {
      throw RecipeException(
          'Unauthorized: You can only delete your own recipes');
    }

    await Recipe.db.updateRow(
      session,
      recipe.copyWith(deletedAt: DateTime.now()),
    );
  }

  /// Private helpers
  String _getUserId(Session session) {
    final userId = session.authenticated?.userIdentifier;
    if (userId == null) {
      throw RecipeException('User not authenticated');
    }
    return userId;
  }
}
