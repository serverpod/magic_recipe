import 'package:magic_recipe_server/src/generated/future_calls.dart';
import 'package:magic_recipe_server/src/generated/recipes/models/recipe.dart';
import 'package:serverpod/serverpod.dart';

class RecipesFutureCall extends FutureCall {
  Future<void> removeDeletedRecipes(
    Session session, [
    String? params,
  ]) async {
    final deletedRecipes = await Recipe.db.deleteWhere(
      session,
      where: (RecipeTable recipe) => recipe.deletedAt.notEquals(null),
    );
    session.log('Deleted ${deletedRecipes.length} recipes during cleanup');
  }

  Future<void> rescheduleRemoveDeletedRecipes(
    Session session, [
    String? params,
  ]) async {
    await removeDeletedRecipes(session);

    await session.serverpod.futureCalls.cancel(
      'reschedule-remove-deleted-recipes',
    );

    await session.serverpod.futureCalls
        .callWithDelay(
          const Duration(minutes: 5),
          identifier: 'reschedule-remove-deleted-recipes',
        )
        .recipes
        .rescheduleRemoveDeletedRecipes(null);

    session.log(
      'Rescheduled future call to remove deleted recipes in 5 minutes',
    );
  }
}
