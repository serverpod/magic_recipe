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

abstract class RecipesFutureCallRescheduleRemoveDeletedRecipesModel
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  RecipesFutureCallRescheduleRemoveDeletedRecipesModel._({
    required this.params,
  });

  factory RecipesFutureCallRescheduleRemoveDeletedRecipesModel({
    required String? params,
  }) = _RecipesFutureCallRescheduleRemoveDeletedRecipesModelImpl;

  factory RecipesFutureCallRescheduleRemoveDeletedRecipesModel.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return RecipesFutureCallRescheduleRemoveDeletedRecipesModel(
      params: jsonSerialization['params'] as String?,
    );
  }

  String? params;

  /// Returns a shallow copy of this [RecipesFutureCallRescheduleRemoveDeletedRecipesModel]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  RecipesFutureCallRescheduleRemoveDeletedRecipesModel copyWith({
    String? params,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'RecipesFutureCallRescheduleRemoveDeletedRecipesModel',
      if (params != null) 'params': params,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _RecipesFutureCallRescheduleRemoveDeletedRecipesModelImpl
    extends RecipesFutureCallRescheduleRemoveDeletedRecipesModel {
  _RecipesFutureCallRescheduleRemoveDeletedRecipesModelImpl({
    required String? params,
  }) : super._(params: params);

  /// Returns a shallow copy of this [RecipesFutureCallRescheduleRemoveDeletedRecipesModel]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  RecipesFutureCallRescheduleRemoveDeletedRecipesModel copyWith({
    Object? params = _Undefined,
  }) {
    return RecipesFutureCallRescheduleRemoveDeletedRecipesModel(
      params: params is String? ? params : this.params,
    );
  }
}
