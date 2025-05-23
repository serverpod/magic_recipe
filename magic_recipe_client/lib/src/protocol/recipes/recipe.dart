/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

abstract class Recipe implements _i1.SerializableModel {
  Recipe._({
    this.id,
    required this.author,
    required this.text,
    required this.date,
    required this.ingredients,
    this.imagePath,
  });

  factory Recipe({
    int? id,
    required String author,
    required String text,
    required DateTime date,
    required String ingredients,
    String? imagePath,
  }) = _RecipeImpl;

  factory Recipe.fromJson(Map<String, dynamic> jsonSerialization) {
    return Recipe(
      id: jsonSerialization['id'] as int?,
      author: jsonSerialization['author'] as String,
      text: jsonSerialization['text'] as String,
      date: _i1.DateTimeJsonExtension.fromJson(jsonSerialization['date']),
      ingredients: jsonSerialization['ingredients'] as String,
      imagePath: jsonSerialization['imagePath'] as String?,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String author;

  String text;

  /// The creation date of the recipe
  DateTime date;

  String ingredients;

  /// Image path of the user upload
  String? imagePath;

  /// Returns a shallow copy of this [Recipe]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Recipe copyWith({
    int? id,
    String? author,
    String? text,
    DateTime? date,
    String? ingredients,
    String? imagePath,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'author': author,
      'text': text,
      'date': date.toJson(),
      'ingredients': ingredients,
      if (imagePath != null) 'imagePath': imagePath,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _RecipeImpl extends Recipe {
  _RecipeImpl({
    int? id,
    required String author,
    required String text,
    required DateTime date,
    required String ingredients,
    String? imagePath,
  }) : super._(
          id: id,
          author: author,
          text: text,
          date: date,
          ingredients: ingredients,
          imagePath: imagePath,
        );

  /// Returns a shallow copy of this [Recipe]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Recipe copyWith({
    Object? id = _Undefined,
    String? author,
    String? text,
    DateTime? date,
    String? ingredients,
    Object? imagePath = _Undefined,
  }) {
    return Recipe(
      id: id is int? ? id : this.id,
      author: author ?? this.author,
      text: text ?? this.text,
      date: date ?? this.date,
      ingredients: ingredients ?? this.ingredients,
      imagePath: imagePath is String? ? imagePath : this.imagePath,
    );
  }
}
