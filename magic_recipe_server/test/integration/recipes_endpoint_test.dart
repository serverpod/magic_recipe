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
  });
}
