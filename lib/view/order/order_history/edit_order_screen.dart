import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:light_fair_bd_new/data/datasource/model/edit_product_model.dart';
import 'package:light_fair_bd_new/provider/auth_provider.dart';
import 'package:light_fair_bd_new/provider/mobil_feed_provider.dart';
import 'package:light_fair_bd_new/provider/theme_provider.dart';
import 'package:light_fair_bd_new/util/dimensions.dart';
import 'package:light_fair_bd_new/util/show_custom_snakbar.dart';
import 'package:light_fair_bd_new/view/base_widget/animated_custom_dialog.dart';
import 'package:light_fair_bd_new/view/home/home.dart';
import 'package:light_fair_bd_new/view/order/order_history/order_status_screen.dart';
import 'package:provider/provider.dart';
import 'package:search_choices/search_choices.dart';
import 'dart:core';

import '../../../util/app_constants.dart';
import '../../../util/color_resources.dart';
import '../../../util/theme/custom_themes.dart';

// ignore: must_be_immutable
class EditOrderProduct extends StatefulWidget {
  final String invno;
  final String custName;
  final String custId;
  final String date;
  final String? placeById;

  String sectNo;
  String? remark;

  final String issuedBy;
  EditOrderProduct({
    Key? key,
    required this.invno,
    required this.custName,
    required this.sectNo,
    required this.custId,
    this.remark,
    required this.issuedBy,
    required this.date,
    this.placeById,
  }) : super(key: key);

  @override
  State<EditOrderProduct> createState() => _EditOrderProductState();
}

class _EditOrderProductState extends State<EditOrderProduct> {
  String? selval;
  String? newProdbatchNo;
  String? selProdPrice;
  String? rateConv;
  int _currentIndex = 0;

  late ScrollController _scrollController;

  TextEditingController unitEditController = TextEditingController();
  TextEditingController qtyEditController = TextEditingController();
  TextEditingController remrkEditController = TextEditingController();
  // final editcommentController = TextEditingController();
  List<TextEditingController>? editcommentController = [];
  late TextEditingController remarkController;
  final editform = GlobalKey<FormState>();
  String? changeunitdrp;
  String? storedrp;
  String? changeStore;
  String? invoiceNumbers;
  String? remarks;
  String? addProdPrice;
  bool addFavorite = false;
  Icon notFavorite = Icon(
    Icons.favorite_border,
    size: 25,
  );
  Icon inFavorite = Icon(
    Icons.favorite,
    size: 25,
  );

  String? rsircode;

  String? bno;
  @override
  void initState() {
    super.initState();
    remarkController = TextEditingController(
        text: (widget.remark!.isEmpty ? 'no remarks added' : widget.remark));
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
  }

