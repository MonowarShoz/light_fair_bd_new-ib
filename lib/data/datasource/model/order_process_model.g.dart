// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_process_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrdersAttr _$OrdersAttrFromJson(Map<String, dynamic> json) {
  return OrdersAttr(
    custId: json['custId'] as String?,
    custName: json['custName'] as String?,
    mobilCartProducts: (json['mobilCartProducts'] as List<dynamic>?)
        ?.map((e) => ProductEditModel.fromJson(e as Map<String, dynamic>))
        .toList(),
    dateTime: json['dateTime'] as String?,
    comment: json['comment'] as String?,
    invNum: json['invNum'] as String?,
    totalAmount: json['totalAmount'] as String?,
  );
}

Map<String, dynamic> _$OrdersAttrToJson(OrdersAttr instance) =>
    <String, dynamic>{
      'custId': instance.custId,
      'custName': instance.custName,
      'mobilCartProducts': instance.mobilCartProducts,
      'dateTime': instance.dateTime,
      'comment': instance.comment,
      'invNum': instance.invNum,
      'totalAmount': instance.totalAmount,
    };
