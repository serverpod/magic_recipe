import 'package:serverpod/serverpod.dart';
import 'package:magic_recipe_server/src/generated/protocol.dart';
import 'package:magic_recipe_server/src/recipes/recipes.dart';

class RecipesEndpoint extends Endpoint {
  RecipesEndpoint([RecipeAIService? aiService]) : _aiService = aiService;

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
    return await aiService.generateRecipe(session, ingredients);
  }

  Future<List<Recipe>> getRecipes(Session session) async {
    return Recipe.db.find(
      session,
      where: (t) => t.deletedAt.equals(null),
      orderBy: (t) => t.date,
      orderDescending: true,
    );
  }

  Future<void> deleteRecipe(Session session, int recipeId) async {
    final recipe = await Recipe.db.findById(session, recipeId);

    if (recipe == null) {
      throw RecipeException('Recipe not found');
    }

    await Recipe.db.updateRow(
      session,
      recipe.copyWith(deletedAt: DateTime.now()),
    );
  }
}
