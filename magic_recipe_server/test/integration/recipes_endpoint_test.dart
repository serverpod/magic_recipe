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

    test('throws on empty filename', () async {
      final authenticatedSession = sessionBuilder.copyWith(
        authentication: AuthenticationOverride.authenticationInfo('user-1', {}),
      );

      await expectLater(
        () => endpoints.recipes.getUploadDescription(authenticatedSession, ''),
        throwsA(isA<Exception>()),
      );

      await expectLater(
        () =>
            endpoints.recipes.getUploadDescription(authenticatedSession, '   '),
        throwsA(isA<Exception>()),
      );
    });

    test('throws on unauthenticated getUploadDescription', () async {
      await expectLater(
        () =>
            endpoints.recipes.getUploadDescription(sessionBuilder, 'test.jpg'),
        throwsA(isA<ServerpodUnauthenticatedException>()),
      );
    });

    test('getUploadDescription returns valid upload description and path',
        () async {
      final authenticatedSession = sessionBuilder.copyWith(
        authentication: AuthenticationOverride.authenticationInfo('user-1', {}),
      );

      final (description, path) = await endpoints.recipes
          .getUploadDescription(authenticatedSession, 'test.jpg');

      expect(description, isNotNull);
      expect(path, isNotEmpty);
      expect(path, contains('uploads/'));
      expect(path, endsWith('test.jpg'));
    });

    test('verifyUpload returns false for non-existent path', () async {
      final authenticatedSession = sessionBuilder.copyWith(
        authentication: AuthenticationOverride.authenticationInfo('user-1', {}),
      );

      final result = await endpoints.recipes
          .verifyUpload(authenticatedSession, 'uploads/non-existent.jpg');

      expect(result, isFalse);
    });

    test('throws on unauthenticated verifyUpload', () async {
      await expectLater(
        () => endpoints.recipes.verifyUpload(sessionBuilder, 'test.jpg'),
        throwsA(isA<ServerpodUnauthenticatedException>()),
      );
    });

    test('getPublicUrlForPath returns valid URL', () async {
      final authenticatedSession = sessionBuilder.copyWith(
        authentication: AuthenticationOverride.authenticationInfo('user-1', {}),
      );

      final path = 'uploads/test-image.jpg';
      final url = await endpoints.recipes
          .getPublicUrlForPath(authenticatedSession, path);

      expect(url, isNotEmpty);
      expect(Uri.tryParse(url), isNotNull);
    });

    test('throws on unauthenticated getPublicUrlForPath', () async {
      await expectLater(
        () => endpoints.recipes.getPublicUrlForPath(sessionBuilder, 'test.jpg'),
        throwsA(isA<ServerpodUnauthenticatedException>()),
      );
    });
  });
}

