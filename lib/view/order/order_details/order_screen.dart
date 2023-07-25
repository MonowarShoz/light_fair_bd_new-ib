import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:light_fair_bd_new/data/datasource/model/order_process_model.dart';
import 'package:light_fair_bd_new/provider/mobil_feed_provider.dart';
import 'package:light_fair_bd_new/util/images.dart';
import 'package:light_fair_bd_new/view/order/order_details/ord_widget.dart';
import 'package:provider/provider.dart';

import '../../../util/theme/custom_themes.dart';

class OrderScreen extends StatefulWidget {
  final bool isOrderScreen;
  final String? section;
  final String? storeName;

  const OrderScreen({
    Key? key,
    this.isOrderScreen = true,
    this.section,
    this.storeName,
  }) : super(key: key);

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<MobilFeedProvider>(context);
    return Scaffold(
      body: orderData.getOrders!.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 60,
                    width: 60,
                    child: Image.asset(
                      Images.empord,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'No order yet',
                      style: chakraPetch.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    child: Text('Back To Order Page'),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.purple,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: orderData.getOrders!.length,
              //itemCount: ordList!.length,
              itemBuilder: ((context, index) {
                return OrderWidget(
                  orderAttr: orderData.getOrders![index],
                  selectedSection: widget.section,
                  storename: widget.storeName,
                );
              }),
            ),
    );
  }
}

class OrderItem extends StatefulWidget {
  const OrderItem({
    Key? key,
  }) : super(key: key);

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  @override
  Widget build(BuildContext context) {
    final orders = Provider.of<OrdersAttr>(context);
    return Column(
      children: [
        Expanded(child: Text(orders.dateTime!)),
        Expanded(child: Text(orders.custName!)),
        Expanded(child: Text(orders.custId!)),
      ],
    );
  }
}
