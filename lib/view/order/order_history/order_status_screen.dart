import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:light_fair_bd_new/util/color_resources.dart';
import 'package:path_provider/path_provider.dart';
import 'package:light_fair_bd_new/data/datasource/model/order_history_info_model.dart';
import 'package:light_fair_bd_new/provider/auth_provider.dart';
import 'package:light_fair_bd_new/provider/mobil_feed_provider.dart';
import 'package:light_fair_bd_new/provider/theme_provider.dart';
import 'package:light_fair_bd_new/util/date_converter.dart';
import 'package:light_fair_bd_new/util/theme/custom_themes.dart';
import 'package:light_fair_bd_new/view/order/order_history/order_history_screen.dart';
import 'package:pdf/pdf.dart';
import 'package:provider/provider.dart';
import '../../base_widget/all_order_widget.dart';
import '../../home/home.dart';
import '../order_details/order_details_pdf.dart';
import '../pdf_preview_screen.dart';

class OrderStatusScreen extends StatefulWidget {
  const OrderStatusScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<OrderStatusScreen> createState() => _OrderStatusScreenState();
}

class _OrderStatusScreenState extends State<OrderStatusScreen> {
  final storeChngController = TextEditingController();
  final _orderSearchController = TextEditingController();
  List<String> streDropDown = [];
  String? selItem;
  String? selectedValueSingleDialog;
  String selectestredDropDownBtn = 'LO-Office';
  @override
  void initState() {
    super.initState();
    getorR();
    getoR();
    //  getordst();
  }

  getorR() async {
    await Provider.of<UserConfigurationProvider>(context, listen: false).getOrderStatus("A");
  }

  getoR() async {
    await Provider.of<UserConfigurationProvider>(context, listen: false).rejectedStatus();
  }

