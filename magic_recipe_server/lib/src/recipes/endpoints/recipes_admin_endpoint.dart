import 'package:magic_recipe_server/src/auth/admin_endpoint_base.dart';
import 'package:magic_recipe_server/src/generated/endpoints.dart';
import 'package:serverpod/serverpod.dart';

class RecipesAdminEndpoint extends AdminEndpointBase {
  Future<void> triggerDeletedRecipeCleanup(
    Session session, [
    String? params,
  ]) async {
    await pod.futureCalls
        .callWithDelay(Duration.zero)
        .recipes
        .removeDeletedRecipes();
  }

  Future<void> scheduleDeletedRecipeCleanup(
    Session session, [
    String? params,
  ]) async {
    await pod.futureCalls
        .callWithDelay(
          const Duration(seconds: 5),
          identifier: 'reschedule-remove-deleted-recipes',
        )
        .recipes
        .rescheduleRemoveDeletedRecipes();
  }

  Future<void> stopCleanupTask(
    Session session, [
    String? params,
  ]) async {
    await pod.futureCalls.cancel(
      'reschedule-remove-deleted-recipes',
    );
  }
}
