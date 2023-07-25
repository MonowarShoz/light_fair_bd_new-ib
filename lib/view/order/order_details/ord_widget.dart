// ignore_for_file: deprecated_member_use

import 'package:dartx/dartx.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:light_fair_bd_new/data/datasource/model/edit_product_model.dart';
import 'package:light_fair_bd_new/data/datasource/model/order_process_model.dart';
import 'package:light_fair_bd_new/provider/auth_provider.dart';
import 'package:light_fair_bd_new/provider/mobil_feed_provider.dart';
import 'package:light_fair_bd_new/provider/theme_provider.dart';
import 'package:light_fair_bd_new/util/color_resources.dart';
import 'package:light_fair_bd_new/util/images.dart';
import 'package:light_fair_bd_new/util/theme/custom_themes.dart';
import 'package:light_fair_bd_new/view/base_widget/animated_custom_dialog.dart';
import 'package:light_fair_bd_new/view/base_widget/order_cart_clear_dialog.dart';
import 'package:light_fair_bd_new/view/order/order_history/all_order_screen.dart';
import 'package:provider/provider.dart';
import '../../../util/dimensions.dart';
import '../../../util/show_custom_snakbar.dart';

class OrderWidget extends StatefulWidget {
  final OrdersAttr orderAttr;
  final String? selectedSection;

  final String? storename;

  const OrderWidget({
    Key? key,
    required this.orderAttr,
    this.selectedSection,
    this.storename,
  }) : super(key: key);

  @override
  _OrderWidgetState createState() => _OrderWidgetState();
}

class _OrderWidgetState extends State<OrderWidget> {
  bool isLoad = false;
  int currentIndex = 0;
  TextEditingController qtyController = TextEditingController();
  TextEditingController unitController = TextEditingController();
  TextEditingController commentController = TextEditingController();
  TextEditingController edcomment = TextEditingController();

  final form = GlobalKey<FormState>();
  String? drpV;
  String? invoiceNumbers;

