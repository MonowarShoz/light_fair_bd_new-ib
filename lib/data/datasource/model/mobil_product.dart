// class MobilProduct  {
//    String? id;
//    String? title;
//    double? price;
//    String? imgUrl;
//    String? description;
//    int? quantity;
//    String? prodCategoryName;

//   MobilProduct(
//   {   this.description,
//      this.prodCategoryName,
//      this.id,
//      this.title,
//      this.quantity,
//      this.price,
//      this.imgUrl,}
//   );
// }
import 'package:flutter/cupertino.dart';

class MobilProduct with ChangeNotifier {
  String? id;
  String? title;
  String? imgurl;
  String? price;
  double? quantity;

  MobilProduct({
    this.id,
    this.title,
    this.imgurl,
    this.price,
    this.quantity,
  });
}
