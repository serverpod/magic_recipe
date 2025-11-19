import 'package:serverpod/serverpod.dart';
import 'package:magic_recipe_server/src/generated/protocol.dart';
import 'package:magic_recipe_server/src/recipes/recipes.dart';

class RecipesEndpoint extends Endpoint {
  RecipesEndpoint([RecipeAIService? aiService]) : _aiService = aiService;

  @override
  bool get requireLogin => true;

  static const _storageId = 'public';
  static const _uuid = Uuid();

  final RecipeAIService? _aiService;

  RecipeAIService _getAIService(Session session) {
    if (_aiService != null) return _aiService;

    final apiKey = session.passwords['gemini'];
    if (apiKey == null) {
      throw RecipeException('Gemini API key not configured');
    }

    return RecipeAIService.fromApiKey(apiKey);
  }

  Stream<Recipe> generateRecipeStream(
    Session session,
    String ingredients, [
    String? imagePath,
  ]) async* {
    _validateIngredients(ingredients);
    final aiService = _getAIService(session);
    final userId = _getUserId(session);

    yield* aiService.generateRecipeStream(
      session,
      userId,
      ingredients,
      imagePath,
    );
  }

  Future<Recipe> generateRecipe(
    Session session,
    String ingredients, [
    String? imagePath,
  ]) async {
    final aiService = _getAIService(session);
    final userId = _getUserId(session);
    return await aiService.generateRecipe(
        session, userId, ingredients, imagePath);
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

  Future<(String?, String)> getUploadDescription(
    Session session,
    String filename,
  ) async {
    if (filename.trim().isEmpty) {
      throw RecipeException('Filename cannot be empty');
    }

    final path = _generateUploadPath(filename);
    final description = await session.storage.createDirectFileUploadDescription(
      storageId: _storageId,
      path: path,
    );

    return (description, path);
  }

  Future<bool> verifyUpload(Session session, String path) async {
    return session.storage.verifyDirectFileUpload(
      storageId: _storageId,
      path: path,
    );
  }

  Future<String> getPublicUrlForPath(Session session, String path) async {
    final url = await session.storage.getPublicUrl(
      storageId: _storageId,
      path: path,
    );

    return url.toString();
  }

  /// Private helpers
  String _getUserId(Session session) {
    final userId = session.authenticated?.userIdentifier;
    if (userId == null) {
      throw RecipeException('User not authenticated');
    }
    return userId;
  }

  String _generateUploadPath(String filename) {
    final uniqueId = _uuid.v4();
    return 'uploads/$uniqueId/$filename';
  }

  void _validateIngredients(String ingredients) {
    if (ingredients.trim().isEmpty) {
      throw RecipeException('Ingredients cannot be empty');
    }
  }
}
