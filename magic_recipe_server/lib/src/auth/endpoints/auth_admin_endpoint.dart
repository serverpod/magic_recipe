import 'package:magic_recipe_server/src/auth/admin_endpoint_base.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';

typedef AdminUser = (AuthUserModel, UserProfileModel);

class AuthAdminEndpoint extends AdminEndpointBase {
  Future<List<AdminUser>> listUsers(Session session) async {
    final adminUsers = <AdminUser>[];
    try {
      final users = await AuthServices.instance.userProfiles.admin
          .listUserProfiles(session);
      for (var user in users) {
        final authUser = await AuthServices.instance.authUsers.get(
          session,
          authUserId: user.authUserId,
        );
        adminUsers.add((authUser, user));
      }
    } catch (e) {
      session.log('Error getting auth users: $e');
    }

    return adminUsers;
  }

  Future<List<AuthUserModel>> listAuthUsers(Session session) async {
    final users = await AuthServices.instance.authUsers.list(session);
    return users;
  }

  Future<void> blockUser(Session session, UuidValue userId) async {
    await AuthServices.instance.authUsers.update(
      session,
      authUserId: userId,
      blocked: true,
    );
  }

  Future<void> unblockUser(Session session, UuidValue userId) async {
    await AuthServices.instance.authUsers.update(
      session,
      authUserId: userId,
      blocked: false,
    );
  }
}

