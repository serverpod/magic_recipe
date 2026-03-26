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

abstract class RecipesFutureCallRemoveDeletedRecipesModel
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  RecipesFutureCallRemoveDeletedRecipesModel._({required this.params});

  factory RecipesFutureCallRemoveDeletedRecipesModel({
    required String? params,
  }) = _RecipesFutureCallRemoveDeletedRecipesModelImpl;

  factory RecipesFutureCallRemoveDeletedRecipesModel.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return RecipesFutureCallRemoveDeletedRecipesModel(
      params: jsonSerialization['params'] as String?,
    );
  }

  String? params;

  /// Returns a shallow copy of this [RecipesFutureCallRemoveDeletedRecipesModel]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  RecipesFutureCallRemoveDeletedRecipesModel copyWith({String? params});
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'RecipesFutureCallRemoveDeletedRecipesModel',
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

class _RecipesFutureCallRemoveDeletedRecipesModelImpl
    extends RecipesFutureCallRemoveDeletedRecipesModel {
  _RecipesFutureCallRemoveDeletedRecipesModelImpl({required String? params})
    : super._(params: params);

  /// Returns a shallow copy of this [RecipesFutureCallRemoveDeletedRecipesModel]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  RecipesFutureCallRemoveDeletedRecipesModel copyWith({
    Object? params = _Undefined,
  }) {
    return RecipesFutureCallRemoveDeletedRecipesModel(
      params: params is String? ? params : this.params,
    );
  }
}
