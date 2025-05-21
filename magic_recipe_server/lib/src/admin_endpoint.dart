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
}
