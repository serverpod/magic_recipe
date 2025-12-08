/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _i2;
import 'dart:async' as _i3;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _i4;
import 'package:magic_recipe_client/src/protocol/recipes/models/recipe.dart'
    as _i5;
import 'protocol.dart' as _i6;

/// Base class for admin endpoints that require authentication and admin scope.
/// {@category Endpoint}
abstract class EndpointAdminEndpointBase extends _i1.EndpointRef {
  EndpointAdminEndpointBase(_i1.EndpointCaller caller) : super(caller);
}

/// {@category Endpoint}
class EndpointEmailIDP extends _i2.EndpointEmailIdpBase {
  EndpointEmailIDP(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'emailIDP';

  /// Logs in the user and returns a new session.
  ///
  /// Throws an [EmailAccountLoginException] in case of errors, with reason:
  /// - [EmailAccountLoginExceptionReason.invalidCredentials] if the email or
  ///   password is incorrect.
  /// - [EmailAccountLoginExceptionReason.tooManyAttempts] if there have been
  ///   too many failed login attempts.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  @override
  _i3.Future<_i4.AuthSuccess> login({
    required String email,
    required String password,
  }) => caller.callServerEndpoint<_i4.AuthSuccess>(
    'emailIDP',
    'login',
    {
      'email': email,
      'password': password,
    },
  );

  /// Starts the registration for a new user account with an email-based login
  /// associated to it.
  ///
  /// Upon successful completion of this method, an email will have been
  /// sent to [email] with a verification link, which the user must open to
  /// complete the registration.
  ///
  /// Always returns a account request ID, which can be used to complete the
  /// registration. If the email is already registered, the returned ID will not
  /// be valid.
  @override
  _i3.Future<_i1.UuidValue> startRegistration({required String email}) =>
      caller.callServerEndpoint<_i1.UuidValue>(
        'emailIDP',
        'startRegistration',
        {'email': email},
      );

  /// Verifies an account request code and returns a token
  /// that can be used to complete the account creation.
  ///
  /// Throws an [EmailAccountRequestException] in case of errors, with reason:
  /// - [EmailAccountRequestExceptionReason.expired] if the account request has
  ///   already expired.
  /// - [EmailAccountRequestExceptionReason.policyViolation] if the password
  ///   does not comply with the password policy.
  /// - [EmailAccountRequestExceptionReason.invalid] if no request exists
  ///   for the given [accountRequestId] or [verificationCode] is invalid.
  @override
  _i3.Future<String> verifyRegistrationCode({
    required _i1.UuidValue accountRequestId,
    required String verificationCode,
  }) => caller.callServerEndpoint<String>(
    'emailIDP',
    'verifyRegistrationCode',
    {
      'accountRequestId': accountRequestId,
      'verificationCode': verificationCode,
    },
  );

  /// Completes a new account registration, creating a new auth user with a
  /// profile and attaching the given email account to it.
  ///
  /// Throws an [EmailAccountRequestException] in case of errors, with reason:
  /// - [EmailAccountRequestExceptionReason.expired] if the account request has
  ///   already expired.
  /// - [EmailAccountRequestExceptionReason.policyViolation] if the password
  ///   does not comply with the password policy.
  /// - [EmailAccountRequestExceptionReason.invalid] if the [registrationToken]
  ///   is invalid.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  ///
  /// Returns a session for the newly created user.
  @override
  _i3.Future<_i4.AuthSuccess> finishRegistration({
    required String registrationToken,
    required String password,
  }) => caller.callServerEndpoint<_i4.AuthSuccess>(
    'emailIDP',
    'finishRegistration',
    {
      'registrationToken': registrationToken,
      'password': password,
    },
  );

  /// Requests a password reset for [email].
  ///
  /// If the email address is registered, an email with reset instructions will
  /// be send out. If the email is unknown, this method will have no effect.
  ///
  /// Always returns a password reset request ID, which can be used to complete
  /// the reset. If the email is not registered, the returned ID will not be
  /// valid.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case of errors, with reason:
  /// - [EmailAccountPasswordResetExceptionReason.tooManyAttempts] if the user has
  ///   made too many attempts trying to request a password reset.
  ///
  @override
  _i3.Future<_i1.UuidValue> startPasswordReset({required String email}) =>
      caller.callServerEndpoint<_i1.UuidValue>(
        'emailIDP',
        'startPasswordReset',
        {'email': email},
      );

  /// Verifies a password reset code and returns a finishPasswordResetToken
  /// that can be used to finish the password reset.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case of errors, with reason:
  /// - [EmailAccountPasswordResetExceptionReason.expired] if the password reset
  ///   request has already expired.
  /// - [EmailAccountPasswordResetExceptionReason.tooManyAttempts] if the user has
  ///   made too many attempts trying to verify the password reset.
  /// - [EmailAccountPasswordResetExceptionReason.invalid] if no request exists
  ///   for the given [passwordResetRequestId] or [verificationCode] is invalid.
  ///
  /// If multiple steps are required to complete the password reset, this endpoint
  /// should be overridden to return credentials for the next step instead
  /// of the credentials for setting the password.
  @override
  _i3.Future<String> verifyPasswordResetCode({
    required _i1.UuidValue passwordResetRequestId,
    required String verificationCode,
  }) => caller.callServerEndpoint<String>(
    'emailIDP',
    'verifyPasswordResetCode',
    {
      'passwordResetRequestId': passwordResetRequestId,
      'verificationCode': verificationCode,
    },
  );

  /// Completes a password reset request by setting a new password.
  ///
  /// The [verificationCode] returned from [verifyPasswordResetCode] is used to
  /// validate the password reset request.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case of errors, with reason:
  /// - [EmailAccountPasswordResetExceptionReason.expired] if the password reset
  ///   request has already expired.
  /// - [EmailAccountPasswordResetExceptionReason.policyViolation] if the new
  ///   password does not comply with the password policy.
  /// - [EmailAccountPasswordResetExceptionReason.invalid] if no request exists
  ///   for the given [passwordResetRequestId] or [verificationCode] is invalid.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  @override
  _i3.Future<void> finishPasswordReset({
    required String finishPasswordResetToken,
    required String newPassword,
  }) => caller.callServerEndpoint<void>(
    'emailIDP',
    'finishPasswordReset',
    {
      'finishPasswordResetToken': finishPasswordResetToken,
      'newPassword': newPassword,
    },
  );
}

/// Endpoint for managing admin users.
/// {@category Endpoint}
class EndpointAdmin extends EndpointAdminEndpointBase {
  EndpointAdmin(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'admin';

  /// List all admin users.
  _i3.Future<
    List<({_i4.AuthUserModel authUser, _i4.UserProfileModel userProfile})>
  >
  listUsers() =>
      caller.callServerEndpoint<
        List<({_i4.AuthUserModel authUser, _i4.UserProfileModel userProfile})>
      >(
        'admin',
        'listUsers',
        {},
      );

  /// List all auth users.
  _i3.Future<List<_i4.AuthUserModel>> listAuthUsers() =>
      caller.callServerEndpoint<List<_i4.AuthUserModel>>(
        'admin',
        'listAuthUsers',
        {},
      );

  /// Block a user by its [userId].
  _i3.Future<void> blockUser(_i1.UuidValue userId) =>
      caller.callServerEndpoint<void>(
        'admin',
        'blockUser',
        {'userId': userId},
      );

  /// Unblock a user by its [userId].
  _i3.Future<void> unblockUser(_i1.UuidValue userId) =>
      caller.callServerEndpoint<void>(
        'admin',
        'unblockUser',
        {'userId': userId},
      );
}

/// {@category Endpoint}
class EndpointRecipesAdmin extends EndpointAdminEndpointBase {
  EndpointRecipesAdmin(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'recipesAdmin';

  _i3.Future<void> triggerDeletedRecipeCleanup() =>
      caller.callServerEndpoint<void>(
        'recipesAdmin',
        'triggerDeletedRecipeCleanup',
        {},
      );

  _i3.Future<void> scheduleDeletedRecipeCleanup() =>
      caller.callServerEndpoint<void>(
        'recipesAdmin',
        'scheduleDeletedRecipeCleanup',
        {},
      );

  _i3.Future<void> stopCleanupTask() => caller.callServerEndpoint<void>(
    'recipesAdmin',
    'stopCleanupTask',
    {},
  );
}

/// This is the endpoint that will be used to generate a recipe using the
/// Google Gemini API. It extends the Endpoint class and implements the
/// generateRecipe method.
/// Endpoint for AI-powered recipe generation using Gemini.
/// Uses dependency-injected RecipeAIService, or falls back to API key from passwords.
/// {@category Endpoint}
class EndpointRecipes extends _i1.EndpointRef {
  EndpointRecipes(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'recipes';

  /// Accepts a string containing ingredients and returns a generated Recipe.
  _i3.Future<_i5.Recipe> generateRecipe(String ingredients) =>
      caller.callServerEndpoint<_i5.Recipe>(
        'recipes',
        'generateRecipe',
        {'ingredients': ingredients},
      );

  /// Returns a list of all recipes.
  _i3.Future<List<_i5.Recipe>> getRecipes() =>
      caller.callServerEndpoint<List<_i5.Recipe>>(
        'recipes',
        'getRecipes',
        {},
      );

  /// Delete a recipe by its [recipeId].
  _i3.Future<void> deleteRecipe(int recipeId) =>
      caller.callServerEndpoint<void>(
        'recipes',
        'deleteRecipe',
        {'recipeId': recipeId},
      );
}

class Modules {
  Modules(Client client) {
    serverpod_auth_idp = _i2.Caller(client);
    serverpod_auth_core = _i4.Caller(client);
  }

