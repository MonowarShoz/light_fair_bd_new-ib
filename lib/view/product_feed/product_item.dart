import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:light_fair_bd_new/util/color_resources.dart';
import 'package:light_fair_bd_new/util/dimensions.dart';
import 'package:provider/provider.dart';

import '../../data/datasource/model/ret_sale_item.dart';
import '../../provider/mobil_feed_provider.dart';
import '../../util/images.dart';
import '../../util/theme/custom_themes.dart';

class ProductItem extends StatefulWidget {
  final int index;

  const ProductItem({
    Key? key,
    required this.index,
  }) : super(key: key);

  @override
  State<ProductItem> createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  var selectedIndexes = [];
  bool isMode = false;

  @override
  Widget build(BuildContext context) {
    //final product = Provider.of<RetItemSale>(context);
    final chProd = Provider.of<CheckRetItem>(context);
    final cart = Provider.of<MobilFeedProvider>(
      context,
    );

    return SizedBox(
      width: Dimensions.fullWidth(context) / 4,
      height: Dimensions.fullHeight(context) / 6.5,
      child: InkWell(
        onTap: () {
          cart.checkRetItem![widget.index].isCheck =
              !cart.checkRetItem![widget.index].isCheck;

          if (cart.checkRetItem![widget.index].isCheck == true) {
            cart.addToCart(
              prodId: chProd.rateIem!.sircode!,
              title: chProd.rateIem!.sirdesc!,
              price: chProd.rateIem!.saleprice,
              unitconv: chProd.rateIem!.siruconf3,
              batchno: chProd.rateIem!.batchno!,
            );
          } else if (cart.checkRetItem![widget.index].isCheck == false) {
            cart.removeItemFromCart(chProd.rateIem!.sircode!);
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Container(
            //elevation: 2,
            decoration: BoxDecoration(
                color: cart.cartItems.containsKey(chProd.rateIem!.sircode!)
                    ? Colors.green[100]
                    : Colors.white,
                // color:  cart.checkRetItem![widget.index].isCheck ? ColorResources.getSellColor(context) : ColorResources.getHomeBg(context),
                //color: ColorResources.getHomeBg(context),
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  //leading: Image.asset(Images.savsol_logo),
                  title: Text(
                    //"${product.sirdesc}",
                    "${chProd.rateIem!.sirdesc}",
                    style: poppinRegular.copyWith(
                      fontWeight: FontWeight.w800,
                      fontSize: 12,
                      color: ColorResources.getGreen(context),
                    ),
                    //"${mobilP.retItemSale![index].sirdesc}",
                    // style: robotoBold.copyWith(
                    //   fontSize: 13,
                    //   color: Colors.black,
                    // ),
                  ),
                  subtitle: Text(
                    "ID : ${chProd.rateIem!.sircode}",
                    // "${product.sircode}",
                    //"${mobilP.retItemSale![index].sircode} ",
                    style: poppinRegular.copyWith(
                      fontWeight: FontWeight.w800,
                      fontSize: 12,
                      color: ColorResources.getTextBg(context),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Text(
                        '${chProd.rateIem!.msirdesc}',
                        style: chakraPetch.copyWith(
                          fontWeight: FontWeight.w800,
                          color: ColorResources.getRed(context),
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
