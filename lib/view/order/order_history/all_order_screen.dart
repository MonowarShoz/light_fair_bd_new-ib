import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:light_fair_bd_new/data/datasource/model/order_history_info_model.dart';
import 'package:light_fair_bd_new/provider/auth_provider.dart';
import 'package:light_fair_bd_new/provider/mobil_feed_provider.dart';
import 'package:light_fair_bd_new/provider/theme_provider.dart';
import 'package:light_fair_bd_new/util/app_constants.dart';
import 'package:light_fair_bd_new/util/color_resources.dart';
import 'package:light_fair_bd_new/util/date_converter.dart';
import 'package:light_fair_bd_new/util/dimensions.dart';
import 'package:light_fair_bd_new/util/show_custom_snakbar.dart';
import 'package:light_fair_bd_new/util/theme/custom_themes.dart';
import 'package:light_fair_bd_new/view/home/home.dart';
import 'package:light_fair_bd_new/view/order/one_order.dart';
import 'package:light_fair_bd_new/view/order/order_history/edit_order_screen.dart';
import 'package:light_fair_bd_new/view/order/order_history/order_history_screen.dart';

import 'package:provider/provider.dart';
import 'package:search_choices/search_choices.dart';

import '../../base_widget/all_order_widget.dart';

class AllOrderScreen extends StatefulWidget {
  const AllOrderScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<AllOrderScreen> createState() => _AllOrderScreenState();
}

