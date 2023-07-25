// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CategoryModel _$CategoryModelFromJson(Map<String, dynamic> json) {
  return CategoryModel(
    json['msircode'] as String?,
    json['msirdesc'] as String?,
    json['msirtype'] as String?,
  );
}

Map<String, dynamic> _$CategoryModelToJson(CategoryModel instance) =>
    <String, dynamic>{
      'msircode': instance.msircode,
      'msirdesc': instance.msirdesc,
      'msirtype': instance.msirtype,
    };
