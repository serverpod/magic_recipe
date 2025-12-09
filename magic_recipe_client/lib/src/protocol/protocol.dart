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
import 'recipes/models/recipe.dart' as _i2;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _i3;
import 'package:magic_recipe_client/src/protocol/recipes/models/recipe.dart'
    as _i4;
import 'package:serverpod_auth_client/serverpod_auth_client.dart' as _i5;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _i6;
export 'recipes/models/recipe.dart';
export 'client.dart';

class Protocol extends _i1.SerializationManager {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._();

  static String? getClassNameFromObjectJson(dynamic data) {
    if (data is! Map) return null;
    final className = data['__className__'] as String?;
    return className;
  }

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;

    final dataClassName = getClassNameFromObjectJson(data);
    if (dataClassName != null && dataClassName != getClassNameForType(t)) {
      try {
        return deserializeByClassName({
          'className': dataClassName,
          'data': data,
        });
      } on FormatException catch (_) {
        // If the className is not recognized (e.g., older client receiving
        // data with a new subtype), fall back to deserializing without the
        // className, using the expected type T.
      }
    }

    if (t == _i2.Recipe) {
      return _i2.Recipe.fromJson(data) as T;
    }
    if (t == _i1.getType<_i2.Recipe?>()) {
      return (data != null ? _i2.Recipe.fromJson(data) : null) as T;
    }
    if (t ==
        List<
          ({_i3.AuthUserModel authUser, _i3.UserProfileModel userProfile})
        >) {
      return (data as List)
              .map(
                (e) =>
                    deserialize<
                      ({
                        _i3.AuthUserModel authUser,
                        _i3.UserProfileModel userProfile,
                      })
                    >(e),
              )
              .toList()
          as T;
    }
    if (t ==
        _i1
            .getType<
              ({_i3.AuthUserModel authUser, _i3.UserProfileModel userProfile})
            >()) {
      return (
            authUser: deserialize<_i3.AuthUserModel>(
              ((data as Map)['n'] as Map)['authUser'],
            ),
            userProfile: deserialize<_i3.UserProfileModel>(
              data['n']['userProfile'],
            ),
          )
          as T;
    }
    if (t ==
        _i1
            .getType<
              ({_i3.AuthUserModel authUser, _i3.UserProfileModel userProfile})
            >()) {
      return (
            authUser: deserialize<_i3.AuthUserModel>(
              ((data as Map)['n'] as Map)['authUser'],
            ),
            userProfile: deserialize<_i3.UserProfileModel>(
              data['n']['userProfile'],
            ),
          )
          as T;
    }
    if (t == List<_i3.AuthUserModel>) {
      return (data as List)
              .map((e) => deserialize<_i3.AuthUserModel>(e))
              .toList()
          as T;
    }
    if (t == List<_i4.Recipe>) {
      return (data as List).map((e) => deserialize<_i4.Recipe>(e)).toList()
          as T;
    }
    if (t == _i1.getType<(String?, String)>()) {
      return (
            ((data as Map)['p'] as List)[0] == null
                ? null
                : deserialize<String>(data['p'][0]),
            deserialize<String>(data['p'][1]),
          )
          as T;
    }
    try {
      return _i5.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _i6.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _i3.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _i2.Recipe => 'Recipe',
      _ => null,
    };
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;

    if (data is Map<String, dynamic> && data['__className__'] is String) {
      return (data['__className__'] as String).replaceFirst(
        'magic_recipe.',
        '',
      );
    }

    switch (data) {
      case _i2.Recipe():
        return 'Recipe';
    }
    className = _i5.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth.$className';
    }
    className = _i6.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth_idp.$className';
    }
    className = _i3.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth_core.$className';
    }
    return null;
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    var dataClassName = data['className'];
    if (dataClassName is! String) {
      return super.deserializeByClassName(data);
    }
    if (dataClassName == 'Recipe') {
      return deserialize<_i2.Recipe>(data['data']);
    }
    if (dataClassName.startsWith('serverpod_auth.')) {
      data['className'] = dataClassName.substring(15);
      return _i5.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_idp.')) {
      data['className'] = dataClassName.substring(19);
      return _i6.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      data['className'] = dataClassName.substring(20);
      return _i3.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }

  @override
  dynamic mapRecordToJson(Record record) {
    if (record
        is ({_i3.AuthUserModel authUser, _i3.UserProfileModel userProfile})) {
      return {
        "n": {
          "authUser": record.authUser,
          "userProfile": record.userProfile,
        },
      };
    }
    if (record is (String?, String)) {
      return {
        "p": [
          record.$1,
          record.$2,
        ],
      };
    }
    try {
      return _i5.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _i6.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _i3.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}