  late final _i2.Caller serverpod_auth_idp;

  late final _i4.Caller serverpod_auth_core;
}

class Client extends _i1.ServerpodClientShared {
  Client(
    String host, {
    dynamic securityContext,
    _i1.AuthenticationKeyManager? authenticationKeyManager,
    Duration? streamingConnectionTimeout,
    Duration? connectionTimeout,
    Function(
      _i1.MethodCallContext,
      Object,
      StackTrace,
    )?
    onFailedCall,
    Function(_i1.MethodCallContext)? onSucceededCall,
    bool? disconnectStreamsOnLostInternetConnection,
  }) : super(
         host,
         _i6.Protocol(),
         securityContext: securityContext,
         authenticationKeyManager: authenticationKeyManager,
         streamingConnectionTimeout: streamingConnectionTimeout,
         connectionTimeout: connectionTimeout,
         onFailedCall: onFailedCall,
         onSucceededCall: onSucceededCall,
         disconnectStreamsOnLostInternetConnection:
             disconnectStreamsOnLostInternetConnection,
       ) {
    emailIDP = EndpointEmailIDP(this);
    admin = EndpointAdmin(this);
    recipesAdmin = EndpointRecipesAdmin(this);
    recipes = EndpointRecipes(this);
    modules = Modules(this);
  }

  late final EndpointEmailIDP emailIDP;

  late final EndpointAdmin admin;

  late final EndpointRecipesAdmin recipesAdmin;

  late final EndpointRecipes recipes;

  late final Modules modules;

  @override
  Map<String, _i1.EndpointRef> get endpointRefLookup => {
    'emailIDP': emailIDP,
    'admin': admin,
    'recipesAdmin': recipesAdmin,
    'recipes': recipes,
  };

  @override
  Map<String, _i1.ModuleEndpointCaller> get moduleLookup => {
    'serverpod_auth_idp': modules.serverpod_auth_idp,
    'serverpod_auth_core': modules.serverpod_auth_core,
  };
}
