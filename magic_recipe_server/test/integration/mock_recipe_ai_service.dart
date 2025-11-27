import 'package:dartantic_interface/dartantic_interface.dart';
import 'package:magic_recipe_server/src/recipes/services/recipe_ai_service.dart';

class MockRecipeAIService extends RecipeAIService {
  MockRecipeAIService([this.output = 'Mock Recipe']);

  final String output;
  final List<String> prompts = [];
  final List<ChatMessage> history = [];

  @override
  Future<ChatResult<String>> generateContent(
    String prompt, {
    List<ChatMessage> history = const [],
    List<Part> attachments = const [],
  }) {
    prompts.add(prompt);
    this.history.addAll(history);
    return Future.value(ChatResult<String>(output: output));
  }
}
