import 'package:magic_recipe_server/src/generated/protocol.dart';
import 'package:magic_recipe_server/src/recipes/future_calls/remove_deleted_recipes_future_call.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Given RemoveDeletedRecipesFutureCall', (sessionBuilder, endpoints) {
    test('removes deleted recipes', () async {
      final db = sessionBuilder.build();

      // Insert test recipes
      await Recipe.db.insert(db, [
        Recipe(
          author: 'Gemini',
          text: 'Recipe 1',
          date: DateTime.now(),
          ingredients: 'ingredient1',
          deletedAt: DateTime.now(),
        ),
        Recipe(
          author: 'Gemini',
          text: 'Recipe 2',
          date: DateTime.now(),
          ingredients: 'ingredient2',
          deletedAt: null,
        ),
        Recipe(
          author: 'Gemini',
          text: 'Recipe 3',
          date: DateTime.now(),
          ingredients: 'ingredient3',
          deletedAt: DateTime.now(),
        ),
      ]);

      // Verify we have 3 recipes
      final before = await Recipe.db.find(db);
      expect(before, hasLength(3));

      // Execute the future call
      final futureCall = RemoveDeletedRecipesFutureCall();
      await futureCall.invoke(db, null);

      // Verify deleted recipes are removed
      final after = await Recipe.db.find(db);
      expect(after, hasLength(1));
      expect(after[0].text, 'Recipe 2');
    });
  });
}

