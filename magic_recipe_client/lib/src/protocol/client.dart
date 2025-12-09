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
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _i1;
import 'package:serverpod_client/serverpod_client.dart' as _i2;
import 'dart:async' as _i3;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _i4;
import 'package:magic_recipe_client/src/protocol/recipes/models/recipe.dart'
    as _i5;
import 'package:serverpod_auth_client/serverpod_auth_client.dart' as _i6;
import 'protocol.dart' as _i7;

/// Base class for admin endpoints that require authentication and admin scope.
/// {@category Endpoint}
abstract class EndpointAdminEndpointBase extends _i2.EndpointRef {
  EndpointAdminEndpointBase(_i2.EndpointCaller caller) : super(caller);
}

/// {@category Endpoint}
class EndpointEmailIDP extends _i1.EndpointEmailIdpBase {
  EndpointEmailIDP(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'emailIDP';

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

  @override
  _i3.Future<_i2.UuidValue> startRegistration({required String email}) =>
      caller.callServerEndpoint<_i2.UuidValue>(
        'emailIDP',
        'startRegistration',
        {'email': email},
      );

  @override
  _i3.Future<String> verifyRegistrationCode({
    required _i2.UuidValue accountRequestId,
    required String verificationCode,
  }) => caller.callServerEndpoint<String>(
    'emailIDP',
    'verifyRegistrationCode',
    {
      'accountRequestId': accountRequestId,
      'verificationCode': verificationCode,
    },
  );

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

  @override
  _i3.Future<_i2.UuidValue> startPasswordReset({required String email}) =>
      caller.callServerEndpoint<_i2.UuidValue>(
        'emailIDP',
        'startPasswordReset',
        {'email': email},
      );

  @override
  _i3.Future<String> verifyPasswordResetCode({
    required _i2.UuidValue passwordResetRequestId,
    required String verificationCode,
  }) => caller.callServerEndpoint<String>(
    'emailIDP',
    'verifyPasswordResetCode',
    {
      'passwordResetRequestId': passwordResetRequestId,
      'verificationCode': verificationCode,
    },
  );

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

  @override
  _i3.Future<bool> hasAccount() => caller.callServerEndpoint<bool>(
    'emailIDP',
    'hasAccount',
    {},
  );
}

/// Endpoint for managing admin users.
/// {@category Endpoint}
class EndpointAdmin extends EndpointAdminEndpointBase {
  EndpointAdmin(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'admin';

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

  _i3.Future<List<_i4.AuthUserModel>> listAuthUsers() =>
      caller.callServerEndpoint<List<_i4.AuthUserModel>>(
        'admin',
        'listAuthUsers',
        {},
      );

  _i3.Future<void> blockUser(_i2.UuidValue userId) =>
      caller.callServerEndpoint<void>(
        'admin',
        'blockUser',
        {'userId': userId},
      );

  _i3.Future<void> unblockUser(_i2.UuidValue userId) =>
      caller.callServerEndpoint<void>(
        'admin',
        'unblockUser',
        {'userId': userId},
      );
}

/// {@category Endpoint}
class EndpointRecipesAdmin extends EndpointAdminEndpointBase {
  EndpointRecipesAdmin(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'recipesAdmin';

  _i3.Future<void> triggerDeletedRecipeCleanup([String? params]) =>
      caller.callServerEndpoint<void>(
        'recipesAdmin',
        'triggerDeletedRecipeCleanup',
        {'params': params},
      );

  _i3.Future<void> scheduleDeletedRecipeCleanup([String? params]) =>
      caller.callServerEndpoint<void>(
        'recipesAdmin',
        'scheduleDeletedRecipeCleanup',
        {'params': params},
      );

  _i3.Future<void> stopCleanupTask([String? params]) =>
      caller.callServerEndpoint<void>(
        'recipesAdmin',
        'stopCleanupTask',
        {'params': params},
      );
}

/// This is the endpoint that will be used to generate a recipe using the
/// Google Gemini API. It extends the Endpoint class and implements the
/// generateRecipe method.
/// Endpoint for AI-powered recipe generation using Gemini.
/// Uses dependency-injected RecipeAIService, or falls back to API key from passwords.
/// {@category Endpoint}
class EndpointRecipes extends _i2.EndpointRef {
  EndpointRecipes(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'recipes';

  /// Accepts a string containing ingredients and returns a generated Recipe.
  _i3.Future<_i5.Recipe> generateRecipe(
    String ingredients, [
    String? imagePath,
  ]) => caller.callServerEndpoint<_i5.Recipe>(
    'recipes',
    'generateRecipe',
    {
      'ingredients': ingredients,
      'imagePath': imagePath,
    },
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

  _i3.Future<(String?, String)> getUploadDescription(String filename) =>
      caller.callServerEndpoint<(String?, String)>(
        'recipes',
        'getUploadDescription',
        {'filename': filename},
      );

  _i3.Future<bool> verifyUpload(String path) => caller.callServerEndpoint<bool>(
    'recipes',
    'verifyUpload',
    {'path': path},
  );

  _i3.Future<String> getPublicUrlForPath(String path) =>
      caller.callServerEndpoint<String>(
        'recipes',
        'getPublicUrlForPath',
        {'path': path},
      );
}

class Modules {
  Modules(Client client) {
    auth = _i6.Caller(client);
    serverpod_auth_idp = _i1.Caller(client);
    serverpod_auth_core = _i4.Caller(client);
  }

  late final _i6.Caller auth;

  late final _i1.Caller serverpod_auth_idp;

  late final _i4.Caller serverpod_auth_core;
}

class Client extends _i2.ServerpodClientShared {
  Client(
    String host, {
    dynamic securityContext,
    _i2.AuthenticationKeyManager? authenticationKeyManager,
    Duration? streamingConnectionTimeout,
    Duration? connectionTimeout,
    Function(
      _i2.MethodCallContext,
      Object,
      StackTrace,
    )?
    onFailedCall,
    Function(_i2.MethodCallContext)? onSucceededCall,
    bool? disconnectStreamsOnLostInternetConnection,
  }) : super(
         host,
         _i7.Protocol(),
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
  Map<String, _i2.EndpointRef> get endpointRefLookup => {
    'emailIDP': emailIDP,
    'admin': admin,
    'recipesAdmin': recipesAdmin,
    'recipes': recipes,
  };

  @override
  Map<String, _i2.ModuleEndpointCaller> get moduleLookup => {
    'auth': modules.auth,
    'serverpod_auth_idp': modules.serverpod_auth_idp,
    'serverpod_auth_core': modules.serverpod_auth_core,
  };
}
