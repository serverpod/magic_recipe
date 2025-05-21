/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import '../admin_endpoint.dart' as _i2;
import '../greeting_endpoint.dart' as _i3;
import '../recipes/recipes_endpoint.dart' as _i4;
import 'package:serverpod_auth_server/serverpod_auth_server.dart' as _i5;

class Endpoints extends _i1.EndpointDispatch {
  @override
  void initializeEndpoints(_i1.Server server) {
    var endpoints = <String, _i1.Endpoint>{
      'admin': _i2.AdminEndpoint()
        ..initialize(
          server,
          'admin',
          null,
        ),
      'greeting': _i3.GreetingEndpoint()
        ..initialize(
          server,
          'greeting',
          null,
        ),
      'recipes': _i4.RecipesEndpoint()
        ..initialize(
          server,
          'recipes',
          null,
        ),
    };
    connectors['admin'] = _i1.EndpointConnector(
      name: 'admin',
      endpoint: endpoints['admin']!,
      methodConnectors: {
        'listUsers': _i1.MethodConnector(
          name: 'listUsers',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['admin'] as _i2.AdminEndpoint).listUsers(session),
        ),
        'blockUser': _i1.MethodConnector(
          name: 'blockUser',
          params: {
            'userId': _i1.ParameterDescription(
              name: 'userId',
              type: _i1.getType<int>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['admin'] as _i2.AdminEndpoint).blockUser(
            session,
            params['userId'],
          ),
        ),
        'unblockUser': _i1.MethodConnector(
          name: 'unblockUser',
          params: {
            'userId': _i1.ParameterDescription(
              name: 'userId',
              type: _i1.getType<int>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['admin'] as _i2.AdminEndpoint).unblockUser(
            session,
            params['userId'],
          ),
        ),
      },
    );
    connectors['greeting'] = _i1.EndpointConnector(
      name: 'greeting',
      endpoint: endpoints['greeting']!,
      methodConnectors: {
        'hello': _i1.MethodConnector(
          name: 'hello',
          params: {
            'name': _i1.ParameterDescription(
              name: 'name',
              type: _i1.getType<String>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['greeting'] as _i3.GreetingEndpoint).hello(
            session,
            params['name'],
          ),
        )
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
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['recipes'] as _i4.RecipesEndpoint).generateRecipe(
            session,
            params['ingredients'],
          ),
        ),
        'getRecipes': _i1.MethodConnector(
          name: 'getRecipes',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['recipes'] as _i4.RecipesEndpoint).getRecipes(session),
        ),
        'deleteRecipe': _i1.MethodConnector(
          name: 'deleteRecipe',
          params: {
            'recipeId': _i1.ParameterDescription(
              name: 'recipeId',
              type: _i1.getType<int>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['recipes'] as _i4.RecipesEndpoint).deleteRecipe(
            session,
            params['recipeId'],
          ),
        ),
      },
    );
    modules['serverpod_auth'] = _i5.Endpoints()..initializeEndpoints(server);
  }
}
