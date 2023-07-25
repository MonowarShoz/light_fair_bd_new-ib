import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';

part 'category_model.g.dart';

@JsonSerializable()
class CategoryModel {
  final String? msircode;
  final String? msirdesc;
  final String? msirtype;

  CategoryModel(
    this.msircode,
    this.msirdesc,
    this.msirtype,
  );

   factory CategoryModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryModelToJson(this);
}
