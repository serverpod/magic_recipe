import 'package:magic_recipe_server/src/generated/protocol.dart';
import 'package:magic_recipe_server/src/recipes/endpoints/recipes_endpoint.dart';
import 'package:test/test.dart';

import '../integration.dart';

void main() {
  withServerpod('Given Recipes endpoint', (sessionBuilder, endpoints) {
    test('generates recipe with ingredients in prompt', () async {
      final ai = MockRecipeAIService();
      final testEndpoint = RecipesEndpoint(ai);
      final ingredients = 'chicken, rice, broccoli';

      final recipe = await testEndpoint.generateRecipe(
        sessionBuilder.build(),
        ingredients,
      );

      expect(recipe.text, 'Mock Recipe');
      expect(ai.prompts.length, 1);
      expect(ai.prompts[0], contains(ingredients));
    });

    test('returns all recipes', () async {
      final db = sessionBuilder.build();

      // Clear existing recipes
      final allRecipes = await Recipe.db.find(db);
      for (final recipe in allRecipes) {
        await Recipe.db.deleteRow(db, recipe);
      }

      // Insert test recipes
      await Recipe.db.insert(db, [
        Recipe(
          author: 'Gemini',
          text: 'Recipe 1',
          date: DateTime.now(),
          ingredients: 'ingredient1',
        ),
        Recipe(
          author: 'Gemini',
          text: 'Recipe 2',
          date: DateTime.now(),
          ingredients: 'ingredient2',
        ),
      ]);

      final recipes = await endpoints.recipes.getRecipes(sessionBuilder);

      expect(recipes, hasLength(2));
      expect(
        recipes[0].text,
        'Recipe 2',
      ); // Should be ordered by date descending
      expect(recipes[1].text, 'Recipe 1');
    });
  });
}
