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
  final pod = Serverpod(
    args,
    Protocol(),
    Endpoints(),
  );

  // Configure our token managers.
  final authSessionsConfig = AuthSessionsConfig(
    sessionKeyHashPepper: pod.getPassword('authSessionsSessionKeyHashPepper')!,
  );

  final emailIDPConfig = EmailIDPConfig(
    secretHashPepper: pod.getPassword('emailSecretHashPepper')!,
    sendRegistrationVerificationCode: (
      session, {
      required accountRequestId,
      required email,
      required transaction,
      required verificationCode,
    }) {
      session.log('Registration verification code: $verificationCode');
    },
    sendPasswordResetVerificationCode: (
      session, {
      required email,
      required passwordResetRequestId,
      required transaction,
      required verificationCode,
    }) async {
      session.log('Password reset verification code: $verificationCode');
    },
  );

  final userProfileConfig = UserProfileConfig();

  final authServices = AuthServices.set(
    primaryTokenManager: AuthSessionsTokenManagerFactory(authSessionsConfig),
    identityProviders: [
      EmailIdentityProviderFactory(emailIDPConfig),
    ],
    userProfileConfig: userProfileConfig,
  );

  pod.authenticationHandler = authServices.authenticationHandler;

  // Setup a default page at the web root.
  pod.webServer.addRoute(RootRoute(), '/');
  pod.webServer.addRoute(RootRoute(), '/index.html');
  // Serve all files in the web/static relative directory under /.
  final root = Directory(Uri(path: 'web/static').toFilePath());
  pod.webServer.addRoute(StaticRoute.directory(root), '/**');

  // Start the server.
  await pod.start();
}

/// Names of all future calls in the server.
///
/// This is better than using a string literal, as it will reduce the risk of
/// typos and make it easier to refactor the code.
enum FutureCallNames { birthdayReminder }