  _openLoadingDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: CircularProgressIndicator(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<MobilFeedProvider, UserConfigurationProvider>(
        builder: (context, mp, ap, child) {
      return SafeArea(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              // mainAxisSize: MainAxisSize.max,
              children: [
                Material(
                  elevation: 5,
                  child: Container(
                    width: Dimensions.fullWidth(context),
                    height: 90,
                    color: Colors.white,
                    child: Column(
                      children: [
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 9.0),
                            child: Image.asset(
                              Images.light_fair_logo,
                              height: 20,
                              width: 190,
                            ),
                          ),
                        ),
                        const Divider(),
                        Expanded(
                          child: Material(
                            color: Provider.of<ThemeProvider>(context).darkTheme
                                ? Colors.black
                                : Colors.white,
                            child: Row(
                              //mainAxisAlignment: MainAxisAlignment.spaceBetween,

                              children: [
                                CupertinoNavigationBarBackButton(
                                  onPressed: () {
                                    mp.clearWholeCart();
                                    mp.clearMemo();
                                    Navigator.pop(context);
                                  },
                                  color: Provider.of<ThemeProvider>(context)
                                          .darkTheme
                                      ? Colors.white
                                      : Colors.black,
                                ),
                                Text(
                                  'Invoice Details',
                                  style: poppinRegular.copyWith(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Provider.of<ThemeProvider>(context)
                                              .darkTheme
                                          ? Colors.white
                                          : Colors.black),
                                ),
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      // Flexible(
                                      //   child: Center(
                                      //     child: Image.asset(
                                      //       Images.light_fair_logo,
                                      //       height: 50,
                                      //       width: 190,
                                      //     ),
                                      //   ),
                                      // ),
                                      Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: IconButton(
                                          tooltip: 'Generate Invoice',

                                          onPressed: () async {
                                            setState(() {
                                              isLoad = true;
                                            });
                                            await Future.delayed(const Duration(
                                                milliseconds: 200));
                                            isLoad = true;
                                            mp
                                                .postOrder(
                                              cartProd: widget
                                                  .orderAttr.mobilCartProducts,
                                              custName:
                                                  widget.orderAttr.custName,
                                              custID: widget.orderAttr.custId,
                                              date: widget.orderAttr.dateTime,

                                              comment: widget.orderAttr.comment,
                                              userName:
                                                  ap.jwtTokenModel?.hcname ??
                                                      '',
                                              hcCode: ap.jwtTokenModel!.hccode!,
                                              sessionID:
                                                  ap.jwtTokenModel!.sessionid!,
                                              deviceID: ap.deviceName,
                                              section: widget.selectedSection,

                                              // invNum: widget.orderAttr.invNum,
                                              // total: Provider.of<MobilFeedProvider>(context, listen: false)
                                              //     .totalOrder
                                              //     .toString(),
                                            )
                                                .then((value) async {
                                              if (value.isSuccess) {
                                                showModalBottomSheet(
                                                    context: context,
                                                    builder: (context) {
                                                      return SizedBox(
                                                        height: Dimensions
                                                                .fullHeight(
                                                                    context) /
                                                            2,
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              'Thank you for your order',
                                                              style: robotoBold,
                                                            ),
                                                            SizedBox(
                                                              height: 10,
                                                            ),
                                                            Text(
                                                                'Please, Wait for Approval'),
                                                            SizedBox(
                                                              height: 20,
                                                            ),
                                                            CupertinoButton(
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        89,
                                                                        200,
                                                                        171),
                                                                child: Text(
                                                                    "Check your Order"),
                                                                onPressed: () {
                                                                  Navigator
                                                                      .push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                      builder:
                                                                          (context) =>
                                                                              const AllOrderScreen(),
                                                                    ),
                                                                  );
                                                                }),
                                                          ],
                                                        ),
                                                      );
                                                    });

                                                // String dir =
                                                //     (await getExternalStorageDirectory())!
                                                //         .path;

                                                // var bytes =
                                                //     await orderDetailsPdf(
                                                //         PdfPageFormat.legal,
                                                //         mp,
                                                //         widget
                                                //             .orderAttr.custId!,
                                                //         widget.orderAttr
                                                //             .custName!,
                                                //         widget.storename!,
                                                //         widget.orderAttr
                                                //             .dateTime!,
                                                //         widget
                                                //             .orderAttr.comment!,
                                                //         mp.invMemoNum!,
                                                //         ap);
                                                // invoiceNumbers = mp.invMemoNum;
                                                // print(
                                                //     "invoice numberr $invoiceNumbers");
                                                // final file =
                                                //     File('$dir/Invoice.pdf');
                                                // await file.writeAsBytes(bytes);
                                                // Navigator.of(context).push(
                                                //     MaterialPageRoute(
                                                //         builder: (_) =>
                                                //             PdfPreviewScreen(
                                                //               path:
                                                //                   '$dir/Invoice.pdf',
                                                //               title:
                                                //                   'Invoice Pdf',
                                                //               isResponsive:
                                                //                   true,
                                                //               file: file,
                                                //             )));
                                                // mp.orderHistoryDetails(
                                                //   widget.orderAttr
                                                //       .mobilCartProducts,
                                                //   widget.orderAttr.custName,
                                                //   widget.orderAttr.dateTime,
                                                //   widget.orderAttr.custId,
                                                //   comment:
                                                //       widget.orderAttr.comment,
                                                //   invNum: invoiceNumbers,
                                                //   total:
                                                //       mp.totalOrder.toString(),
                                                // );
                                              } else {
                                                showCustomSnackBar(
                                                  value.message,
                                                  context,
                                                  isError: true,
                                                );
                                              }
                                              setState(() {
                                                isLoad = false;
                                              });
                                            });
                                          },
                                          hoverColor: Colors.grey,
                                          splashColor: Colors.grey,
                                          icon: Icon(
                                            FontAwesomeIcons.floppyDisk,
                                            size: 27,
                                            color: Provider.of<ThemeProvider>(
                                                        context)
                                                    .darkTheme
                                                ? Colors.white
                                                : Colors.black,

                                            //color: Colors.black,
                                          ),
                                          // icon:isLoad ? CircularProgressIndicator(
                                          //
                                          //
                                          // ) : Icon(
                                          //   FontAwesomeIcons.floppyDisk,
                                          //   size: 27,
                                          //
                                          //   //color: Colors.black,
                                          // ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Card(
                      margin: const EdgeInsets.all(10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              style: BorderStyle.solid, color: Colors.grey),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: Text(
                                  'LIGHT FAIR BD LTD',
                                  style: poppinRegular.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'INVOICE',
                                  style: poppinRegular.copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                            const Divider(),
                            invoiceTileWidget(
                                'Date', widget.orderAttr.dateTime),
                            //      invoiceTileWidget('Office', widget.selectedSection),
                            // Consumer<MobilFeedProvider>(builder: (context, mprv, child) {
                            //   return mprv.invMemoNum == ''
                            //       ? SizedBox.shrink()
                            //       : invoiceTileWidget('Invoice No', mprv.invMemoNum);
                            // }),
                            invoiceTileWidget(
                                'Customer ID', widget.orderAttr.custId),
                            invoiceTileWidget(
                                'Customer Name', widget.orderAttr.custName),
                            invoiceTileWidget('store ', widget.storename),

                            invoiceTileWidget('Total Amount',
                                '${Provider.of<MobilFeedProvider>(context).totalAmountOrder.toString()} \u{09F3}'),
                            const SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              height: 46,
                              child: Card(
                                color: ColorResources.getHomeBg(context),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(
                                        child: Text(
                                          'Ordered Products',
                                          style: poppinRegular.copyWith(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 15,
                                              color: ColorResources.getTextBg(
                                                  context)),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const Divider(),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SingleChildScrollView(
                                  child: _createDataTable()),
                            ),
                            const Divider(),
                            widget.orderAttr.comment!.isEmpty
                                ? const SizedBox.shrink()
                                : Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Row(
                                      children: [
                                        const Text(
                                          'Remarks : ',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 15,
                                          ),
                                        ),
                                        Text(
                                          '${widget.orderAttr.comment}',
                                          style: chakraPetch.copyWith(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                    ),
                    isLoad
                        ? AlertDialog(
                            elevation: 50,

                            alignment: Alignment.center,

                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0))),
                            title: Text(
                              'Preparing Invoice',
                              textAlign: TextAlign.center,
                              style: robotoRegular.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            content: Center(child: CircularProgressIndicator()),
                            // content: Row(
                            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //   children: [
                            //     Text(
                            //       'Processing Invoice',
                            //       style: robotoRegular.copyWith(fontWeight: FontWeight.bold, fontSize: 20),
                            //     ),
                            //     CircularProgressIndicator(),
                            //   ],
                            // ),
                          )
                        : SizedBox.shrink(),
                    Positioned(
                        top: 10,
                        right: 10,
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: InkWell(
                            onTap: () => showAnimatedDialog(
                                context,
                                OrderClearDialog(
                                  isOrder: true,
                                )),

                            //Provider.of<MobilFeedProvider>(context, listen: false).clearORder();
                            // Provider.of<MobilFeedProvider>(context, listen: false).clearWholeCart();

                            child: CircleAvatar(
                              radius: 9,
                              backgroundColor: Colors.black,
                              child: Icon(
                                Icons.clear,
                                color: Colors.white,
                                size: 12,
                              ),
                            ),
                          ),
                        )),
                  ],
                ),
                // Consumer<MobilFeedProvider>(builder: (context, mp, child) {
                //   return SizedBox(
                //     height: 36,
                //     width: Dimensions.fullWidth(context),
                //     child: FloatingActionButton.extended(
                //       shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.circular(5),
                //       ),
                //       onPressed: () {
                //         mp
                //             .postOrder(
                //               widget.orderAttr.mobilCartProducts,
                //               widget.orderAttr.custName,
                //               widget.orderAttr.dateTime,
                //               widget.orderAttr.custId,
                //               comment: widget.orderAttr.comment,
                //               invNum: widget.orderAttr.invNum,
                //               total: mp.totalAmount.toString(),
                //             )
                //             .then((value) => value.isSuccess
                //                 ? showCustomSnackBar(
                //                     value.message,
                //                     context,
                //                     isError: false,
                //                   )
                //                 : showCustomSnackBar(
                //                     value.message,
                //                     context,
                //                     isError: true,
                //                   ));
                //
                //         mp.orderHistoryDetails(
                //           widget.orderAttr.mobilCartProducts,
                //           widget.orderAttr.custName,
                //           widget.orderAttr.dateTime,
                //           widget.orderAttr.custId,
                //           comment: widget.orderAttr.comment,
                //           invNum: widget.orderAttr.invNum,
                //           total: mp.totalAmount.toString(),
                //         );
                //       },
                //       backgroundColor: Colors.black,
                //       icon: const Icon(Icons.save),
                //       label: const Text(
                //         "Save",
                //       ),
                //     ),
                //   );
                //}),
              ],
            )
          ],
        ),
      );
    });
  }

  Row invoiceTileWidget(String? title, String? value) {
    return Row(
      //mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Expanded(
          flex: 7,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title!,
              style: poppinRegular.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),

        Expanded(
            flex: 2,
            child: Text(
              ' :',
              style: TextStyle(fontWeight: FontWeight.bold),
            )),
        // Padding(
        //   padding: EdgeInsets.only(left: 80),
        //   child: Text(
        //     ':',
        //     style: TextStyle(fontWeight: FontWeight.bold),
        //   ),
        // ),
        Expanded(
          flex: 8,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              value!,
              style: poppinRegular.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: 13,
              ),
            ),
          ),
        ),
      ],
    );
  }

  DataTable _createDataTable() {
    return DataTable(
      horizontalMargin: 7,

      dataRowHeight: Dimensions.fullHeight(context) / 8,
      border: TableBorder.all(
        style: BorderStyle.solid,
        color: Colors.black26,
      ),
      // border: TableBorder.symmetric(
      //   outside: BorderSide.none,
      // ),
      // decoration: BoxDecoration(
      //   border: Border.all(),
      // ),
      columnSpacing: (MediaQuery.of(context).size.width / 16) * 0.5,

      showBottomBorder: true,
      columns: _createColumns(),
      rows: _createRows(),
    );
  }

  List<DataColumn> _createColumns() {
    return [
      DataColumn(
          label: Text(
        'SI',
        style: poppinRegular.copyWith(
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      )),
      DataColumn(
        label: Text(
          'Product Name',
          //textAlign: TextAlign.center,
          style:
              poppinRegular.copyWith(fontWeight: FontWeight.w600, fontSize: 12),
        ),
      ),
      DataColumn(
          label: Text(
        'Quantity',
        style:
            poppinRegular.copyWith(fontWeight: FontWeight.w600, fontSize: 12),
      )),
      DataColumn(
        label: Text(
          'Unit',
          style:
              poppinRegular.copyWith(fontWeight: FontWeight.w600, fontSize: 12),
        ),
      ),
      // DataColumn(
      //   label: Text(
      //     'Edit',
      //     style: GoogleFonts.chakraPetch(
      //       fontWeight: FontWeight.w600,
      //     ),
      //   ),
      // ),
      DataColumn(
        label: Text(
          'Amount',
          style:
              poppinRegular.copyWith(fontWeight: FontWeight.w600, fontSize: 12),
        ),
      ),
      // DataColumn(
      //   label: Text(
      //     'Price',
      //     style: GoogleFonts.chakraPetch(
      //       fontWeight: FontWeight.w600,
      //     ),
      //   ),
      // ),
    ];
  }

  List<DataRow> _createRows() {
    return widget.orderAttr.mobilCartProducts!.map((prod) {
      //_edcomment.add(TextEditingController());
      return DataRow(cells: [
        DataCell(
            Text('${widget.orderAttr.mobilCartProducts!.indexOf(prod) + 1}')),
        DataCell(
          Container(
            width: (MediaQuery.of(context).size.width / 10) * 3,
            child: Text(
              '${prod.sirdesc}',
              // '${prod.title}',
              style: poppinRegular.copyWith(
                  fontSize: 12, fontWeight: FontWeight.w500),
              // style: GoogleFonts.robotoSlab(

              // ),
            ),
          ),
        ),
        DataCell(
          Container(
            width: (MediaQuery.of(context).size.width / 10),
            child: Text(
              '${prod.invqty}',
              // '${prod.quantity}',
              textAlign: TextAlign.center,
              style: poppinRegular.copyWith(
                  fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ),
          showEditIcon: true,
          onTap: () {
            currentIndex = widget.orderAttr.mobilCartProducts!.indexOf(prod);
            _updateTextControllers(prod);
            showEditDialog(prod);
          },
        ),
        DataCell(
          Container(
            width: (MediaQuery.of(context).size.width / 10),
            child: Text(
              // '${prod.unit}',
              '${prod.sirunit}',
              style: poppinRegular.copyWith(
                  fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ),
        ),
        DataCell(
          Container(
            width: (MediaQuery.of(context).size.width / 8),
            child: FittedBox(
              child: Text(
                '${prod.sirunit == 'CTN' ? (prod.itmrat! * prod.invqty! * prod.siruconf!.toDouble()) : (prod.itmrat! * prod.invqty!)}',
                // '${prod.unit == 'CTN' ? (prod.price! * prod.quantity! * prod.unitconv3!.toDouble()) : (prod.price! * prod.quantity!)}',
                style: poppinRegular.copyWith(
                    fontSize: 12, fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ),
      ]);
    }).toList();
  }

  Future<dynamic> showEditDialog(
    ProductEditModel prod,
  ) {
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              content: Text(
                'EDIT Quantity & Unit',
                textAlign: TextAlign.center,
                style: robotoSlab.copyWith(
                    fontWeight: FontWeight.w500, fontSize: 20),
              ),
              actions: [
                Column(
                  children: [
                    Form(
                        key: form,
                        child: Column(
                          children: [
                            Container(
                              width: 395,
                              height: 40,
                              margin: EdgeInsets.only(top: 5, bottom: 5),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: ColorResources.getHomeBg(context),
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(
                                  color: Colors.white,
                                ),
                              ),
                              child: Center(
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton(
                                      value: drpV,
                                      isExpanded: true,
                                      style: TextStyle(
                                        fontSize: 18,
                                        color:
                                            ColorResources.getTextBg(context),
                                      ),
                                      alignment: Alignment.centerLeft,
                                      iconSize: 30,
                                      items: ['CTN', 'PCS']
                                          .map<DropdownMenuItem<String>>(
                                              (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              value,
                                              style: chakraPetch.copyWith(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14,
                                                // color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: (String? val) {
                                        setState(() {
                                          drpV = val;
                                        });
                                      }),
                                ),
                              ),
                            ),
                            // Row(
                            //   children: [
                            //     Expanded(
                            //       flex: 6,
                            //       child: SizedBox(
                            //         width: 120,
                            //         // height: 40,
                            //         child: TextFormField(
                            //           controller: unitController,
                            //           textCapitalization: TextCapitalization.characters,
                            //           validator: (value) {
                            //             if (value!.isEmpty) {
                            //               return 'This Field is required';
                            //             } else if (value != 'PCS' && value != 'CTN') {
                            //               return 'Invalid Value';
                            //             }
                            //
                            //             return null;
                            //           },
                            //           decoration: InputDecoration(
                            //             labelText: 'Unit',
                            //             hintText: 'Pick only PCS or CTN',
                            //             hintStyle: TextStyle(fontSize: 16),
                            //             contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                            //             border: OutlineInputBorder(),
                            //           ),
                            //         ),
                            //       ),
                            //     ),
                            //   ],
                            // ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                // Expanded(
                                //
                                //   child: Text('Quantity'),
                                //
                                // ),
                                Expanded(
                                  //flex: 6,
                                  child: SizedBox(
                                    width: 120,
                                    //height: 40,
                                    child: TextFormField(
                                      controller: qtyController,
                                      // inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'This Field is required';
                                        }
                                        return null;
                                      },
                                      keyboardType: TextInputType.number,
                                      //keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                      decoration: InputDecoration(
                                        labelText: 'Quantity',
                                        //hintText: 'Quantity',
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 10, horizontal: 10),
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            // TextFormField(
                            //   controller: edcomment,
                            //   decoration: InputDecoration(
                            //     labelText: 'Comment',
                            //     border: OutlineInputBorder(),
                            //   ),
                            // ),
                            const Divider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  child: ElevatedButton(
                                    style: TextButton.styleFrom(
                                      elevation: 0,
                                      backgroundColor:
                                          ColorResources.getHomeBg(context),
                                      primary:
                                          ColorResources.getTextBg(context),
                                    ),
                                    onPressed: () {
                                      if (validate() == true) {
                                        form.currentState!.save();
                                        updateForm();
                                        clearForm();
                                        Navigator.pop(context);
                                      }
                                    },
                                    child: const Text("Update"),
                                  ),
                                ),
                                ElevatedButton(
                                  style: TextButton.styleFrom(
                                    elevation: 0,
                                    backgroundColor:
                                        ColorResources.getHomeBg(context),
                                    primary: ColorResources.getTextBg(context),
                                  ),
                                  onPressed: () {
                                    if (validate() == true) {
                                      currentIndex = widget
                                          .orderAttr.mobilCartProducts!
                                          .indexOf(prod);
                                      _deleteTextControllers();
                                      Navigator.pop(context);
                                    }
                                  },
                                  child: const Text("Delete"),
                                ),
                              ],
                            ),
                          ],
                        )),
                  ],
                ),
              ],
            );
          });
        });
  }

  // void _updateTextControllers(ProductCartModel ord) {
  //   setState(() {
  //     qtyController.text = ord.quantity.toString();
  //     drpV = ord.unit!;
  //     //unitController.text = ord.unit!;
  //   });
  // }
  void _updateTextControllers(ProductEditModel ord) {
    setState(() {
      qtyController.text = ord.invqty.toString();
      drpV = ord.sirunit!;
      //edcomment.text = ord.invrmrk!;
      //unitController.text = ord.unit!;
    });
  }

  void updateForm() {
    setState(() {
      widget.orderAttr.mobilCartProducts![currentIndex].invqty =
          qtyController.text.toDouble();
      widget.orderAttr.mobilCartProducts![currentIndex].sirunit = drpV;
      // widget.orderAttr.mobilCartProducts![currentIndex].invrmrk = edcomment.text;
      // widget.orderAttr.mobilCartProducts![currentIndex].unit = unitController.text;
      // widget.orderAttr.comment = commentController.text;
      //Code to update the list after editing
      //ProductCartModel prods = ProductCartModel(quantity: qtyController.text.toDouble(), unit: unitController.text);
      // mobilCartProducts![currentIndex] = prods;
    });
  }

  // void updateForm() {
  //   setState(() {
  //     widget.orderAttr.mobilCartProducts![currentIndex].quantity =
  //         qtyController.text.toDouble();
  //     widget.orderAttr.mobilCartProducts![currentIndex].unit = drpV;
  //     // widget.orderAttr.mobilCartProducts![currentIndex].unit = unitController.text;
  //     widget.orderAttr.comment = commentController.text;
  //     //Code to update the list after editing
  //     //ProductCartModel prods = ProductCartModel(quantity: qtyController.text.toDouble(), unit: unitController.text);
  //     // mobilCartProducts![currentIndex] = prods;
  //   });
  // }

  clearForm() {
    qtyController.clear();
    unitController.clear();
  }

  bool validate() {
    var valid = form.currentState!.validate();
    if (valid) form.currentState!.save();
    return valid;
  }

  void _deleteTextControllers() {
    setState(() {
      //How to delete the list data on clicking Delete button?
      widget.orderAttr.mobilCartProducts!.removeAt(currentIndex);
    });
  }
}