  @override
  Widget build(BuildContext context) {
    //  Provider.of<AuthProvider>(context, listen: false).getCompanyBranchInfo().then((value) {
    //   if (value.isSuccess) {
    //     Timer(Duration(seconds: 1), () {
    //        Provider.of<AuthProvider>(context, listen: false).initializeCustomerList();
    //     });
    //   }
    // });
    // Provider.of<UserConfigurationProvider>(context, listen: false).getOrderStatus("A");

    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorResources.getHomeBg(context),
        title: Text(
          'Approved Order',
          style: TextStyle(color: ColorResources.getTextBg(context),),
        ),
        elevation: 0,
        // : Text(
        //     'Approved Order',
        //     style: TextStyle(color: Colors.black),
        //   ),
        leading: CupertinoNavigationBarBackButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(),
            ),
          ),
          color: Provider.of<ThemeProvider>(context).darkTheme ? Colors.white : Colors.black,
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => const OrderHistoryScreen(
                    isPending: false,
                    isApproved: true,
                  ),
                ));
              },
              icon: Icon(Icons.calendar_month)),
          // Consumer<AuthProvider>(builder: (context, ap, child) {
          //   return IconButton(
          //     onPressed: () async {
          //       String dir = (await getExternalStorageDirectory())!.path;
          //       var bytes = await orderHistoryPdf(
          //         PdfPageFormat.legal,
          //         ap,
          //       );
          //       final file = File('$dir/order_history.pdf');
          //       await file.writeAsBytes(bytes);
          //       Navigator.of(context).push(MaterialPageRoute(
          //           builder: (_) => PdfPreviewScreen(
          //               path: '$dir/order_history.pdf',
          //               title: 'order_history Pdf',
          //               isResponsive: true,
          //               file: file)));
          //     },
          //     icon: Icon(Icons.picture_as_pdf),
          //   );
          // })
        ],
        iconTheme: IconThemeData(
          color: Provider.of<ThemeProvider>(context).darkTheme ? Colors.white : Colors.brown,
        ),
      ),
      body: Consumer2<UserConfigurationProvider, MobilFeedProvider>(builder: (context, ap, mp, child) {
        return SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            //mainAxisSize: MainAxisSize.max,
            children: [
              ExpansionTileWidget(
                title: 'Approved List', //${ap.approvedList!.isEmpty ? '' : ap.approvedList!.length} 
                titleColor: Color.fromARGB(255, 63, 134, 66),
                borderColor: Colors.green,
                expansionBorder: Colors.green,
                iconColor: Colors.green,
                searchBorder: Colors.green,
                collapsedIconColor: Colors.green,
                ap: ap,
                isApproveSearch: true,
                hintText: 'Search Approved Order',
                ordStatusList: ap.approvedList,
                fn: (value) {
                  value ? ap.getOrderStatus("A", context: context) : null;
                },
                context: context,
                mp: mp,
              ),
              ExpansionTileWidget(
                title: 'Rejected List ', // ${ap.rejectedList!.isEmpty ? '' : ap.rejectedList!.length} 
                titleColor: Color.fromARGB(255, 172, 47, 38),
                borderColor: Color.fromARGB(255, 233, 126, 119),
                expansionBorder: Color.fromARGB(255, 233, 126, 119),
                searchBorder: Color.fromARGB(255, 233, 126, 119),
                collapsedIconColor: Color.fromARGB(255, 233, 126, 119),
                iconColor: Color.fromARGB(255, 233, 126, 119),
                hintText: 'Search Rejected Order',
                fn: (value) {
                  //   value ? ap.rejectedStatus(context: context) : null;
                  value ? ap.getOrderStatus("C", context: context) : null;
                },
                isApproveSearch: false,
                ap: ap,
                ordStatusList: ap.rejectedList,
                context: context,
                mp: mp,
              ),
            ],
          ),
        );
      }),
    );
  }

  Card ExpansionTileWidget(
      {required String title,
      String? hintText,
      required Color titleColor,
      required Color borderColor,
      Color? collapsedIconColor,
      Color? iconColor,
      Color? expansionBorder,
      Color? searchBorder,
      bool isApproveSearch = false,
      required UserConfigurationProvider ap,
      List<OrderHistoryInfoModel>? ordStatusList,
      Function(bool)? fn,
      required BuildContext context,
      MobilFeedProvider? mp}) {
    return Card(
      elevation: 2,
      color: ColorResources.getHomeBg(context),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: expansionBorder!,
            // color: Colors.green,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: ExpansionTile(
            collapsedIconColor: collapsedIconColor,
            iconColor: iconColor,
            // trailing: Icon(Icons.arrow_back),
            title: Text(
              title,
              //'Approved Order ${ordStatusList!.isNotEmpty ? ordStatusList.length : ''}',
              style: chakraPetch.copyWith(
                fontSize: 17,
                color: titleColor,
              ),
            ),
            expandedCrossAxisAlignment: CrossAxisAlignment.start,
            expandedAlignment: Alignment.topLeft,
            onExpansionChanged: fn,
            // onExpansionChanged: (value) => value ? ap.getOrderStatus("A", context) : null,
            children: [
              ordStatusList!.isEmpty
                  ? Center(child: Text('No Data Available'))
                  : Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: SizedBox(
                        width: double.infinity,
                        // height: 50,
                        child: TextField(
                          controller: _orderSearchController,
                          style:
                              robotoSlab.copyWith(fontWeight: FontWeight.w500, color: Color.fromARGB(220, 0, 0, 0), fontSize: 16),
                          decoration: InputDecoration(
                              hintText: hintText,
                              focusColor: searchBorder,
                              contentPadding: EdgeInsets.symmetric(vertical: 18, horizontal: 22),
                              suffixIcon: ap.isPendingOrder
                                  ? IconButton(
                                      onPressed: () {
                                        _orderSearchController.text = '';
                                        isApproveSearch ? ap.searchApprovedOrder('') : ap.searchRej('');
                                      },
                                      icon: Icon(
                                        Icons.close,
                                        color: Colors.red,
                                      ))
                                  : Icon(
                                      Icons.search,
                                      color: Colors.black,
                                    ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  width: 2.0,
                                  color: searchBorder!,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide(width: 2, color: Color(0xFFFC6A57)))),
                          onChanged: (query) {
                            isApproveSearch ? ap.searchApprovedOrder(query) : ap.searchRej(query);
                          },
                        ),
                      ),
                    ),
              ...ordStatusList
                  .map((e) => Stack(
                        children: [
                          InkWell(
                            onTap: () async {
                              //  ap.postApproval(
                              //               editProd: ap.editProdList,
                              //               sectionCode: widget.sectNo,
                              //               custID: widget.custId,
                              //               invonum: widget.invno,
                              //               remark: remarks ?? widget.remark,
                              //               date: widget.date,
                              //               custName: widget.custName,
                              //               userName: ap.jwtTokenModel?.hcname ?? '',
                              //               hcCode: ap.jwtTokenModel!.hccode!,
                              //               sessionID: ap.jwtTokenModel!.sessionid!,
                              //               deviceID: ap.deviceName,
                              //               parm12: 'A',
                              //               parm13: widget.placeById,
                              //             );
                              // await ap.orderDetailsEditable(invNum: e.invno!);
                              // String dir = (await getExternalStorageDirectory())!.path;

                              // var bytes = await orderDetailsPdf(PdfPageFormat.legal, mp, e.custid!, e.custName!,
                              //     e.sectname!, e.invdat!, e.invno!, ap);
                              // //  invoiceNumbers = mp.invMemoNum;
                              // //  print("invoice numberr $invoiceNumbers");
                              // final file = File('$dir/Invoice.pdf');
                              // await file.writeAsBytes(bytes);
                              // Navigator.of(context).push(MaterialPageRoute(
                              //     builder: (_) => PdfPreviewScreen(
                              //           path: '$dir/Invoice.pdf',
                              //           title: 'Invoice Pdf',
                              //           isResponsive: true,
                              //           file: file,
                              //         )));
                            },
                            child: Container(
                              margin: EdgeInsets.all(4),
                              // height: Dimensions.fullHeight(context) / 2.7,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: borderColor
                                    // color: Colors.green,
                                    ),
                                // border: Border(
                                //   bottom: BorderSide(width: 2, color: Colors.black),
                                //   top: BorderSide(width: 2, color: Colors.black),
                                // ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    AllOrderTileWidget(title: 'Order Date', value: ' ${DateConverter.formatDateIOS(e.invdat!)}'),
                                    AllOrderTileWidget(title: 'Invoice No', value: '${e.invno1}'),
                                    // streDropDown[_currentIndex!] ==
                                    //         'HO - SALES STORE'
                                    //     ?
                                    AllOrderTileWidget(title: 'store name', value: ' ${e.sectname!}'),
                                    // : AllOrderTileWidget('store name :',
                                    //     ' ${streDropDown[_currentIndex!]}'),
                                    // selectestredDropDownBtn == ''

                                    // _editController[_currentIndex!].text.isEmpty
                                    //     ? AllOrderTileWidget('store name :',
                                    //         ' ${ap.approvedList![_currentIndex!].sectname!}')
                                    //     : AllOrderTileWidget('store name :',
                                    //         ' ${_editController[_currentIndex!].text}'),
                                    AllOrderTileWidget(title: 'Customer Name', value: '${e.custName}'),

                                    AllOrderTileWidget(title: 'Bill Amount', value: '${e.billam} Taka'),
                                    AllOrderTileWidget(title: 'Issued By ', value: '${e.placeid}'),
                                    e.invstatus == "C"
                                        ? AllOrderTileWidget(title: 'Rejected By', value: '${e.invbyName} ')
                                        : AllOrderTileWidget(title: 'Approved By', value: '${e.invbyName} '),
                                    e.invstatus == "A"
                                        ? AllOrderTileWidget(title: 'Status', value: 'Approved')
                                        : AllOrderTileWidget(title: 'Status', value: 'Rejected'),
                                    // AllOrderTileWidget('Bill Amount :', '${e.billam} Taka'),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          e.invstatus == 'C'
                              ? const SizedBox.shrink()
                              : Positioned(
                                  right: 0,
                                  child: IconButton(
                                      onPressed: () async {
                                        await ap.orderDetailsEditable(invNum: e.invno!);
                                        String dir = (await getApplicationDocumentsDirectory()).path;

                                        var bytes = await orderDetailsPdf(PdfPageFormat.legal, mp!, e.custid!, e.custName!,
                                            e.sectname!, e.invdat!, e.invno!, ap);
                                        //  invoiceNumbers = mp.invMemoNum;
                                        //  print("invoice numberr $invoiceNumbers");
                                        final file = File('$dir/Invoice.pdf');
                                        await file.writeAsBytes(bytes);
                                        Navigator.of(context).push(MaterialPageRoute(
                                            builder: (_) => PdfPreviewScreen(
                                                  path: '$dir/Invoice.pdf',
                                                  title: 'Invoice Pdf',
                                                  isResponsive: true,
                                                  file: file,
                                                )));
                                      },
                                      icon: Icon(
                                        FontAwesomeIcons.fileInvoiceDollar,
                                        color: Colors.green,
                                      ))),
                        ],
                      ))
                  .toList(),
            ]),
      ),
    );
  }

  // Future<dynamic> showEditDiag(BuildContext context, AuthProvider ap, int index, MobilFeedProvider mp) {
  //   return showDialog(
  //                               context: context,
  //                               builder: (context) {
  //                                 return AlertDialog(
  //                                   title: Column(
  //                                     children: [
  //                                       Text('Edit Order'),
  //                                       Divider(),
  //                                     ],
  //                                   ),
  //                                   // alignment: Alignment.center,
  //                                   contentPadding: EdgeInsets.zero,
  //                                   insetPadding: EdgeInsets.zero,
  //                                   actions: [
  //                                     TextButton(
  //                                       onPressed: () {},
  //                                       child: Text('Update'),
  //                                     ),
  //                                     TextButton(
  //                                       onPressed: () {
  //                                         Navigator.pop(context);
  //                                       },
  //                                       child: Text('close'),
  //                                     ),
  //                                   ],
  //                                   content: Container(
  //                                     width: double.infinity,
  //                                     child: Column(
  //                                       children: [
  //                                         Padding(
  //                                           padding:
  //                                               const EdgeInsets.all(8.0),
  //                                           child: Row(
  //                                             mainAxisAlignment:
  //                                                 MainAxisAlignment.start,
  //                                             children: [
  //                                               Expanded(
  //                                                 flex: 5,
  //                                                 child: Text(
  //                                                   "Name",
  //                                                   style: TextStyle(
  //                                                     fontWeight:
  //                                                         FontWeight.w600,
  //                                                   ),
  //                                                 ),
  //                                               ),
  //                                               Expanded(
  //                                                   flex: 9,
  //                                                   child: Text(
  //                                                     ap
  //                                                         .approvedList![
  //                                                             _currentIndex!]
  //                                                         .custName!,
  //                                                     style: robotoRegular
  //                                                         .copyWith(
  //                                                       fontSize: 13,
  //                                                     ),
  //                                                   ))
  //                                             ],
  //                                           ),
  //                                         ),
  //                                         Padding(
  //                                           padding:
  //                                               const EdgeInsets.all(8.0),
  //                                           child: Row(
  //                                             mainAxisAlignment:
  //                                                 MainAxisAlignment.start,
  //                                             children: [
  //                                               Expanded(
  //                                                 flex: 5,
  //                                                 child: Text(
  //                                                   "Issued By",
  //                                                   style: TextStyle(
  //                                                     fontWeight:
  //                                                         FontWeight.w600,
  //                                                   ),
  //                                                 ),
  //                                               ),
  //                                               Expanded(
  //                                                   flex: 9,
  //                                                   child: Text(
  //                                                     ap
  //                                                         .approvedList![
  //                                                             _currentIndex!]
  //                                                         .invbyName!,
  //                                                     style: robotoRegular
  //                                                         .copyWith(
  //                                                       fontSize: 13,
  //                                                     ),
  //                                                   ))
  //                                             ],
  //                                           ),
  //                                         ),
  //                                         Padding(
  //                                           padding:
  //                                               const EdgeInsets.all(8.0),
  //                                           child: Row(
  //                                             mainAxisAlignment:
  //                                                 MainAxisAlignment.start,
  //                                             children: [
  //                                               Expanded(
  //                                                 flex: 5,
  //                                                 child: Text(
  //                                                   "Invoice No",
  //                                                   style: TextStyle(
  //                                                     fontWeight:
  //                                                         FontWeight.w600,
  //                                                   ),
  //                                                 ),
  //                                               ),
  //                                               Expanded(
  //                                                 flex: 9,
  //                                                 child: Text(
  //                                                     ap
  //                                                         .approvedList![
  //                                                             _currentIndex!]
  //                                                         .invno!,
  //                                                     style: TextStyle()),
  //                                               ),
  //                                             ],
  //                                           ),
  //                                         ),
  //                                         Text('$index'),
  //                                         Form(
  //                                           key: _form,
  //                                           child: Column(
  //                                             children: [
  //                                               Row(
  //                                                 children: [
  //                                                   Padding(
  //                                                     padding:
  //                                                         const EdgeInsets
  //                                                                 .only(
  //                                                             left: 8.0,
  //                                                             right: 9),
  //                                                     child: Text(
  //                                                       'Edit Store',
  //                                                       style: TextStyle(
  //                                                         fontWeight:
  //                                                             FontWeight.w600,
  //                                                       ),
  //                                                     ),
  //                                                   ),
  //                                                   Expanded(
  //                                                     flex: 5,
  //                                                     child: Padding(
  //                                                       padding:
  //                                                           const EdgeInsets
  //                                                                   .only(
  //                                                               right: 8.0),
  //                                                       child: Material(
  //                                                         elevation: 2,
  //                                                         borderRadius:
  //                                                             BorderRadius
  //                                                                 .circular(
  //                                                                     8),
  //                                                         child: Container(
  //                                                           // height: 40,
  //                                                           width: Dimensions
  //                                                               .fullWidth(
  //                                                                   context),
  //                                                           decoration:
  //                                                               BoxDecoration(
  //                                                             color: Colors
  //                                                                 .grey
  //                                                                 .shade300,
  //                                                             borderRadius:
  //                                                                 BorderRadius
  //                                                                     .circular(
  //                                                                         4),
  //                                                             border: Border.all(
  //                                                                 color: Colors
  //                                                                     .black26),
  //                                                           ),
  //                                                           child:
  //                                                               DropdownButtonHideUnderline(
  //                                                             child:
  //                                                                 DropdownButtonFormField(
  //                                                               alignment:
  //                                                                   Alignment
  //                                                                       .center,

  //                                                               value:
  //                                                                   streDropDown[
  //                                                                       index],
  //                                                               isExpanded:
  //                                                                   true,
  //                                                               // underline: Container(),
  //                                                               style: const TextStyle(
  //                                                                   color: Colors
  //                                                                       .black,
  //                                                                   fontWeight:
  //                                                                       FontWeight
  //                                                                           .w500),
  //                                                               items:
  //                                                                   _dropDownItem(),
  //                                                               onChanged:
  //                                                                   (val) {
  //                                                                 setState(
  //                                                                     () {
  //                                                                   streDropDown[
  //                                                                           index] =
  //                                                                       val as String;
  //                                                                   selectestredDropDownBtn =
  //                                                                       val;
  //                                                                 });
  //                                                               },
  //                                                             ),
  //                                                           ),
  //                                                         ),
  //                                                       ),
  //                                                     ),
  //                                                   ),
  //                                                 ],
  //                                               ),
  //                                               Padding(
  //                                                 padding:
  //                                                     const EdgeInsets.all(
  //                                                         8.0),
  //                                                 child: SingleChildScrollView(
  //                                                     child: _createDataTable(
  //                                                         mp)),
  //                                               ),

  //                                               // TextField(
  //                                               //   controller: _editController[
  //                                               //       _currentIndex!],
  //                                               //   decoration: InputDecoration(
  //                                               //     label:
  //                                               //         Text('Change store'),
  //                                               //   ),
  //                                               // ),
  //                                               // TextButton(
  //                                               //   onPressed: () {
  //                                               //     if (_form.currentState!
  //                                               //         .validate()) {
  //                                               //       setState(() {
  //                                               //         ap
  //                                               //             .approvedList![
  //                                               //                 _currentIndex!]
  //                                               //             .sectname = _editController[
  //                                               //                 _currentIndex!]
  //                                               //             .text;
  //                                               //       });
  //                                               //       print(
  //                                               //           'clcolcocl ${e.sectname} $_currentIndex!');
  //                                               //       Navigator.pop(context);
  //                                               //     }
  //                                               //   },
  //                                               //   child: Text('update'),
  //                                               // ),
  //                                             ],
  //                                           ),
  //                                         ),
  //                                       ],
  //                                     ),
  //                                   ),
  //                                 );
  //                               });
  // }

  List<DropdownMenuItem<String>> _dropDownItem() {
    List<String> ddI = ["LO - SALES STORE", "HO - SALES STORE"];
    return ddI
        .map((value) => DropdownMenuItem(
              value: value,
              child: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Text(
                  value,
                  textAlign: TextAlign.center,
                ),
              ),
            ))
        .toList();
  }

  void _updateTextControllers(OrderHistoryInfoModel ord) {
    setState(() {
      storeChngController.text = ord.sectname.toString();
      //drpV = ord.unit!;
      //unitController.text = ord.unit!;
    });
  }

  // Widget AllOrderTileWidget(String? key, String? value, {double left = 6, double right = 0, double top = 8, double bottom = 4}) {
  //   return value != null
  //       ? Container(
  //           //   decoration: BoxDecoration(border: Border.all(color: Colors.green)),
  //           padding: EdgeInsets.only(left: left, top: top, bottom: bottom, right: right),
  //           child: Row(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: <Widget>[
  //               Expanded(
  //                   flex: 3,
  //                   child: Text(key ?? '',
  //                       style: const TextStyle(
  //                         fontSize: 15,
  //                         color: Color.fromARGB(255, 52, 124, 54),
  //                         fontWeight: FontWeight.w600,
  //                       ))),
  //               Expanded(
  //                   flex: 3,
  //                   child: Text(value,
  //                       style: chakraPetch.copyWith(
  //                           fontSize: 13, fontWeight: FontWeight.w600, color: Color.fromARGB(225, 21, 21, 21))))
  //             ],
  //           ),
  //         )
  //       : SizedBox.shrink();
  //}
}
