import 'dart:io';

import 'package:serverpod/serverpod.dart';

import 'package:magic_recipe_server/src/web/routes/root.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';

import 'src/generated/protocol.dart';
import 'src/generated/endpoints.dart';

// This is the starting point of your Serverpod server. In most cases, you will
// only need to make additions to this file if you add future calls,  are
// configuring Relic (Serverpod's web-server), or need custom setup work.

void run(List<String> args) async {
  // Initialize Serverpod and connect it with your generated code.
  final pod = Serverpod(args, Protocol(), Endpoints());

  // Configure server side sessions.
  final serverSideSessionsConfig = ServerSideSessionsConfig(
    sessionKeyHashPepper: pod.getPassword('sessionKeyHashPepper')!,
  );

  // Configure email identity provider.
  final emailIdpConfig = EmailIdpConfig(
    secretHashPepper: pod.getPassword('emailSecretHashPepper')!,
    sendRegistrationVerificationCode: _sendRegistrationCode,
    sendPasswordResetVerificationCode: _sendPasswordResetCode,
  );

  // Configure user profile.
  final userProfileConfig = UserProfileConfig(
    onAfterUserProfileCreated:
        (
          Session session,
          UserProfileModel userProfile, {
          required transaction,
        }) async {
          final email = userProfile.email;
          if (email == null) return;
          if (!email.endsWith('serverpod.dev')) return;
          // Add admin scope to the user
          await AuthServices.instance.authUsers.update(
            session,
            authUserId: userProfile.authUserId,
            scopes: {Scope.admin},
            transaction: transaction,
          );

          session.log(
            'User ${userProfile.email} created with admin scope',
            level: LogLevel.info,
          );
        },
  );

  pod.initializeAuthServices(
    tokenManagerBuilders: [
      serverSideSessionsConfig,
    ],
    identityProviderBuilders: [emailIdpConfig],
    userProfileConfig: userProfileConfig,
  );

  // Setup a default page at the web root.
  pod.webServer.addRoute(RootRoute(), '/');
  pod.webServer.addRoute(RootRoute(), '/index.html');
  // Serve all files in the web/static relative directory under /.
  final root = Directory(Uri(path: 'web/static').toFilePath());
  pod.webServer.addRoute(StaticRoute.directory(root), '/**');

  // Start the server.
  await pod.start();
}

void _sendRegistrationCode(
  Session session, {
  required String email,
  required UuidValue accountRequestId,
  required String verificationCode,
  required Transaction? transaction,
}) {
  // NOTE: Here you call your mail service to send the verification code to
  // the user. For testing, we will just log the verification code.
  session.log('[EmailIDP] Registration code ($email): $verificationCode');
}

void _sendPasswordResetCode(
  Session session, {
  required String email,
  required UuidValue passwordResetRequestId,
  required String verificationCode,
  required Transaction? transaction,
}) {
  // NOTE: Here you call your mail service to send the verification code to
  // the user. For testing, we will just log the verification code.
  session.log('[EmailIDP] Password reset code ($email): $verificationCode');
}
