import 'package:magic_recipe_server/src/generated/protocol.dart';
import 'package:magic_recipe_server/src/recipes/endpoints/recipes_endpoint.dart';
import 'package:test/test.dart';

import 'mock_recipe_ai_service.dart';
import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Given Recipes endpoint', (sessionBuilder, endpoints) {
    test('generates recipe with ingredients in prompt', () async {
      final ai = MockRecipeAIService();
      final testEndpoint = RecipesEndpoint(ai);
      final authenticatedSession = sessionBuilder.copyWith(
        authentication: AuthenticationOverride.authenticationInfo('user-1', {}),
      );
      final session = authenticatedSession.build();
      final ingredients = 'chicken, rice, broccoli';

      final recipe = await testEndpoint.generateRecipe(
        session,
        ingredients,
      );

      expect(recipe.text, 'Mock Recipe');
      expect(ai.history, isNotEmpty);
      // Check that ingredients are in the history
      final historyText = ai.history.map((msg) => msg.toString()).join(' ');
      expect(historyText, contains(ingredients));
    });

    test('returns cached recipe on second call', () async {
      final ai = MockRecipeAIService();
      final testEndpoint = RecipesEndpoint(ai);
      final authenticatedSession = sessionBuilder.copyWith(
        authentication: AuthenticationOverride.authenticationInfo('user-1', {}),
      );
      final session = authenticatedSession.build();

      await session.caches.local.clear();

      final ingredients = 'chicken, rice, broccoli';

      final recipe1 = await testEndpoint.generateRecipe(
        session,
        ingredients,
      );

      expect(recipe1.text, 'Mock Recipe');
      expect(ai.prompts, hasLength(1));

      final recipe2 = await testEndpoint.generateRecipe(
        session,
        ingredients,
      );

      expect(recipe2.text, 'Mock Recipe');
      expect(ai.prompts, hasLength(1),
          reason: 'Should use cache, not call AI again');
    });

    test('returns all recipes', () async {
      final authenticatedSession = sessionBuilder.copyWith(
        authentication: AuthenticationOverride.authenticationInfo('user-1', {}),
      );
      final db = authenticatedSession.build();

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
          userId: 'user-1',
        ),
        Recipe(
          author: 'Gemini',
          text: 'Recipe 2',
          date: DateTime.now(),
          ingredients: 'ingredient2',
          userId: 'user-1',
        ),
      ]);

      final recipes = await endpoints.recipes.getRecipes(authenticatedSession);

      expect(recipes, hasLength(2));
      expect(recipes[0].text, 'Recipe 2'); // Should be ordered by date descending
      expect(recipes[1].text, 'Recipe 1');
    });
  });
}

