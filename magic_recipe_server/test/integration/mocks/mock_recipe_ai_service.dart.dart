import 'package:dartantic_ai/dartantic_ai.dart';
import 'package:magic_recipe_server/src/recipes/recipes.dart';

class MockRecipeAIService extends RecipeAIService {
  MockRecipeAIService([this.output = 'Mock Recipe']);

  final String output;
  final List<String> prompts = [];
  final List<Part> attachments = [];

  @override
  Future<ChatResult<String>> generateContent(
    String prompt, {
    List<Part> attachments = const [],
  }) {
    prompts.add(prompt);
    this.attachments.addAll(attachments);
    return Future.value(ChatResult<String>(output: output));
  }
}