  String message = '';
  _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      setState(() {
        message = "reach the bottom";
      });
    }
    if (_scrollController.offset <=
            _scrollController.position.minScrollExtent &&
        !_scrollController.position.outOfRange) {
      setState(() {
        message = "top";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<UserConfigurationProvider, MobilFeedProvider>(
        builder: (context, ap, mp, child) {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: ColorResources.getHomeBg(context),
          elevation: 0,
          title: Text(
            'Order Detail Information',
            style: poppinRegular.copyWith(
                color: ColorResources.getTextBg(context),
                fontSize: 16,
                fontWeight: FontWeight.w600),
          ),
          //  iconTheme: IconThemeData(color: Colors.black),
          leading: CupertinoNavigationBarBackButton(
            onPressed: () => Navigator.pop(context),
            color: Provider.of<ThemeProvider>(context).darkTheme
                ? Colors.white
                : Colors.black,
          ),

          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomeScreen(),
                    ),
                  );
                  // Navigator.pop(context);
                },
                icon: Icon(
                  Icons.menu,
                  color: Provider.of<ThemeProvider>(context).darkTheme
                      ? Colors.white
                      : Colors.black,
                ))
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 5,
                    child: Text(
                      "Date",
                      style: poppinRegular.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Expanded(
                      flex: 9,
                      child: Text(
                        widget.date,
                        style: poppinRegular.copyWith(
                          fontSize: 12,
                        ),
                      ))
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 5,
                    child: Text(
                      "Order Issued by ",
                      style: poppinRegular.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Expanded(
                      flex: 9,
                      child: Text(
                        widget.issuedBy,
                        style: poppinRegular.copyWith(
                          fontSize: 12,
                        ),
                      ))
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 5,
                    child: Text(
                      "Invoice no",
                      style: poppinRegular.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Expanded(
                      flex: 9,
                      child: Text(
                        widget.invno,
                        style: robotoRegular.copyWith(
                          fontSize: 12,
                        ),
                      ))
                ],
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.start,
            //     children: [
            //       Expanded(
            //         flex: 5,
            //         child: Text(
            //           "Store name",
            //           style: TextStyle(
            //             fontWeight: FontWeight.w600,
            //           ),
            //         ),
            //       ),
            //       Expanded(
            //           flex: 9,
            //           child: Text(
            //             widget.sectNo,
            //             style: robotoRegular.copyWith(
            //               fontSize: 13,
            //             ),
            //           ))
            //     ],
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 5,
                    child: Text(
                      "Change store",
                      style: poppinRegular.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 9,
                    child: Material(
                      elevation: 3,
                      borderRadius: BorderRadius.circular(4),
                      child: Container(
                        height: 30,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5),
                            border:
                                Border.all(width: 1, color: Colors.blueGrey)),
                        //  color: Colors.grey.shade300,
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                              borderRadius: BorderRadius.circular(4),
                              value: storedrp ?? widget.sectNo,
                              isExpanded: true,
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal),
                              //alignment: Alignment.centerLeft,
                              iconSize: 30,
                              items: ap.branchList!
                                  .map((e) => DropdownMenuItem(
                                      value: e.sectcod,
                                      child: Center(
                                        child: Text(
                                          '${e.sectname}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 12),
                                        ),
                                      )))
                                  .toList(),
                              onChanged: (String? val) {
                                setState(() {
                                  storedrp = val!;
                                  widget.sectNo = storedrp!;
                                  debugPrint('office ${storedrp}');
                                  debugPrint('Change ${widget.sectNo}');
                                });
                              }),
                        ),
                      ),
                    ),
                  ),
                  // Expanded(
                  //   flex: 9,
                  //   child: Text(widget.sectNo, style: TextStyle()),
                  // ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 5,
                    child: Text(
                      "Customer name",
                      style: poppinRegular.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 9,
                    child: Text(widget.custName,
                        style: poppinRegular.copyWith(
                          fontSize: 12,
                        )),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 5,
                    child: Text(
                      "Remarks:",
                      style: poppinRegular.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 9,
                    child: SizedBox(
                      height: 35,
                      child: TextField(
                        //initialValue: widget.remark!.isEmpty ? 'no remarks added' : widget.remark,
                        controller: remarkController,
                        decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.fromLTRB(5.0, 1.0, 5.0, 1.0),
                          border: OutlineInputBorder(),
                        ),
                        // textAlign: TextAlign.start,
                        // textAlignVertical: TextAlignVertical.center,

                        onChanged: (v) {
                          setState(() {
                            remarks = v;
                            debugPrint('new REmarks $remarks');
                          });
                        },
                        onSubmitted: (val) {
                          setState(() {
                            remarks = val;
                            print('new REmarks $remarks');
                          });
                        },
                      ),
                    ),
                    // child: Text(
                    //   widget.remark,
                    //   style: robotoRegular.copyWith(
                    //     fontSize: 13,
                    //   ),
                    // ),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              color: ColorResources.getHomeBg(context),
              child: Center(
                  child: Text(
                "Number of Products ${ap.editProdList.length}",
                style: poppinRegular.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
              )),
            ),
            const SizedBox(
              height: 5,
            ),
            ap.isEditOrder
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Expanded(
                    flex: 6,
                    child: Container(
                      color: Colors.grey[300],
                      child: ListView(
                        controller: _scrollController,
                        children: [
                          ...ap.editProdList.map((e) {
                            editcommentController!.add(TextEditingController());
                            return InkWell(
                              child: Stack(
                                children: [
                                  Card(
                                    elevation: 2,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 19.0, left: 8),
                                          child: Text(
                                            e.sirdesc!,
                                            style: robotoSlab.copyWith(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 4,
                                        ),
                                        editProdTile('Quantity  :',
                                            '${e.invqty.toString()} PCS'),
                                        editProdTile(
                                            'Unit :', e.sirunit.toString()),
                                        // editProdTile('Amount',
                                        //     '${e.sirunit == 'CTN' ? (e.itmrat! * e.invqty! * e.siruconf!.toDouble()) : (e.itmrat! * e.invqty!)}')
                                        editProdTile('Item rate(per PCS) :',
                                            '${e.itmrat.toString()} BDT '),
                                        editProdTile('Sub Total:',
                                            '${ap.calculateSubTotal(e.invqty!, e.itmrat!)} BDT'),
                                        //   editProdTile('Remark:', '${e.invrmrk}'),
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    right: 0,
                                    bottom: 0,
                                    child: IconButton(
                                        onPressed: () async {
                                          await Provider.of<MobilFeedProvider>(
                                                  context,
                                                  listen: false)
                                              .postAccess(
                                                  custId: widget.custId);

                                          _currentIndex =
                                              ap.editProdList.indexOf(e);

                                          _updateApprovedData(e);
                                          showEditDialog(
                                              e, ap, mp, _currentIndex);
                                        },
                                        icon: const Icon(
                                          Icons.edit,
                                          color: Colors.red,
                                        )),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                  ),
            message != 'top'
                ? Expanded(
                    child: Container(
                      width: Dimensions.fullWidth(context),
                      color: Colors.grey[200],
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Text(
                              'Max Total : ${ap.editedTotal} bdt',
                              //textAlign: TextAlign.center,
                              style: robotoRegular.copyWith(
                                  fontSize: 16,
                                  color:
                                      const Color.fromARGB(255, 56, 119, 58)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
            Expanded(
              child: LayoutBuilder(builder: (context, constraints) {
                return SizedBox(
                  width: constraints.maxWidth,
                  //width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      print('Edited ord prod ${ap.editProdList}');

                      print('');
                      // ap.postApproval(
                      //   editProd: ap.editProdList,
                      //   section: widget.sectNo,
                      //   custID: widget.custName,
                      //   invonum: widget.invno,
                      //   remark: remarks ?? widget.remark,
                      // );
                      showAnimatedDialog(
                        context,
                        StatefulBuilder(builder: (context, setState) {
                          return AlertDialog(
                            actions: [
                              Column(
                                children: [
                                  const Divider(
                                    color: Colors.black,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      ElevatedButton.icon(
                                        onPressed: () {
                                          // setState(() {
                                          //   isApprove = true;
                                          // });
                                          if (ap.jwtTokenModel!.hccode ==
                                                  AppConstants.lfbdRfsHccode ||
                                              ap.jwtTokenModel!.hccode ==
                                                  AppConstants.adminHccode ||
                                              ap.jwtTokenModel!.hccode ==
                                                  AppConstants
                                                      .superAdminHccode ||
                                              ap.jwtTokenModel!.hccode ==
                                                  AppConstants.lfbdEhsHccode) {
                                            ap
                                                .postApproval(
                                                    editProd: ap.editProdList,
                                                    sectionCode: widget.sectNo,
                                                    custID: widget.custId,
                                                    invonum: widget.invno,
                                                    remark: remarks ??
                                                        widget.remark,
                                                    date: widget.date,
                                                    custName: widget.custName,
                                                    userName: ap.jwtTokenModel
                                                            ?.hcname ??
                                                        '',
                                                    hcCode: ap
                                                        .jwtTokenModel!.hccode!,
                                                    sessionID: ap.jwtTokenModel!
                                                        .sessionid!,
                                                    deviceID: ap.deviceName,
                                                    parm12: 'A',
                                                    parm13: widget.placeById,
                                                    context: context)
                                                .then((value) => value.isSuccess
                                                    ? Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              const OrderStatusScreen(),
                                                        ))
                                                    : showCustomSnackBar(
                                                        'Failed', context));
                                          } else {
                                            ap
                                                .postApproval(
                                                    editProd: ap.editProdList,
                                                    sectionCode: widget.sectNo,
                                                    custID: widget.custId,
                                                    invonum: widget.invno,
                                                    remark: remarks ??
                                                        widget.remark,
                                                    date: widget.date,
                                                    custName: widget.custName,
                                                    userName: ap.jwtTokenModel
                                                            ?.hcname ??
                                                        '',
                                                    hcCode: ap
                                                        .jwtTokenModel!.hccode!,
                                                    sessionID: ap.jwtTokenModel!
                                                        .sessionid!,
                                                    deviceID: ap.deviceName,
                                                    parm12: 'D',
                                                    parm13: widget.placeById,
                                                    context: context)
                                                .then((value) {
                                              if (value.isSuccess) {
                                                showCustomSnackBar(
                                                    'Success', context,
                                                    isError: false);
                                                Navigator.pop(context);
                                              } else {
                                                showCustomSnackBar(
                                                    'Failed', context,
                                                    isError: true);
                                              }
                                            });
                                          }

                                          //  ap.approveOrder();

                                          print('approve');
                                        },
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.green),
                                        icon: const Icon(Icons.check),
                                        label: ap.jwtTokenModel!.hccode ==
                                                    AppConstants
                                                        .lfbdRfsHccode ||
                                                ap.jwtTokenModel!.hccode ==
                                                    AppConstants.adminHccode ||
                                                ap.jwtTokenModel!.hccode ==
                                                    AppConstants
                                                        .superAdminHccode ||
                                                ap.jwtTokenModel!.hccode ==
                                                    AppConstants.lfbdEhsHccode
                                            ? const Text('APPROVE')
                                            : const Text('EDIT'),
                                      ),
                                      Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: Dimensions
                                                  .PADDING_SIZE_EXTRA_SMALL),
                                          height: 50,
                                          child: const VerticalDivider(
                                            color: Colors.black,
                                          )),
                                      ElevatedButton.icon(
                                        onPressed: () {
                                          ap.jwtTokenModel!.hccode ==
                                                      AppConstants
                                                          .lfbdRfsHccode ||
                                                  ap.jwtTokenModel!.hccode ==
                                                      AppConstants
                                                          .adminHccode ||
                                                  ap.jwtTokenModel!.hccode ==
                                                      AppConstants
                                                          .superAdminHccode ||
                                                  ap.jwtTokenModel!.hccode ==
                                                      AppConstants.lfbdEhsHccode
                                              ? ap.postApproval(
                                                  editProd: ap.editProdList,
                                                  sectionCode: widget.sectNo,
                                                  custID: widget.custId,
                                                  invonum: widget.invno,
                                                  remark:
                                                      remarks ?? widget.remark,
                                                  date: widget.date,
                                                  custName: widget.custName,
                                                  userName: ap.jwtTokenModel
                                                          ?.hcname ??
                                                      '',
                                                  hcCode:
                                                      ap.jwtTokenModel!.hccode!,
                                                  sessionID: ap.jwtTokenModel!
                                                      .sessionid!,
                                                  deviceID: ap.deviceName,
                                                  parm12: 'C',
                                                  parm13: widget.placeById,
                                                  context: context,
                                                )
                                              : Navigator.pop(context);
                                          //  ap.approveOrder();

                                          // Navigator.push(
                                          //     context,
                                          //     MaterialPageRoute(
                                          //       builder: (context) => OrderStatusScreen(),
                                          //     ));

                                          print('delte');
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red,
                                        ),
                                        icon: const Icon(Icons.delete),
                                        label: ap.jwtTokenModel!.hccode ==
                                                    AppConstants
                                                        .lfbdRfsHccode ||
                                                ap.jwtTokenModel!.hccode ==
                                                    AppConstants.adminHccode ||
                                                ap.jwtTokenModel!.hccode ==
                                                    AppConstants
                                                        .superAdminHccode ||
                                                ap.jwtTokenModel!.hccode ==
                                                    AppConstants.lfbdEhsHccode
                                            ? const Text('Reject')
                                            : const Text('Cancel'),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                            content: SizedBox(
                              height: constraints.maxHeight * 0.9,
                              // height: Dimensions.fullWidth(context) / 4,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Select to Continue',
                                    style: poppinRegular.copyWith(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                  // addFavorite ? inFavorite : notFavorite
                                  ap.isEDit
                                      ? Expanded(
                                          child: Icon(
                                            Icons.check_circle_outline_rounded,
                                            color: Colors.green,
                                            size: constraints.maxHeight,
                                          ),
                                        )
                                      : const SizedBox.shrink()
                                ],
                              ),
                            ),
                          );
                        }),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      textStyle: const TextStyle(
                        fontSize: 23,
                      ),
                    ),
                    child: const Text(
                      'PROCEED',
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      );
    });
  }

  Future<dynamic> showEditDialog(ProductEditModel prod,
      UserConfigurationProvider ap, MobilFeedProvider mp, int index) {
    return showDialog(
        context: context,
        barrierColor: const Color.fromARGB(84, 21, 21, 21),
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              insetPadding: EdgeInsets.zero,
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
                      key: editform,
                      child: Column(
                        children: [
                          SearchChoices.single(
                            value: selval,
                            searchInputDecoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              hintText: 'Search Product',
                              prefixIcon: const Icon(Icons.search),
                              focusColor: Colors.green,
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 18, horizontal: 22),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  width: 2.0,
                                  color: Colors.green,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: const BorderSide(
                                      width: 2, color: Color(0xFFFC6A57))),
                            ),
                            fieldDecoration: BoxDecoration(
                              color: ColorResources.getHomeBg(context),
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                color: Colors.blueGrey,
                                width: 1,
                                style: BorderStyle.solid,
                              ),
                            ),
                            selectedValueWidgetFn: (selectedValue) => Padding(
                              padding: const EdgeInsets.only(left: 4),
                              child: DropdownMenuItem(
                                  child: Text(
                                selectedValue,
                                style: poppinRegular.copyWith(
                                    color: ColorResources.getTextBg(context)),
                              )),
                            ),

                            dialogBox: true,
                            hint: 'Select Product',
                            // menuConstraints:
                            //     BoxConstraints.tight(Size.fromHeight(350)),

                            isExpanded: true,

                            // menuConstraints:
                            //     BoxConstraints.tight(
                            //         Size.fromHeight(50)),
                            // dialogBox: true,
                            // underline: Container(),
                            style: const TextStyle(
                                fontSize: 14, color: Colors.black),
                            items: mp.checkRetItem!
                                .map((e) => DropdownMenuItem(
                                      onTap: () {
                                        selval = e.rateIem!.sirdesc;
                                        rsircode = e.rateIem!.sircode;
                                        newProdbatchNo = e.rateIem!.batchno;
                                        selProdPrice =
                                            e.rateIem!.saleprice.toString();
                                        rateConv =
                                            e.rateIem!.siruconf3.toString();
                                        // bno = e.rateIem!.batchno;

                                        debugPrint(
                                            'sel Prod Price $selProdPrice');
                                      },
                                      value: e.rateIem!.sirdesc!,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.black12),
                                        ),
                                        child: Card(
                                          elevation: 2,
                                          child: ListTile(
                                            //tileColor: Colors.grey[300],
                                            title: Text(
                                              e.rateIem!.sirdesc!,
                                              style: robotoRegular.copyWith(
                                                  fontSize: 11),
                                            ),
                                            subtitle: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(e.rateIem!.sircode!),
                                                Text(
                                                  '1 CTN = ${e.rateIem!.siruconf3!} PCS',
                                                  style: const TextStyle(
                                                      fontSize: 10),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ))
                                .toList(),
                            onChanged: (val) {
                              setState(() {
                                selval = val;
                                // ap.editProdList[_currentIndex].sirdesc =
                                //     selval;
                              });
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              //  width: Dimensions.fullWidth(context) ,
                              height: 40,
                              margin: const EdgeInsets.only(top: 5, bottom: 5),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: ColorResources.getHomeBg(context),
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(
                                  color: Colors.white,
                                ),
                              ),
                              child: Center(
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton(
                                      // value: ap.changeUnitDropDown,
                                      value: changeunitdrp,
                                      isExpanded: true,
                                      hint: const Center(
                                        child: Text('Change Unit'),
                                      ),
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
                                              style: poppinRegular.copyWith(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 13,
                                                // color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: (final String? val) {
                                        // ap.changeUnitDropDown = val!;
                                        setState(() {
                                          changeunitdrp = val;
                                        });
                                      }),
                                ),
                              ),
                            ),
                          ),
                          // SizedBox(
                          //   height: 20,
                          // ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              controller: qtyEditController,
                              // inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'This Field is required';
                                }
                                return null;
                              },
                              keyboardType: TextInputType.number,
                              //keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              decoration: const InputDecoration(
                                labelText: 'QUANTITY',
                                //hintText: 'Quantity',
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 10),
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),

                          // Padding(
                          //   padding: const EdgeInsets.all(8.0),
                          //   child: TextFormField(
                          //     controller: editcommentController![index],
                          //     // inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          //     // validator: (value) {
                          //     //   if (value!.isEmpty) {
                          //     //     return 'This Field is required';
                          //     //   }
                          //     //   return null;
                          //     // },
                          //     keyboardType: TextInputType.text,
                          //     //keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          //     decoration: InputDecoration(
                          //       labelText: 'Remarks',
                          //       //hintText: 'Quantity',
                          //       contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                          //       border: OutlineInputBorder(),
                          //     ),
                          //   ),
                          // ),
                          const SizedBox(
                            height: 20,
                          ),
                          // TextFormField(
                          //   controller: editcommentController,
                          //   decoration: InputDecoration(
                          //     labelText: 'Comment',
                          //     border: OutlineInputBorder(),
                          //   ),
                          // ),
                          const Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton.icon(
                                icon: const Icon(Icons.add),
                                onPressed: () {
                                  if (rsircode != null) {
                                    ap.addProductinEditedList(
                                      prodName: selval,
                                      itmRate: double.parse(selProdPrice!),
                                      qty: double.parse(qtyEditController.text),
                                      chngunit: changeunitdrp,
                                      invno: widget.invno,
                                      batchNo: newProdbatchNo,
                                      rmrk: remrkEditController.text,
                                      //  curIndex: _currentIndex,
                                      rsircode: rsircode,
                                      siruconf: double.parse(rateConv!),
                                    );
                                    Navigator.pop(context);
                                  } else {
                                    showCustomSnackBar(
                                        'ADD NEW PRODUCT TO CONTINUE', context,
                                        isError: true);
                                  }
                                },
                                style: TextButton.styleFrom(
                                    foregroundColor: Colors.purple,
                                    side:
                                        const BorderSide(color: Colors.black)),
                                label: const Text(
                                  'ADD',
                                ),
                              ),
                              Row(
                                // mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  TextButton(
                                    style: TextButton.styleFrom(
                                      foregroundColor: Colors.purple,
                                    ),
                                    onPressed: () {
                                      if (validate() == true) {
                                        editform.currentState!.save();
                                        ap.updateEditedForm(
                                            index: _currentIndex,
                                            changeunitdrp: changeunitdrp!,
                                            qtyEditController:
                                                qtyEditController,
                                            selProdPrice: selProdPrice,
                                            selval: selval,
                                            newProdbatchNo: newProdbatchNo,
                                            rateconv: rateConv,
                                            remrkEditController:
                                                editcommentController
                                            // priceEditController: priceEditController,
                                            );
                                        //updateEditForm(ap);
                                        clearForm();

                                        Navigator.pop(context);
                                      }
                                    },
                                    child: const Text("UPDATE"),
                                  ),
                                  TextButton(
                                    style: TextButton.styleFrom(
                                      foregroundColor: Colors.purple,
                                    ),
                                    onPressed: () {
                                      if (validate() == true) {
                                        _currentIndex =
                                            ap.editProdList.indexOf(prod);
                                        _deleteOrderedProducts(ap);
                                        Navigator.pop(context);
                                      }
                                    },
                                    child: Text(
                                      "DELETE",
                                      style: robotoRegular.copyWith(
                                          color: Colors.red),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            );
          });
        });
  }

  Widget editProdTile(String key, String val, {double? paddingTop}) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: Text(
                key,
                style: poppinRegular.copyWith(
                    fontWeight: FontWeight.w600, fontSize: 15),
              ),
            ),
            Text(
              val,
              style: poppinRegular.copyWith(
                  fontSize: 14, fontWeight: FontWeight.w400),
            ),
          ],
        ),
      );

  // void updateEditForm(AuthProvider ap) {
  //   setState(() {
  //     selval != null ? ap.editProdList[_currentIndex].sirdesc = selval : ap.editProdList[_currentIndex].sirdesc;
  //     selProdPrice != null
  //         ? ap.editProdList[_currentIndex].itmrat = selProdPrice!.toDouble()
  //         : ap.editProdList[_currentIndex].itmrat;
  //     ap.editProdList[_currentIndex].invqty = double.tryParse(qtyEditController.text);
  //     ap.editProdList[_currentIndex].sirunit = changeunitdrp;
  //     // widget.orderAttr.mobilCartProducts![currentIndex].unit = unitController.text;
  //     // widget.orderAttr.comment = commentController.text;

  //     //Code to update the list after editing
  //     //ProductCartModel prods = ProductCartModel(quantity: qtyController.text.toDouble(), unit: unitController.text);
  //     // mobilCartProducts![currentIndex] = prods;
  //   });
  // }

  void _updateApprovedData(ProductEditModel prEdit) {
    setState(() {
      qtyEditController.text = prEdit.invqty.toString();
      changeunitdrp = prEdit.sirunit!;
      selval = prEdit.sirdesc;
      selProdPrice = prEdit.itmrat.toString();
      addProdPrice = prEdit.itmrat.toString();
      //  priceEditController.text = prEdit.itmrat.toString();
      //unitController.text = ord.unit!;
    });
  }

  clearForm() {
    //priceEditController.clear();
    qtyEditController.clear();
    unitEditController.clear();
  }

  bool validate() {
    var valid = editform.currentState!.validate();
    if (valid) editform.currentState!.save();
    return valid;
  }

  void _deleteOrderedProducts(UserConfigurationProvider ap) {
    setState(() {
      ap.editProdList.removeAt(_currentIndex);
    });
  }
}
