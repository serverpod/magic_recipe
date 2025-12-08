import 'package:magic_recipe_server/src/auth/admin_endpoint_base.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';

typedef AdminUser = ({AuthUserModel authUser, UserProfileModel userProfile});

/// Endpoint for managing admin users.
class AdminEndpoint extends AdminEndpointBase {
  /// List all admin users.
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
        adminUsers.add((authUser: authUser, userProfile: user));
      }
    } catch (e) {
      session.log('Error getting auth users: $e');
    }

    return adminUsers;
  }

  /// List all auth users.
  Future<List<AuthUserModel>> listAuthUsers(Session session) async {
    final users = await AuthServices.instance.authUsers.list(session);
    return users;
  }

  /// Block a user by its [userId].
  Future<void> blockUser(Session session, UuidValue userId) async {
    await AuthServices.instance.authUsers.update(
      session,
      authUserId: userId,
      blocked: true,
    );
  }

  /// Unblock a user by its [userId].
  Future<void> unblockUser(Session session, UuidValue userId) async {
    await AuthServices.instance.authUsers.update(
      session,
      authUserId: userId,
      blocked: false,
    );
  }
}
