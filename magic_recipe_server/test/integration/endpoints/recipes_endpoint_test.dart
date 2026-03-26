import 'package:magic_recipe_server/src/generated/protocol.dart';
import 'package:magic_recipe_server/src/recipes/recipes.dart';
import 'package:test/test.dart';

import '../integration.dart';

void main() {
  withServerpod('Given Recipes Endpoint', (unAuthSessionBuilder, endpoints) {
    test(
      'When calling generateRecipe with ingredients, gemini is called with a prompt'
      ' which includes the ingredients',
      () async {
        final ai = MockRecipeAIService();
        final recipesEndpoint = RecipesEndpoint(ai);
        final ingredients = 'chicken, rice, broccoli';

        final sessionBuilder = unAuthSessionBuilder.copyWith(
          authentication: AuthenticationOverride.authenticationInfo('1', {}),
        );

        final recipe = await recipesEndpoint.generateRecipe(
          sessionBuilder.build(),
          ingredients,
        );
        expect(recipe.text, 'Mock Recipe');
        expect(ai.prompts.length, 1);
      },
    );

    test(
      'when calling getRecipes, all recipes that are not deleted are returned',
      () async {
        final sessionBuilder = unAuthSessionBuilder.copyWith(
          authentication: AuthenticationOverride.authenticationInfo('1', {}),
        );
        final session = sessionBuilder.build();

        // Delete all recipes in the database.
        await Recipe.db.deleteWhere(
          session,
          where: (t) => t.id.notEquals(null),
        );

        // Create the first recipe.
        final firstRecipe = Recipe(
          author: 'Gemini',
          text: 'Mock Recipe 1',
          date: DateTime.now(),
          userId: '1',
          ingredients: 'chicken, rice, broccoli',
        );

        await Recipe.db.insertRow(session, firstRecipe);

        // Create the second recipe.
        final secondRecipe = Recipe(
          author: 'Gemini',
          text: 'Mock Recipe 2',
          date: DateTime.now(),
          userId: '1',
          ingredients: 'chicken, rice, broccoli',
        );
        await Recipe.db.insertRow(session, secondRecipe);

        // Retrieve all recipes using the getRecipes endpoint.
        final recipes = await endpoints.recipes.getRecipes(sessionBuilder);

        // Verify that both recipes are returned.
        expect(recipes.length, 2);

        // Find the first recipe to get its id.
        final recipeToDelete = await Recipe.db.findFirstRow(
          session,
          where: (t) => t.text.equals('Mock Recipe 1'),
        );

        // Delete the first recipe.
        await endpoints.recipes.deleteRecipe(
          sessionBuilder,
          recipeToDelete!.id!,
        );

        // Retrieve all recipes after deletion.
        final recipes2 = await endpoints.recipes.getRecipes(sessionBuilder);
        // Verify that only the second recipe is returned.
        expect(recipes2.length, 1);
        expect(recipes2[0].text, 'Mock Recipe 2');
      },
    );

    test(
      'when deleting a recipe users can only delete their own recipes',
      () async {
        final sessionBuilder = unAuthSessionBuilder.copyWith(
          authentication: AuthenticationOverride.authenticationInfo('1', {}),
        );
        final session = sessionBuilder.build();

        await Recipe.db.insert(session, [
          Recipe(
            author: 'Gemini',
            text: 'Mock Recipe 1',
            date: DateTime.now(),
            userId: '1',
            ingredients: 'chicken, rice, broccoli',
          ),
          Recipe(
            author: 'Gemini',
            text: 'Mock Recipe 2',
            date: DateTime.now(),
            userId: '1',
            ingredients: 'chicken, rice, broccoli',
          ),
          Recipe(
            author: 'Gemini',
            text: 'Mock Recipe 3',
            date: DateTime.now(),
            userId: '2',
            ingredients: 'chicken, rice, broccoli',
          ),
        ]);

        // Find the first recipe to get its id.
        final recipeToDelete = await Recipe.db.findFirstRow(
          session,
          where: (t) => t.text.equals('Mock Recipe 1'),
        );

        // Delete the first recipe as the owner.
        await endpoints.recipes.deleteRecipe(
          sessionBuilder,
          recipeToDelete!.id!,
        );

        // Attempt to delete a recipe that is not owned by the authenticated user.
        final recipeYouShouldntDelete = await Recipe.db.findFirstRow(
          session,
          where: (t) => t.text.equals('Mock Recipe 3'),
        );

        expect(
          () => endpoints.recipes.deleteRecipe(
            sessionBuilder,
            recipeYouShouldntDelete!.id!,
          ),
          throwsA(isA<Exception>()),
        );
      },
    );

    // Verify that unauthenticated users cannot interact with the API.
    test(
      'when delete recipe with unauthenticated user, an exception is thrown',
      () async {
        expect(
          () => endpoints.recipes.deleteRecipe(unAuthSessionBuilder, 1),
          throwsA(isA<ServerpodUnauthenticatedException>()),
        );
      },
    );

    test(
      'when trying to generate a recipe as an unauthenticated user an exception is thrown',
      () async {
        expect(
          () => endpoints.recipes.generateRecipe(
            unAuthSessionBuilder,
            'chicken, rice, broccoli',
          ),
          throwsA(isA<ServerpodUnauthenticatedException>()),
        );
      },
    );

    test(
      'when trying to get recipes as an unauthenticated user an exception is thrown',
      () async {
        expect(
          () => endpoints.recipes.getRecipes(unAuthSessionBuilder),
          throwsA(isA<ServerpodUnauthenticatedException>()),
        );
      },
    );

    test('returns cached recipe if it exists', () async {
      final ai = MockRecipeAIService();
      final recipesEndpoint = RecipesEndpoint(ai);

      final sessionBuilder = unAuthSessionBuilder.copyWith(
        authentication: AuthenticationOverride.authenticationInfo('1', {}),
      );

      final session = sessionBuilder.build();

      final ingredients = 'chicken, rice, broccoli';

      final recipe = await recipesEndpoint.generateRecipe(
        session,
        ingredients,
      );

      expect(recipe.text, 'Mock Recipe');
      expect(ai.prompts.first, contains(ingredients));

      final cacheKey = 'recipe-$ingredients';
      final cache = await session.caches.local.get<Recipe>(cacheKey);
      expect(cache, isNotNull);
      expect(cache?.text, 'Mock Recipe');

      final recipe2 = await recipesEndpoint.generateRecipe(
        session,
        ingredients,
      );
      expect(recipe2.text, 'Mock Recipe');
      expect(recipe2.ingredients, equals(ingredients));
    });
  });
}
