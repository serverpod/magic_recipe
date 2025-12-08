/// Exception thrown for recipe-related errors.
class RecipeException implements Exception {
  RecipeException(this.message);
  final String message;

  @override
  String toString() => 'RecipeException: $message';
}
