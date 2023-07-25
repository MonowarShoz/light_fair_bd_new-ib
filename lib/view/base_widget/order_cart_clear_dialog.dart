
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:light_fair_bd_new/provider/mobil_feed_provider.dart';
import 'package:light_fair_bd_new/util/dimensions.dart';
import 'package:light_fair_bd_new/util/theme/custom_themes.dart';
import 'package:provider/provider.dart';

class OrderClearDialog extends StatelessWidget {
  final bool isOrder;
  final List<TextEditingController>? newqty;
  final List<String>? drpDownSelectedItem;
  final int? index;

  const OrderClearDialog({
    Key? key,
    this.isOrder = false,this.newqty,  this.drpDownSelectedItem, this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<MobilFeedProvider>(context, listen: false).cartItems;
    return AlertDialog(
      content: SizedBox(
        height: 60,
        child: Center(
          child: Text(
            'Do you want to Delete Order Data?',
            textAlign: TextAlign.center,
            style: chakraPetch.copyWith(fontWeight: FontWeight.w500, fontSize: 15),
          ),
        ),
      ),
      title: Center(
          child: Text(
            'Click To Proceed',
            style: chakraPetch.copyWith(fontWeight: FontWeight.w600, fontSize: 19),
          )),
      actions: [
        Column(
          children: [
            Divider(
              color: Colors.black,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Center(
                  child: TextButton.icon(
                    icon: Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    // style: ElevatedButton.styleFrom(
                    //   primary: Colors.purple,
                    // ),
                    onPressed: () {
                      if (isOrder) {
                        Provider.of<MobilFeedProvider>(context, listen: false).clearWholeCart();
                        Provider.of<MobilFeedProvider>(context, listen: false).clearORder();
                      } else {
                        Provider.of<MobilFeedProvider>(context, listen: false).clearWholeCart();
                        for(int i = 0;i<cart.length;i++){
                          newqty![i].clear();
                          drpDownSelectedItem!.clear();


                        }


                      }

                      Navigator.pop(context);
                    },
                    label: Text(
                      'Yes',
                      style: TextStyle(color: Colors.red, fontSize: 18),
                    ),
                  ),
                ),
                Container(
                    padding: EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                    height: 50,
                    child: VerticalDivider(
                      color: Colors.black,
                    )),
                Center(
                  child: TextButton.icon(
                    icon: Icon(
                      Icons.clear,
                      color: Colors.green,
                    ),
                    // style: ElevatedButton.styleFrom(
                    //   primary: Colors.purple,
                    // ),
                    onPressed: () => Navigator.pop(context),
                    label: Text('No', style: TextStyle(color: Colors.green, fontSize: 18)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}