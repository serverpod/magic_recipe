import 'package:magic_recipe_server/src/generated/protocol.dart';
import 'package:magic_recipe_server/src/recipes/recipes_endpoint.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Given Recipes Endpoint', (sessionBuilder, endpoints) {
    test(
        'When calling generateRecipe with ingredients, gemini is called with a prompt'
        ' which includes the ingredients', () async {
      String capturedPrompt = '';

      generateContent = (_, prompt) {
        capturedPrompt = prompt;
        return Future.value('Mock Recipe');
      };

      final recipe = await endpoints.recipes
          .generateRecipe(sessionBuilder, 'chicken, rice, broccoli');
      expect(recipe.text, 'Mock Recipe');
      expect(capturedPrompt, contains('chicken, rice, broccoli'));
    });

    test(
        'when calling getRecipes, all recipes that are not deleted are returned',
        () async {
      final session = sessionBuilder.build();

      // drop all recipes
      await Recipe.db.deleteWhere(session, where: (t) => t.id.notEquals(null));

      // create a recipe
      final firstRecipe = Recipe(
          author: 'Gemini',
          text: 'Mock Recipe 1',
          date: DateTime.now(),
          ingredients: 'chicken, rice, broccoli');

      await Recipe.db.insertRow(session, firstRecipe);

      // create a second recipe
      final secondRecipe = Recipe(
          author: 'Gemini',
          text: 'Mock Recipe 2',
          date: DateTime.now(),
          ingredients: 'chicken, rice, broccoli');
      await Recipe.db.insertRow(session, secondRecipe);

      // get all recipes
      final recipes = await endpoints.recipes.getRecipes(sessionBuilder);

      // check that the recipes are returned
      expect(recipes.length, 2);

      // get the first recipe to get its id
      final recipeToDelete = await Recipe.db.findFirstRow(
        session,
        where: (t) => t.text.equals('Mock Recipe 1'),
      );

      // delete the first recipe
      await endpoints.recipes.deleteRecipe(sessionBuilder, recipeToDelete!.id!);

      // get all recipes
      final recipes2 = await endpoints.recipes.getRecipes(sessionBuilder);
      // check that the recipes are returned
      expect(recipes2.length, 1);
      expect(recipes2[0].text, 'Mock Recipe 2');
    });
  });
}
