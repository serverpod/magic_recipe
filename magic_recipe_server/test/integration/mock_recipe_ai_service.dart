import 'package:dartantic_interface/dartantic_interface.dart';
import 'package:magic_recipe_server/src/recipes/services/recipe_ai_service.dart';

class MockRecipeAIService extends RecipeAIService {
  MockRecipeAIService([this.output = 'Mock Recipe']);

  final String output;
  final List<String> prompts = [];
  final List<ChatMessage> history = [];
  final List<DataPart> attachments = [];

  @override
  Future<ChatResult<String>> generateContent(
    String prompt, {
    List<ChatMessage> history = const [],
    List<Part> attachments = const [],
  }) {
    return _handleGenerate(prompt, history: history, attachments: attachments);
  }

  @override
  Stream<ChatResult<String>> generateContentStream(
    String prompt, {
    List<ChatMessage> history = const [],
    List<DataPart> attachments = const [],
  }) {
    return _handleStream(prompt, history: history, attachments: attachments);
  }

  Future<ChatResult<String>> _handleGenerate(
    String prompt, {
    List<ChatMessage> history = const [],
    List<Part> attachments = const [],
  }) async {
    prompts.add(prompt);
    this.history.addAll(history);
    return ChatResult<String>(output: output);
  }

  Stream<ChatResult<String>> _handleStream(
    String prompt, {
    List<ChatMessage> history = const [],
    List<DataPart> attachments = const [],
  }) {
    prompts.add(prompt);
    this.history.addAll(history);
    this.attachments.addAll(attachments);
    return Stream.value(ChatResult<String>(output: output));
  }
}
