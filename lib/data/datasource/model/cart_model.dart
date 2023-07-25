import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';

part 'cart_model.g.dart';

@JsonSerializable()
class ProductCartModel with ChangeNotifier{
  final String? id;
  final String? title;
   double? quantity;
  final double? price;
  late String? unit;
  final double? unitconv3;
  final double? uninft3;


  ProductCartModel({
     this.id,
     this.title,
     this.quantity,
     this.price,
     this.unit,
    this.uninft3,this.unitconv3

  });
  factory ProductCartModel.fromJson(Map<String, dynamic> json) =>
      _$ProductCartModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductCartModelToJson(this);
}
