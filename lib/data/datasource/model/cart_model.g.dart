// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductCartModel _$ProductCartModelFromJson(Map<String, dynamic> json) {
  return ProductCartModel(
    id: json['id'] as String?,
    title: json['title'] as String?,
    quantity: (json['quantity'] as num?)?.toDouble(),
    price: (json['price'] as num?)?.toDouble(),
    unit: json['unit'] as String?,
    uninft3: (json['uninft3'] as num?)?.toDouble(),
    unitconv3: (json['unitconv3'] as num?)?.toDouble(),
  );
}

Map<String, dynamic> _$ProductCartModelToJson(ProductCartModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'quantity': instance.quantity,
      'price': instance.price,
      'unit': instance.unit,
      'unitconv3': instance.unitconv3,
      'uninft3': instance.uninft3,
    };
