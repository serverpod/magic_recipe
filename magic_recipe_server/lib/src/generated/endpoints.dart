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
import 'package:serverpod/serverpod.dart' as _i1;
import '../auth/email_idp_endpoint.dart' as _i2;
import '../auth/endpoints/admin_endpoint.dart' as _i3;
import '../recipes/endpoints/recipes_admin_endpoint.dart' as _i4;
import '../recipes/endpoints/recipes_endpoint.dart' as _i5;
import 'package:magic_recipe_server/src/generated/protocol.dart' as _i6;
import 'package:serverpod_auth_server/serverpod_auth_server.dart' as _i7;
import 'package:serverpod_auth_idp_server/serverpod_auth_idp_server.dart'
    as _i8;
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    as _i9;
import 'package:magic_recipe_server/src/generated/future_calls.dart' as _i10;
export 'future_calls.dart' show ServerpodFutureCallsGetter;

class Endpoints extends _i1.EndpointDispatch {
  @override
  void initializeEndpoints(_i1.Server server) {
    var endpoints = <String, _i1.Endpoint>{
      'emailIDP': _i2.EmailIDPEndpoint()
        ..initialize(
          server,
          'emailIDP',
          null,
        ),
      'admin': _i3.AdminEndpoint()
        ..initialize(
          server,
          'admin',
          null,
        ),
      'recipesAdmin': _i4.RecipesAdminEndpoint()
        ..initialize(
          server,
          'recipesAdmin',
          null,
        ),
      'recipes': _i5.RecipesEndpoint()
        ..initialize(
          server,
          'recipes',
          null,
        ),
    };
    connectors['emailIDP'] = _i1.EndpointConnector(
      name: 'emailIDP',
      endpoint: endpoints['emailIDP']!,
      methodConnectors: {
        'login': _i1.MethodConnector(
          name: 'login',
          params: {
            'email': _i1.ParameterDescription(
              name: 'email',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'password': _i1.ParameterDescription(
              name: 'password',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIDP'] as _i2.EmailIDPEndpoint).login(
                session,
                email: params['email'],
                password: params['password'],
              ),
        ),
        'startRegistration': _i1.MethodConnector(
          name: 'startRegistration',
          params: {
            'email': _i1.ParameterDescription(
              name: 'email',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIDP'] as _i2.EmailIDPEndpoint)
                  .startRegistration(
                    session,
                    email: params['email'],
                  ),
        ),
        'verifyRegistrationCode': _i1.MethodConnector(
          name: 'verifyRegistrationCode',
          params: {
            'accountRequestId': _i1.ParameterDescription(
              name: 'accountRequestId',
              type: _i1.getType<_i1.UuidValue>(),
              nullable: false,
            ),
            'verificationCode': _i1.ParameterDescription(
              name: 'verificationCode',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIDP'] as _i2.EmailIDPEndpoint)
                  .verifyRegistrationCode(
                    session,
                    accountRequestId: params['accountRequestId'],
                    verificationCode: params['verificationCode'],
                  ),
        ),
        'finishRegistration': _i1.MethodConnector(
          name: 'finishRegistration',
          params: {
            'registrationToken': _i1.ParameterDescription(
              name: 'registrationToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'password': _i1.ParameterDescription(
              name: 'password',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIDP'] as _i2.EmailIDPEndpoint)
                  .finishRegistration(
                    session,
                    registrationToken: params['registrationToken'],
                    password: params['password'],
                  ),
        ),
        'startPasswordReset': _i1.MethodConnector(
          name: 'startPasswordReset',
          params: {
            'email': _i1.ParameterDescription(
              name: 'email',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIDP'] as _i2.EmailIDPEndpoint)
                  .startPasswordReset(
                    session,
                    email: params['email'],
                  ),
        ),
        'verifyPasswordResetCode': _i1.MethodConnector(
          name: 'verifyPasswordResetCode',
          params: {
            'passwordResetRequestId': _i1.ParameterDescription(
              name: 'passwordResetRequestId',
              type: _i1.getType<_i1.UuidValue>(),
              nullable: false,
            ),
            'verificationCode': _i1.ParameterDescription(
              name: 'verificationCode',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIDP'] as _i2.EmailIDPEndpoint)
                  .verifyPasswordResetCode(
                    session,
                    passwordResetRequestId: params['passwordResetRequestId'],
                    verificationCode: params['verificationCode'],
                  ),
        ),
        'finishPasswordReset': _i1.MethodConnector(
          name: 'finishPasswordReset',
          params: {
            'finishPasswordResetToken': _i1.ParameterDescription(
              name: 'finishPasswordResetToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'newPassword': _i1.ParameterDescription(
              name: 'newPassword',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIDP'] as _i2.EmailIDPEndpoint)
                  .finishPasswordReset(
                    session,
                    finishPasswordResetToken:
                        params['finishPasswordResetToken'],
                    newPassword: params['newPassword'],
                  ),
        ),
        'hasAccount': _i1.MethodConnector(
          name: 'hasAccount',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIDP'] as _i2.EmailIDPEndpoint)
                  .hasAccount(session),
        ),
      },
    );
    connectors['admin'] = _i1.EndpointConnector(
      name: 'admin',
      endpoint: endpoints['admin']!,
      methodConnectors: {
        'listUsers': _i1.MethodConnector(
          name: 'listUsers',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['admin'] as _i3.AdminEndpoint)
                  .listUsers(session)
                  .then((container) => _i6.mapContainerToJson(container)),
        ),
        'listAuthUsers': _i1.MethodConnector(
          name: 'listAuthUsers',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['admin'] as _i3.AdminEndpoint)
                  .listAuthUsers(session),
        ),
        'blockUser': _i1.MethodConnector(
          name: 'blockUser',
          params: {
            'userId': _i1.ParameterDescription(
              name: 'userId',
              type: _i1.getType<_i1.UuidValue>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['admin'] as _i3.AdminEndpoint).blockUser(
                session,
                params['userId'],
              ),
        ),
        'unblockUser': _i1.MethodConnector(
          name: 'unblockUser',
          params: {
            'userId': _i1.ParameterDescription(
              name: 'userId',
              type: _i1.getType<_i1.UuidValue>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['admin'] as _i3.AdminEndpoint).unblockUser(
                session,
                params['userId'],
              ),
        ),
      },
    );
    connectors['recipesAdmin'] = _i1.EndpointConnector(
      name: 'recipesAdmin',
      endpoint: endpoints['recipesAdmin']!,
      methodConnectors: {
        'triggerDeletedRecipeCleanup': _i1.MethodConnector(
          name: 'triggerDeletedRecipeCleanup',
          params: {
            'params': _i1.ParameterDescription(
              name: 'params',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['recipesAdmin'] as _i4.RecipesAdminEndpoint)
                  .triggerDeletedRecipeCleanup(
                    session,
                    params['params'],
                  ),
        ),
        'scheduleDeletedRecipeCleanup': _i1.MethodConnector(
          name: 'scheduleDeletedRecipeCleanup',
          params: {
            'params': _i1.ParameterDescription(
              name: 'params',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['recipesAdmin'] as _i4.RecipesAdminEndpoint)
                  .scheduleDeletedRecipeCleanup(
                    session,
                    params['params'],
                  ),
        ),
        'stopCleanupTask': _i1.MethodConnector(
          name: 'stopCleanupTask',
          params: {
            'params': _i1.ParameterDescription(
              name: 'params',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['recipesAdmin'] as _i4.RecipesAdminEndpoint)
                  .stopCleanupTask(
                    session,
                    params['params'],
                  ),
        ),
      },
    );
    connectors['recipes'] = _i1.EndpointConnector(
      name: 'recipes',
      endpoint: endpoints['recipes']!,
      methodConnectors: {
        'generateRecipe': _i1.MethodConnector(
          name: 'generateRecipe',
          params: {
            'ingredients': _i1.ParameterDescription(
              name: 'ingredients',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'imagePath': _i1.ParameterDescription(
              name: 'imagePath',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['recipes'] as _i5.RecipesEndpoint).generateRecipe(
                    session,
                    params['ingredients'],
                    params['imagePath'],
                  ),
        ),
        'getRecipes': _i1.MethodConnector(
          name: 'getRecipes',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['recipes'] as _i5.RecipesEndpoint)
                  .getRecipes(session),
        ),
        'deleteRecipe': _i1.MethodConnector(
          name: 'deleteRecipe',
          params: {
            'recipeId': _i1.ParameterDescription(
              name: 'recipeId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['recipes'] as _i5.RecipesEndpoint).deleteRecipe(
                    session,
                    params['recipeId'],
                  ),
        ),
        'getUploadDescription': _i1.MethodConnector(
          name: 'getUploadDescription',
          params: {
            'filename': _i1.ParameterDescription(
              name: 'filename',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['recipes'] as _i5.RecipesEndpoint)
                  .getUploadDescription(
                    session,
                    params['filename'],
                  )
                  .then((record) => _i6.mapRecordToJson(record)),
        ),
        'verifyUpload': _i1.MethodConnector(
          name: 'verifyUpload',
          params: {
            'path': _i1.ParameterDescription(
              name: 'path',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['recipes'] as _i5.RecipesEndpoint).verifyUpload(
                    session,
                    params['path'],
                  ),
        ),
        'getPublicUrlForPath': _i1.MethodConnector(
          name: 'getPublicUrlForPath',
          params: {
            'path': _i1.ParameterDescription(
              name: 'path',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['recipes'] as _i5.RecipesEndpoint)
                  .getPublicUrlForPath(
                    session,
                    params['path'],
                  ),
        ),
      },
    );
    modules['serverpod_auth'] = _i7.Endpoints()
      ..initializeEndpoints(server);
    modules['serverpod_auth_idp'] = _i8.Endpoints()
      ..initializeEndpoints(server);
    modules['serverpod_auth_core'] = _i9.Endpoints()
      ..initializeEndpoints(server);
  }

  @override
  _i1.FutureCallDispatch? get futureCalls {
    return _i10.FutureCalls();
  }
}
