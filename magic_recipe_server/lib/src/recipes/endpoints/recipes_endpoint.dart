import 'package:dartantic_ai/dartantic_ai.dart';
import 'package:serverpod/serverpod.dart';

/// This is the endpoint that will be used to generate a recipe using the
/// Google Gemini API. It extends the Endpoint class and implements the
/// generateRecipe method.
class RecipeEndpoint extends Endpoint {
  /// Pass in a string containing the ingredients and get a recipe back.
  Future<String> generateRecipe(Session session, String ingredients) async {
    // Serverpod automatically loads your passwords.yaml file and makes the passwords available
    // in the session.passwords map.
    final geminiApiKey = session.passwords['geminiApiKey'];
    if (geminiApiKey == null) {
      throw Exception('Gemini API key not found');
    }

    // Configure the Dartantic AI agent for Gemini before sending the prompt.
    final agent = Agent.forProvider(
      GoogleProvider(apiKey: geminiApiKey),
      chatModelName: 'gemini-2.5-flash-lite',
    );

    // A prompt to generate a recipe, the user will provide a free text input with the ingredients.
    final prompt =
        'Generate a recipe using the following ingredients: $ingredients. '
        'Always put the title of the recipe in the first line, and then the instructions. '
        'The recipe should be easy to follow and include all necessary steps. '
        'Please provide a detailed recipe.';

    final response = await agent.send(prompt);

    final responseText = response.output;

    // Check if the response is empty.
    if (responseText.isEmpty) {
      throw Exception('No response from Gemini API');
    }

    return responseText;
  }
}
