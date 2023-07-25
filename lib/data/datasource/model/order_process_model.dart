import 'package:flutter/cupertino.dart';
import 'package:light_fair_bd_new/data/datasource/model/cart_model.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:light_fair_bd_new/data/datasource/model/edit_product_model.dart';
import 'package:light_fair_bd_new/data/datasource/model/ret_sale_item.dart';

part 'order_process_model.g.dart';

@JsonSerializable()
class OrdersAttr with ChangeNotifier {
  final String? custId;
  final String? custName;
  final List<ProductEditModel>? mobilCartProducts;
  // final List<ProductCartModel>? mobilCartProducts;
  final String? dateTime;
  String? comment;
  final String? invNum;
  final String? totalAmount;

  //final Timestamp orderDate;

  OrdersAttr({
    this.custId,
    this.custName,
    this.mobilCartProducts,
    this.dateTime,
    this.comment,
    this.invNum,
    this.totalAmount,

    //this.orderDate,
  });
  factory OrdersAttr.fromJson(Map<String, dynamic> json) => _$OrdersAttrFromJson(json);

  Map<String, dynamic> toJson() => _$OrdersAttrToJson(this);
}
