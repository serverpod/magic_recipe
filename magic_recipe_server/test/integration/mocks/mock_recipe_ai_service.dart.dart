import 'package:dartantic_interface/dartantic_interface.dart';
import 'package:magic_recipe_server/src/recipes/recipes.dart';

class MockRecipeAIService extends RecipeAIService {
  MockRecipeAIService([this.output = 'Mock Recipe']);

  final String output;
  final List<String> prompts = [];

  @override
  Future<ChatResult<String>> generateContent(
    String prompt, {
    List<Part> attachments = const [],
  }) {
    prompts.add(prompt);
    return Future.value(ChatResult<String>(output: output));
  }
}