class _AllOrderScreenState extends State<AllOrderScreen> {
  final storeChngController = TextEditingController();
  final _orderSearchController = TextEditingController();
  List<String> streDropDown = [];
  String? selItem;
  String? selectedValueSingleDialog;
  String selectestredDropDownBtn = 'LO-Office';
  int? _currentIndex;
  final _form = GlobalKey<FormState>();
  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
  }

  Future _refreshData() async {
    await Future.delayed(Duration(seconds: 2));
    if (!mounted) return;

    Provider.of<UserConfigurationProvider>(context, listen: false)
        .orderTodateList!
        .clear();
    await Provider.of<UserConfigurationProvider>(context, listen: false)
        .getTodayOrderNotif();

    setState(() {});
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
    // Provider.of<UserConfigurationProvider>(context, listen: false).getTodayOrderNotif();

    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: ColorResources.getHomeBg(context),
          title: Text(
            'Pending Order',
            style: poppinRegular.copyWith(
              color: ColorResources.getTextBg(context),
              fontSize: 16,
              fontWeight: FontWeight.w600
            ),
          ),

          // : Text(
          //     'Approved Order',
          //     style: TextStyle(color: Colors.black),
          //   ),
          leading: CupertinoNavigationBarBackButton(
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => HomeScreen(),
            )),
            color: Provider.of<ThemeProvider>(context).darkTheme
                ? Colors.white
                : Colors.black,
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => OrderHistoryScreen(
                    isPending: true,
                    isApproved: false,
                  ),
                ));
              },
              icon: Icon(Icons.calendar_month),
            ),
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
            color: Provider.of<ThemeProvider>(context).darkTheme
                ? Colors.white
                : Colors.brown,
          ),
        ),
        body: Consumer2<UserConfigurationProvider, MobilFeedProvider>(
            builder: (context, ap, mp, child) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: TextField(
                    controller: _orderSearchController,
                    style: robotoRegular.copyWith(
                        color: Colors.black87, fontSize: 16),
                    decoration: InputDecoration(
                      hintText: 'Search Pending order',
                      focusColor: Colors.green,
                      contentPadding:
                          const EdgeInsets.symmetric(vertical: 18, horizontal: 22),
                      suffixIcon: ap.isPendingOrder
                          ? IconButton(
                              onPressed: () {
                                _orderSearchController.text = '';
                                ap.searchPendingOrder('');
                              },
                              icon: const Icon(
                                Icons.close,
                                color: Colors.red,
                              ))
                          : Icon(
                              Icons.search,
                              color: ColorResources.getIconBg(context),
                            ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          width: 2.0,
                          color: Colors.green,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide:
                              const BorderSide(width: 2, color: Color(0xFFFC6A57))),
                    ),
                    onChanged: (query) {
                      ap.searchPendingOrder(query);
                    },
                  ),
                ),
              ),
              ap.isTodayOrderLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : ap.orderTodateList!.isEmpty
                      ? const Center(
                          child: Text('No Data'),
                        )
                      : Expanded(
                          child: RefreshIndicator(
                          onRefresh: _refreshData,
                          child: ListView.builder(
                              itemCount: ap.orderTodateList!.length,
                              itemBuilder: (context, index) {
                                print(
                                    'total notif ${ap.orderTodateList!.length}');
                                // for (var i = 0; i < ap.orderTodateList!.length; i++) {
                                //   _editController.add(TextEditingController());
                                // }
                                // for (var i = 0; i < ap.orderTodateList!.length; i++) {
                                //   streDropDown.add('HO - SALES STORE');
                                // }
                                // _currentIndex = index;
                                //     .indexOf(ap.orderTodateList![index]);
                                return InkWell(
                                  onTap: () async {
                                    // _currentIndex = ap.orderTodateList!
                                    //     .indexOf(ap.orderTodateList![index]);
                                    // setState(() {
                                    //   ap.isLoading = false;
                                    // setState(() {
                                    //   _isLoading = true;
                                    // });
                                    // });
                                    await ap.orderDetailsEditable(
                                        invNum:
                                            ap.orderTodateList![index].invno!);
                                    // setState(() {
                                    //   _isLoading = false;
                                    // });
                                    await ap.getCompanyBranchInfo();

                                    // ap.jwtTokenModel!.hccode == AppConstants.lfbdRfsHccode ||
                                    //         ap.jwtTokenModel!.hccode == AppConstants.adminHccode ||
                                    //         ap.jwtTokenModel!.hccode == AppConstants.superAdminHccode ||
                                    //         ap.jwtTokenModel!.hccode == AppConstants.lfbdEhsHccode
                                    //     ?
                                    showGeneralDialog(
                                      context: context,
                                      pageBuilder: (context, animation,
                                              secondaryAnimation) =>
                                          EditOrderProduct(
                                        invno:
                                            ap.orderTodateList![index].invno!,
                                        custName: ap
                                            .orderTodateList![index].custName!,
                                        custId:
                                            ap.orderTodateList![index].custid!,
                                        sectNo:
                                            ap.orderTodateList![index].sectcod!,
                                        issuedBy: ap
                                            .orderTodateList![index].invbyName!,
                                        remark:
                                            ap.orderTodateList![index].invnar!,
                                        date: DateConverter.formatDateIOS(
                                            ap.orderTodateList![index].invdat!),
                                        placeById:
                                            ap.orderTodateList![index].placeid,
                                      ),
                                    );
                                    //   : showCustomSnackBar('You Do not Have permission', context);
                                    //  showEditDiag(context, ap, index, mp);
                                    // setState(() {
                                    //   ap.orderTodateList![index].totslam = 200;

                                    // });

                                    // print(
                                    //     ' Seen Item ${ap.orderTodateList![index].delivartime}');
                                  },
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      side: BorderSide(
                                        color: Colors.greenAccent,
                                      ),
                                    ),
                                    elevation: 2,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          // _isLoading
                                          //     ? Center(
                                          //         child: CircularProgressIndicator(),
                                          //       )
                                          //     : SizedBox.shrink(),
                                          AllOrderTileWidget(
                                              title: 'Order Date',
                                              value:
                                                  ' ${DateConverter.formatDateIOS(ap.orderTodateList![index].invdat!)}'),
                                          AllOrderTileWidget(
                                              title: 'Invoice No',
                                              value:
                                                  '${ap.orderTodateList![index].invno1}'),
                                          // streDropDown[_currentIndex!] ==
                                          //         'HO - SALES STORE'
                                          //     ?
                                          AllOrderTileWidget(
                                              title: 'store name',
                                              value:
                                                  ' ${ap.orderTodateList![index].sectname!}'),
                                          // : AllOrderTileWidget('store name :',
                                          //     ' ${streDropDown[_currentIndex!]}'),
                                          // selectestredDropDownBtn == ''

                                          // _editController[_currentIndex!].text.isEmpty
                                          //     ? AllOrderTileWidget('store name :',
                                          //         ' ${ap.orderTodateList![_currentIndex!].sectname!}')
                                          //     : AllOrderTileWidget('store name :',
                                          //         ' ${_editController[_currentIndex!].text}'),
                                          AllOrderTileWidget(
                                              title: 'Customer Name',
                                              value:
                                                  '${ap.orderTodateList![index].custName}'),

                                          AllOrderTileWidget(
                                              title: 'Bill Amount',
                                              value:
                                                  '${ap.orderTodateList![index].billam} Taka'),
                                          // (ap.jwtTokenModel!.hccode == "950600801003" ||
                                          //         ap.jwtTokenModel!.hccode == "950600801001" ||
                                          //         ap.jwtTokenModel!.hccode == "950600801002" ||
                                          //         ap.jwtTokenModel!.hccode == '950600801005')

                                          AllOrderTileWidget(
                                              title: 'Issued By',
                                              value:
                                                  '${ap.orderTodateList![index].invbyName} '),

                                          // SizedBox.shrink(),
                                          ap.orderTodateList![index].invnar!
                                                  .isNotEmpty
                                              ? AllOrderTileWidget(
                                                  title: 'Remarks ',
                                                  value:
                                                      '${ap.orderTodateList![index].invnar}')
                                              : SizedBox.shrink(),
                                          AllOrderTileWidget(
                                              title: 'status',
                                              value: 'Pending'),

                                          // AllOrderTileWidget('status :', '${ap.orderTodateList![index].invstatus}')

                                          // !widget.pending
                                          //     ? ap.orderTodateList![index].invstatus == 'A'
                                          //         ? AllOrderTileWidget('status :', 'APPROVED')
                                          //         : AllOrderTileWidget('status :', 'Rejected')
                                          //     : SizedBox.shrink()
                                          // AllOrderTileWidget('Approver', )
                                          // ap.isApproveProceed
                                          //     ? AllOrderTileWidget('Approved', 'true')
                                          //     : AllOrderTileWidget('Approved', 'false'),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }),
                        )),
            ],
          );
        }),
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
  //                                                         .orderTodateList![
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
  //                                                         .orderTodateList![
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
  //                                                         .orderTodateList![
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
  //                                               //             .orderTodateList![
  //                                               //                 _currentIndex!]
  //                                               //             .sectname = _editController[
  //                                               //                 _currentIndex!]
  //                                               //             .text;
  //                                               //       });
  //                                               //       print(
  //                                               //           'clcolcocl ${ap.orderTodateList![index].sectname} $_currentIndex!');
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
  //   return value != null ? AllOrderTileWidget(context: context) : SizedBox.shrink();
  // }
}
