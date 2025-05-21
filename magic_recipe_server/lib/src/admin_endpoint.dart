import 'package:magic_recipe_server/server.dart';
import 'package:magic_recipe_server/src/recipes/remove_deleted_recipes_future_call.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_server/module.dart';

class AdminEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  @override
  Set<Scope> get requiredScopes => {Scope.admin};

  Future<List<UserInfo>> listUsers(Session session) async {
    final users = await UserInfo.db.find(session);

    return users;
  }

  Future<void> blockUser(Session session, int userId) async {
    await Users.blockUser(session, userId);
  }

  Future<void> unblockUser(Session session, int userId) async {
    await Users.unblockUser(session, userId);
  }

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
    await pod
        .cancelFutureCall(FutureCallNames.rescheduleRemoveDeletedRecipes.name);
  }
}
