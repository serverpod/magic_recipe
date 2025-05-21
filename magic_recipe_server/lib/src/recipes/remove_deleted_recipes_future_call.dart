import 'package:magic_recipe_server/src/generated/protocol.dart';
import 'package:serverpod/serverpod.dart';

/// This future call is used to remove deleted recipes from the database.
///
/// This is useful to clean up the database and remove any recipes that were
/// deleted by the user.
class RemoveDeletedRecipesFutureCall extends FutureCall {
  @override
  Future<void> invoke(Session session, SerializableModel? _) async {
    final deletedRecipes = await Recipe.db.deleteWhere(session,
        where: (RecipeTable recipe) => recipe.deletedAt.notEquals(null));
    // You could also only delete recipes that were deleted more than 1 day ago.
    // This would allow you to keep the recipes in the database for a little
    // longer, so that users can still recover them if they want.
    session.log('Deleted ${deletedRecipes.length} recipes during cleanup');
  }
}
