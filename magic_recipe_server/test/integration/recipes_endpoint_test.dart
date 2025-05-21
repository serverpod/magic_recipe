import 'package:magic_recipe_server/src/generated/protocol.dart';
import 'package:magic_recipe_server/src/recipes/recipes_endpoint.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

Future expectException(
    Future<void> Function() function, Matcher matcher) async {
  late var actualException;
  try {
    await function();
  } catch (e) {
    actualException = e;
  }
  expect(actualException, matcher);
}

void main() {
  withServerpod('Given Recipes Endpoint', (unAuthSessionBuilder, endpoints) {
    test(
        'When calling generateRecipe with ingredients, gemini is called with a prompt'
        ' which includes the ingredients', () async {
      final sessionBuilder = unAuthSessionBuilder.copyWith(
          authentication: AuthenticationOverride.authenticationInfo(1, {}));

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
      final sessionBuilder = unAuthSessionBuilder.copyWith(
          authentication: AuthenticationOverride.authenticationInfo(1, {}));
      final session = sessionBuilder.build();

      // drop all recipes
      await Recipe.db.deleteWhere(session, where: (t) => t.id.notEquals(null));

      // create a recipe
      final firstRecipe = Recipe(
          author: 'Gemini',
          text: 'Mock Recipe 1',
          date: DateTime.now(),
          userId: 1,
          ingredients: 'chicken, rice, broccoli');

      await Recipe.db.insertRow(session, firstRecipe);

      // create a second recipe
      final secondRecipe = Recipe(
          author: 'Gemini',
          text: 'Mock Recipe 2',
          date: DateTime.now(),
          userId: 1,
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

    test('when deleting a recipe users can only delete their own recipes',
        () async {
      final sessionBuilder = unAuthSessionBuilder.copyWith(
          authentication: AuthenticationOverride.authenticationInfo(1, {}));
      final session = sessionBuilder.build();

      await Recipe.db.insert(session, [
        Recipe(
            author: 'Gemini',
            text: 'Mock Recipe 1',
            date: DateTime.now(),
            userId: 1,
            ingredients: 'chicken, rice, broccoli'),
        Recipe(
            author: 'Gemini',
            text: 'Mock Recipe 2',
            date: DateTime.now(),
            userId: 1,
            ingredients: 'chicken, rice, broccoli'),
        Recipe(
            author: 'Gemini',
            text: 'Mock Recipe 3',
            date: DateTime.now(),
            userId: 2,
            ingredients: 'chicken, rice, broccoli'),
      ]);

      // get the first recipe to get its id
      final recipeToDelete = await Recipe.db.findFirstRow(
        session,
        where: (t) => t.text.equals('Mock Recipe 1'),
      );

      // delete the first recipe
      await endpoints.recipes.deleteRecipe(sessionBuilder, recipeToDelete!.id!);

      // try to delete a recipe that is not yours

      final recipeYouShouldntDelete = await Recipe.db.findFirstRow(
        session,
        where: (t) => t.text.equals('Mock Recipe 3'),
      );

      await expectException(
        () => endpoints.recipes
            .deleteRecipe(sessionBuilder, recipeYouShouldntDelete!.id!),
        isA<Exception>(),
      );
    });

    // verify unauthenticated users cannot interact with the API
    test('when delete recipe with unauthenticated user, an exception is thrown',
        () async {
      await expectException(
        () => endpoints.recipes.deleteRecipe(unAuthSessionBuilder, 1),
        isA<ServerpodUnauthenticatedException>(),
      );
    });

    test(
        'when trying to generate a recipe as an unauthenticated user an exception is thrown',
        () async {
      await expectException(
        () => endpoints.recipes
            .generateRecipe(unAuthSessionBuilder, 'chicken, rice, broccoli'),
        isA<ServerpodUnauthenticatedException>(),
      );
    });

    test(
        'when trying to get recipes as an unauthenticated user an exception is thrown',
        () async {
      await expectException(
        () => endpoints.recipes.getRecipes(unAuthSessionBuilder),
        isA<ServerpodUnauthenticatedException>(),
      );
    });

    test('returns cached recipe if it exists', () async {
      final sessionBuilder = unAuthSessionBuilder.copyWith(
          authentication: AuthenticationOverride.authenticationInfo(1, {}));
      final session = sessionBuilder.build();

      String capturedPrompt = '';
      final ingredients = 'chicken, rice, broccoli';

      generateContent = (_, prompt) {
        capturedPrompt = prompt;
        return Future.value('Mock Recipe');
      };

      final recipe =
          await endpoints.recipes.generateRecipe(sessionBuilder, ingredients);
      expect(recipe.text, 'Mock Recipe');
      expect(capturedPrompt, contains(ingredients));
      final cache = await session.caches.local
          .get<Recipe>('recipe-${ingredients.hashCode}');
      expect(cache, isNotNull);
      expect(cache?.text, 'Mock Recipe');

      // reset
      capturedPrompt = '';

      // Call the endpoint again with the same ingredients
      final recipe2 =
          await endpoints.recipes.generateRecipe(sessionBuilder, ingredients);
      expect(recipe2.text, 'Mock Recipe');
      expect(capturedPrompt, equals(''));
    });
  });
}
