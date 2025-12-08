import 'package:magic_recipe_server/server.dart';
import 'package:magic_recipe_server/src/auth/admin_endpoint_base.dart';
import 'package:magic_recipe_server/src/recipes/recipes.dart';
import 'package:serverpod/serverpod.dart';

class RecipesAdminEndpoint extends AdminEndpointBase {
  Future<void> triggerDeletedRecipeCleanup(Session session) async {
    // we can trigger a FutureCall directly
    await RemoveDeletedRecipesFutureCall().invoke(session, null);
  }

  Future<void> scheduleDeletedRecipeCleanup(Session session) async {
    // we can schedule a FutureCall outside of our server.dart file as well
    final pod = session.serverpod;

    await pod.futureCallWithDelay(
      FutureCallNames.rescheduleRemoveDeletedRecipes.name,
      null,
      Duration(seconds: 5),
    );
  }

  Future<void> stopCleanupTask(Session session) async {
    // using the key for the FutureCall we can also cancel existing FutureCalls
    final pod = session.serverpod;
    await pod.cancelFutureCall(
      FutureCallNames.rescheduleRemoveDeletedRecipes.name,
    );
  }
}
