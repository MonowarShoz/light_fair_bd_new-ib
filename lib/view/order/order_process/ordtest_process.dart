// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dartx/dartx.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:light_fair_bd_new/localization/language_constraints.dart';
import 'package:light_fair_bd_new/provider/auth_provider.dart';
import 'package:light_fair_bd_new/provider/mobil_feed_provider.dart';
import 'package:light_fair_bd_new/provider/theme_provider.dart';
import 'package:light_fair_bd_new/util/color_resources.dart';
import 'package:light_fair_bd_new/util/dimensions.dart';
import 'package:light_fair_bd_new/util/images.dart';
import 'dart:async';
import 'package:light_fair_bd_new/util/show_custom_snakbar.dart';
import 'package:light_fair_bd_new/util/theme/custom_themes.dart';
import 'package:light_fair_bd_new/view/base_widget/animated_custom_dialog.dart';
import 'package:light_fair_bd_new/view/base_widget/order_cart_clear_dialog.dart';
import 'package:light_fair_bd_new/view/order/customer_preview/customer_dialog.dart';
import 'package:light_fair_bd_new/view/order/pdf_preview_screen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:light_fair_bd_new/view/order/order_details/order_screen.dart';
import 'package:pdf/pdf.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../../product_feed/customer_list_pdf.dart';
import '../../product_feed/product_feed_dialog.dart';

class OrdTestProcess extends StatefulWidget {
  final String? name;
  final String? fullName;
  final String? address;

  const OrdTestProcess({
    Key? key,
    this.name,
    this.fullName,
    this.address,
  }) : super(key: key);

  @override
  _OrdTestProcessState createState() => _OrdTestProcessState();
}

class _OrdTestProcessState extends State<OrdTestProcess> {
  String? sectionSelect;
  String? storeName;
  bool checkValue = false;

  String? selectedType;

  DateTime? _selectedDate;

  final modfb = TextEditingController();

  final DateTime _ow = DateTime.now();
  bool isLoading = false;
  bool isLoad = false;
  DateTime? mot;

  String? attdate;

  // List<AppointmentEmployeeIdAndName> empIDS;
  CarouselController buttonCarouselController = CarouselController();
  final commentController = TextEditingController();
  final quantityController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  TextEditingController prodSrchContr = TextEditingController();
  final qtcontrollers = TextEditingController();
  List<TextEditingController>? newqtyController = [];
  List<TextEditingController>? prodRemarkController = [];
  final List<String> dropdown = [];
  bool? isOrd;
  String selectedDropDownBtn = 'PCS';

  // void _presentDatePicker() {
  //   showDatePicker(
  //     context: context,
  //     initialDate: DateTime.now(),
  //     firstDate: DateTime(2019),
  //     lastDate: DateTime.now(),
  //   ).then((pickedDate) {
  //     if (pickedDate == null) {
  //       return;
  //     }
  //     setState(() {
  //       _selectedDate = pickedDate;
  //     });
  //   });
  //   print('...');
  // }
  @override
  void dispose() {
    searchController.dispose();
    prodSrchContr.dispose();
    commentController.dispose();
    for (final controller in newqtyController!) {
      controller.dispose();
    }

    super.dispose();
  }

  @override
  void initState() {
    searchController = TextEditingController();
    prodSrchContr = TextEditingController();
    getBranch();

    super.initState();
  }

  getBranch() async {
    await Provider.of<UserConfigurationProvider>(context, listen: false)
        .getCompanyBranchInfo();
  }

  String? getText() {
    if (_selectedDate == null) {
      return '${DateFormat('dd-MMM-yyyy').format(_ow)} ';
    } else {
      return DateFormat('dd-MMM-yyyy').format(_selectedDate!);
    }
  }

  String? prodPrice;
  double? qt;
  // String? customerName;
  // String? customerID;
  String? quantityMeasurements;

  List<String> drpDownSelectedItem = <String>[];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
          //resizeToAvoidBottomInset: false,

          // backgroundColor: Provider.of<ThemeProvider>(context).darkTheme
          //     ? Color(0xFF303030)
          //     : Colors.white,
          backgroundColor: ColorResources.getHomeBg(context),
          appBar: AppBar(
            elevation: 2,

            // systemOverlayStyle: SystemUiOverlayStyle(
            //   statusBarBrightness: Brightness.light,
            //   statusBarColor: Colors.lightGreen,
            //
            // ),

            iconTheme: IconThemeData(
              color: Provider.of<ThemeProvider>(context).darkTheme
                  ? Colors.white
                  : Colors.brown,
            ),
            titleSpacing: 1.0,
            title: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     AppTitleText(fontsize: 19,),
                //
                //   ],
                // ),
                //SizedBox(height: 10,),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      getTranslated("order_screen", context),
                      style: poppinRegular.copyWith(
                        fontSize: 17,
                        //color: Colors.white,
                        color: Provider.of<ThemeProvider>(context).darkTheme
                            ? Colors.white
                            : Colors.black,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            leading: Consumer2<UserConfigurationProvider, MobilFeedProvider>(
                builder: (context, ap, mp, child) {
              return CupertinoNavigationBarBackButton(
                onPressed: () {
                  mp.clearWholeCart();
                  ap.deletefromSelected();
                  Navigator.pop(context);
                },
                color: Provider.of<ThemeProvider>(context).darkTheme
                    ? Colors.white
                    : Colors.black,
              );
            }),
            backgroundColor: Provider.of<ThemeProvider>(context).darkTheme
                ? const Color(0xFF303030)
                : Colors.white,
            systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarBrightness: Brightness.light,
              statusBarColor: Colors.lightGreen,
            ),
            actions: [
              IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Center(
                              child: Text(
                            'How To Order',
                            style: poppinRegular.copyWith(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          )),
                          alignment: Alignment.topRight,
                          content: SizedBox(
                              width: 300,
                              height: Dimensions.fullHeight(context) / 2.3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Text(
                                      '1. Select Date from the green button',
                                      style: poppinRegular.copyWith(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  const Divider(),
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                      '2. Pick Customer from the List.',
                                      style: poppinRegular.copyWith(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  const Divider(),
                                  Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: Text(
                                      '3. Select Products List and add products to cart.',
                                      style: poppinRegular.copyWith(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  const Divider(),
                                  Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: Text(
                                      '4. After that click on cart icon and select unit & quantity.',
                                      style: poppinRegular.copyWith(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  const Divider(),
                                  Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: Text(
                                      '5. Finally press Place your Order button to proceed.',
                                      style: poppinRegular.copyWith(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  const Divider(),
                                ],
                              )),
                        );
                      });
                },
                icon: Icon(
                  FontAwesomeIcons.circleQuestion,
                  color: Provider.of<ThemeProvider>(context).darkTheme
                      ? Colors.white
                      : Colors.brown,
                ),
              ),
            ],
          ),
          body: Consumer2<MobilFeedProvider, UserConfigurationProvider>(
            builder: (context, mobilFeedProvider, ap, child) {
              return SizedBox(
                width: Dimensions.fullWidth(context),
                height: Dimensions.fullHeight(context),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Select Date : ',
                              style: poppinRegular.copyWith(
                                  fontSize: 14, fontWeight: FontWeight.w600),
                            ),
                            InkWell(
                              onTap: () async {
                                await pickDateTime(context);
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width / 2,
                                height: 40,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.white,
                                  ),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: ElevatedButton.icon(
                                  onPressed: () async {
                                    await pickDateTime(context);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    elevation: 0,
                                    backgroundColor: Colors.green,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                  icon: const Icon(Icons.calendar_month),
                                  label: Text(
                                    getText()!,
                                    style: poppinRegular.copyWith(),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      ap.jwtTokenModel!.designation == 'MARKETING MAN'
                          ? const SizedBox.shrink()
                          : Padding(
                              padding: const EdgeInsets.only(
                                  top: 8, left: 3, right: 3, bottom: 2),
                              child: Material(
                                color: Colors.grey.shade300,
                                //borderRadius:BorderRadius.circular(4),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                  side: const BorderSide(
                                    color: Colors.black26,
                                  ),
                                ),
                                child: Container(
                                  height: 40,
                                  width: Dimensions.fullWidth(context),
                                  margin: const EdgeInsets.all(2),

                                  // decoration: BoxDecoration(
                                  //   color: Colors.grey.shade300,
                                  //   borderRadius: BorderRadius.circular(4),
                                  //   border: Border.all(color: Colors.black26),
                                  // ),
                                  // color: Colors.grey.shade300,
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton(
                                      // border: BorderSide(color: Colors.black12, width: 1),
                                      // padding: const EdgeInsets.all(2),
                                      // dropdownButtonColor: Colors.grey[300],

                                      disabledHint: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: Row(
                                          children: [
                                            const Padding(
                                              padding:
                                                  EdgeInsets.only(right: 8.0),
                                              child: Icon(
                                                Icons.store,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            Text(
                                              'Pick Store',
                                              style: poppinRegular.copyWith(
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black,
                                                  fontSize: 15),
                                            ),
                                          ],
                                        ),

                                        // textAlign: TextAlign.center,
                                      ),
                                      hint: const Padding(
                                        padding: EdgeInsets.only(left: 8.0),
                                        child: Row(
                                          children: [
                                            Padding(
                                              padding:
                                                  EdgeInsets.only(right: 8.0),
                                              child: Icon(Icons.store),
                                            ),
                                            Text(
                                              'Pick Store',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black,
                                                  fontSize: 15),
                                            ),
                                          ],
                                        ),

                                        // textAlign: TextAlign.center,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                      // value: ap.sectionSelect,
                                      value: sectionSelect,
                                      isExpanded: false,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.black,
                                      ),
                                      //alignment: Alignment.centerLeft,
                                      iconSize: 30,
                                      items: ap.branchList!.map((e) {
                                        return DropdownMenuItem<String>(
                                            value: e.sectcod,
                                            onTap: () {
                                              setState(() {
                                                storeName = e.sectname;
                                              });
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0),
                                              child: Row(
                                                children: [
                                                  const Padding(
                                                    padding: EdgeInsets.only(
                                                        right: 8.0),
                                                    child: Icon(Icons.store),
                                                  ),
                                                  Text(
                                                    '${e.sectname}',
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 14),
                                                  ),
                                                ],
                                              ),
                                            ));
                                      }).toList(),
                                      onChanged: (val) {
                                        ap.sectionsSelect(val);

                                        ap.jwtTokenModel!.hccode!
                                                    .substring(0, 9) ==
                                                '950200103'
                                            ? null
                                            : setState(() {
                                                sectionSelect = val;
                                                debugPrint(
                                                    'office $sectionSelect');
                                              });
                                      },
                                      // onChanged: ap.jwtTokenModel!.hccode!.substring(0, 9) == '950200103'
                                      //     ? null
                                      //     : (String? val) {
                                      //         // ap.sectionsSelect(val);
                                      //         setState(() {
                                      //           sectionSelect = val;
                                      //           debugPrint('office $sectionSelect');
                                      //         });
                                      //       },
                                    ),
                                  ),
                                ),
                              ),
                            ),

                      SizedBox(
                        height: 49,
                        //width: Dimensions.fullWidth(context),
                        child: InkWell(
                          splashColor: const Color.fromARGB(255, 239, 239, 239),
                          onTap: () async {
                            setState(() {
                              isLoading = true;
                            });
                            await Provider.of<UserConfigurationProvider>(
                                    context,
                                    listen: false)
                                .initializeCustomerList();
                            setState(() {
                              isLoading = false;
                            });
                            showDialog(
                                context: context,
                                builder: (context) => const CustomerDialog());

                            //buildCustomerListDialog();
                          },
                          child: Card(
                            elevation: 2,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(color: Colors.black26),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Icon(
                                          FontAwesomeIcons.chalkboardUser,
                                          size: 19,
                                          color: Colors.black,
                                        ),
                                      ),

                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: Text(
                                          getTranslated(
                                              "select_customer", context),
                                          //'Select Customer',
                                          style: poppinRegular.copyWith(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black,
                                          ),
                                          // style: GoogleFonts.chakraPetch(
                                          //   fontWeight: FontWeight.w600,
                                          //   fontSize: 16,
                                          //   color: Colors.black,
                                          //   // color: Color(65,88,208),
                                          // ),
                                        ),
                                      ),

                                      // SizedBox(
                                      //   width: 5,
                                      // ),
                                    ],
                                  ),
                                  isLoading
                                      ? Padding(
                                          padding:
                                              const EdgeInsets.only(right: 20),
                                          child: SizedBox(
                                            height: 20,
                                            width: 20,
                                            child: CircularProgressIndicator(
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                      ColorResources.getPrimary(
                                                          context)),
                                            ),
                                          ),
                                        )
                                      : Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Icon(
                                            (ap.selectedCustomerName == null &&
                                                    ap.selectedCustomerID ==
                                                        null)
                                                // (customerName == null && customerID == null)
                                                ? FontAwesomeIcons.userGear
                                                : FontAwesomeIcons.userCheck,
                                            color: Colors.black,
                                            size: 17,
                                          ),
                                        ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      // const SizedBox(
                      //   height: 12,
                      // ),
                      // const Divider(
                      //   thickness: 2,
                      //   height: 12,
                      // ),

                      // widget.name != null
                      ap.selectedCustomerName != null
                          ? Dismissible(
                              key: UniqueKey(),
                              direction: DismissDirection.endToStart,
                              onDismissed: (direction) {
                                ap.deletefromSelected();
                                // ap.selectedCustomerName = null;
                                // ap.selectedCustomerID = null;
                                // customerName = null;
                                // customerID = null;
                                mobilFeedProvider.clearWholeCart();
                              },
                              background: Container(
                                color: Theme.of(context).colorScheme.error,
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.only(right: 20),
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 15,
                                  vertical: 4,
                                ),
                                child: const Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                  size: 40,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: InkWell(
                                  child: Container(
                                    height:
                                        MediaQuery.of(context).size.height / 8,

                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: Provider.of<ThemeProvider>(context)
                                              .darkTheme
                                          ? const Color.fromARGB(
                                              137, 130, 124, 124)
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        style: BorderStyle.solid,
                                        color: Colors.grey,
                                      ),
                                    ),

                                    // color: Colors.grey.shade200,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(9.0),
                                          child: Row(
                                            children: [
                                              Text(
                                                'Customer ID :',
                                                style: poppin.copyWith(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 15,
                                                ),
                                              ),
                                              //Flexible(fit: FlexFit.loose, child: SizedBox()),

                                              Expanded(
                                                //flex: 2,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 8.0),
                                                  child: Text(
                                                    '${ap.selectedCustomerID}',
                                                    style: chakraPetch.copyWith(
                                                      color:
                                                          Provider.of<ThemeProvider>(
                                                                      context)
                                                                  .darkTheme
                                                              ? Colors.white
                                                              : Colors.black,
                                                      // color: Provider.of<ThemeProvider>(context).darkTheme
                                                      //     ? Colors.lightGreenAccent
                                                      //     : Colors.green.shade900,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 13,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              // Padding(
                                              //   padding: const EdgeInsets.only(left: 8.0, top: 6),
                                              //   child: Text(
                                              //     'Customer ID :',
                                              //     style: chakraPetch.copyWith(
                                              //       fontWeight: FontWeight.w600,
                                              //       fontSize: 15,
                                              //     ),
                                              //   ),
                                              // ),
                                              // Padding(
                                              //   padding: const EdgeInsets.only(left: 8.0, top: 6),
                                              //   child: Text(
                                              //     '$customerID',
                                              //     style: chakraPetch.copyWith(
                                              //       color: Colors.green.shade900,
                                              //       fontWeight: FontWeight.w600,
                                              //       fontSize: 13,
                                              //     ),
                                              //   ),
                                              // ),
                                            ],
                                          ),
                                        ),
                                        const Divider(),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8.0),
                                          child: Row(
                                            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Text(
                                                '${getTranslated('name', context)} :',
                                                style: poppin.copyWith(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 15,
                                                ),
                                              ),
                                              Flexible(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 8.0),
                                                  child: Text(
                                                    '${ap.selectedCustomerName}',
                                                    style: chakraPetch.copyWith(
                                                        //decoration: TextDecoration.underline,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 13,
                                                        color:
                                                            Provider.of<ThemeProvider>(
                                                                        context)
                                                                    .darkTheme
                                                                ? Colors.white
                                                                : Colors.black
                                                        // color: Provider.of<ThemeProvider>(context).darkTheme
                                                        //     ? Colors.lightGreenAccent
                                                        //     : Colors.green.shade900,
                                                        ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : const SizedBox.shrink(),

                      // const SizedBox(
                      //   height: 3,
                      // ),

                      InkWell(
                        onTap: () {
                          ap.selectedCustomerID == null
                              ? showCustomSnackBar(
                                  'Please Select Customer first', context)
                              : showGeneralDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  transitionDuration:
                                      const Duration(milliseconds: 200),
                                  transitionBuilder: (context, animation,
                                      secondaryAnimation, child) {
                                    return FadeTransition(
                                      opacity: animation,
                                      child: ScaleTransition(
                                        scale: animation,
                                        child: child,
                                      ),
                                    );
                                  },
                                  pageBuilder: (context, animation,
                                          secondaryAnimation) =>
                                      NewProdDiagWidget(
                                    prodSearchController: prodSrchContr,
                                    custId: ap.selectedCustomerID,
                                    // custId: customerID,
                                  ),
                                );
                        },
                        child: SizedBox(
                          height: 49,
                          child: Card(
                            elevation: 2,
                            color: Colors.grey.shade300,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(color: Colors.black26),
                              ),
                              child: Row(
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: InkWell(
                                      child: Icon(
                                        FontAwesomeIcons.list,
                                        color: Colors.black,
                                        size: 18,
                                      ),
                                    ),
                                  ),

                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        getTranslated("products_list", context),
                                        // 'Products List',
                                        style: poppinRegular.copyWith(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black),
                                        // style: GoogleFonts.chakraPetch(
                                        //   fontWeight: FontWeight.w600,
                                        //   fontSize: 16,
                                        //   color: Colors.black,
                                        // ),
                                        // style: TextStyle(
                                        //   color: Colors.black,
                                        //   fontWeight: FontWeight.w500,
                                        // ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: InkWell(
                                      onTap: () {},
                                      child: Icon(
                                        mobilFeedProvider.cartItems.isEmpty
                                            ? FontAwesomeIcons.cartPlus
                                            : FontAwesomeIcons.listCheck,
                                        color: Colors.black,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                  // SizedBox(
                                  //   width: 5,
                                  // ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      // const Divider(),

                      mobilFeedProvider.cartItems.isEmpty
                          ? const SizedBox.shrink()
                          : Column(
                              children: [
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height / 3.3,
                                  child: CarouselSlider.builder(
                                    carouselController:
                                        buttonCarouselController,
                                    itemCount:
                                        mobilFeedProvider.cartItems.length,
                                    itemBuilder: (context, index, page) {
                                      newqtyController
                                          ?.add(TextEditingController());
                                      prodRemarkController
                                          ?.add(TextEditingController());
                                      for (int i = 0;
                                          i <
                                              mobilFeedProvider
                                                  .cartItems.values.length;
                                          i++) {
                                        drpDownSelectedItem.add('CTN');
                                      }
                                      return CartTile(
                                        index: index,
                                        mobilFeedProvider: mobilFeedProvider,
                                        drpDownSelectedItem:
                                            drpDownSelectedItem,
                                        newqtyController: newqtyController,
                                        //  fn: _dropDownItem(),
                                      );
                                    },
                                    options: CarouselOptions(
                                      enableInfiniteScroll: false,
                                      autoPlay: false,
                                      scrollDirection: Axis.vertical,
                                      enlargeCenterPage: true,
                                      viewportFraction: 1,
                                      aspectRatio: 2.0,
                                      initialPage: 0,
                                    ),
                                  ),
                                ),
                                // const Divider(),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      // Padding(
                                      //   padding: const EdgeInsets.only(left: 8.0, right: 5),
                                      //   child: InkWell(
                                      //     onTap: () => buttonCarouselController.previousPage(
                                      //         duration: Duration(milliseconds: 300), curve: Curves.linear),
                                      //     child: Container(
                                      //       width: 30,
                                      //       height: 40,
                                      //       child: Icon(
                                      //         FontAwesomeIcons.arrowUpLong,
                                      //         size: 20,
                                      //       ),
                                      //     ),
                                      //   ),
                                      // ),
                                      Expanded(
                                        child: Container(
                                          height: 40,

                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(9),
                                            color: Colors.grey.shade300,
                                          ),
                                          //width: MediaQuery.of(context).size.width / 2,
                                          child: SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            // child: Center(
                                            //   child: Padding(
                                            //     padding: const EdgeInsets.all(8.0),
                                            //     child: Text(
                                            //       'Cart Items ${mobilFeedProvider.cartItems.length}',
                                            //       textAlign: TextAlign.center,
                                            //       style: chakraPetch.copyWith(
                                            //         fontWeight: FontWeight.w600,
                                            //         fontSize: 15,
                                            //       ),
                                            //     ),
                                            //   ),
                                            // ),
                                            child: Row(
                                              // mainAxisAlignment: MainAxisAlignment.start,

                                              children: [
                                                ...Iterable<int>.generate(
                                                        mobilFeedProvider
                                                            .cartItems.length)
                                                    .map(
                                                  (int pageIndex) {
                                                    return Material(
                                                      color:
                                                          Colors.grey.shade300,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                      child: InkResponse(
                                                        onTap: () {
                                                          buttonCarouselController
                                                              .animateToPage(
                                                                  pageIndex);
                                                        },
                                                        radius: 20,
                                                        splashColor:
                                                            Colors.lightGreen,
                                                        highlightColor:
                                                            Colors.transparent,
                                                        //splashFactory: InkRipple.splashFactory,

                                                        child: Container(
                                                          width: 30,
                                                          height: 45,
                                                          margin:
                                                              const EdgeInsets
                                                                  .all(2),
                                                          decoration:
                                                              const BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                            // borderRadius: BorderRadius.circular(20),
                                                            color: Colors.green,
                                                          ),
                                                          child: Center(
                                                            child: Text(
                                                              "${pageIndex + 1}",
                                                              style:
                                                                  const TextStyle(
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),

                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 8.0, right: 5),
                                        child: InkWell(
                                          onTap: () {
                                            showAnimatedDialog(
                                                context,
                                                OrderClearDialog(
                                                  isOrder: false,
                                                  newqty: newqtyController,
                                                  drpDownSelectedItem:
                                                      drpDownSelectedItem,
                                                ),
                                                isFlip: true);
                                            // newqtyController!.clear();
                                          },
                                          splashColor: Colors.green,
                                          child: Ink(
                                            //color: Colors.white,
                                            child: SizedBox(
                                              width: 30,
                                              height: 40,
                                              //color: Colors.white,
                                              child: Image.asset(
                                                Images.clear_cart,
                                                //color: Colors.grey,
                                                //size: 20,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                      const SizedBox(
                        height: 2,
                      ),
                      mobilFeedProvider.cartItems.isEmpty
                          ? const SizedBox.shrink()
                          : Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                height: 70,
                                child: TextFormField(
                                  controller: commentController,
                                  // onFieldSubmitted: (_) {
                                  //   attendanceProvider.submitAttendance(
                                  //       widget.empId, context);
                                  // },
                                  cursorColor: Colors.black,
                                  maxLength: 120,

                                  decoration: InputDecoration(
                                    hintText: 'Remarks...',
                                    hintStyle: const TextStyle(
                                      color: Colors.black45,
                                    ),

                                    filled: true,
                                    fillColor: Colors.grey.shade200,
                                    border: const OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(23)),
                                      borderSide:
                                          BorderSide(color: Colors.black),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          const BorderSide(color: Colors.white),
                                      borderRadius: BorderRadius.circular(25.7),
                                    ),
                                    // labelText: 'Comment',
                                    // labelStyle: TextStyle(
                                    //   color: Colors.black,
                                    // ),
                                    helperText: 'Post your comment here',
                                    //  suffixIcon: Icon(
                                    //    Icons.check_circle,
                                    //
                                  ),
                                ),
                              ),
                            ),
                      // Padding(
                      //   padding: const EdgeInsets.all(8.0),
                      //   child: TextField(
                      //     controller: commentController,
                      //     decoration: InputDecoration(hintText: 'comment'),
                      //   ),
                      // ),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 8, right: 8, top: 40),
                        child: SizedBox(
                          height: 50,
                          width: double.infinity,
                          child: CupertinoButton(
                            color: Colors.green,
                            minSize: 20,
                            onPressed: () async {
                              if (mobilFeedProvider.cartItems.isNotEmpty &&
                                      ap.selectedCustomerID != null &&
                                      ap.selectedCustomerName != null
                                  // customerName != null &&
                                  // customerID != null &&
                                  //ap.sectionSelect != null
                                  // sectionSelect != null
                                  ) {
                                mobilFeedProvider.addOrderProcess(
                                  cartProd: mobilFeedProvider.cartItems.values
                                      .toList(),
                                  custID: ap.selectedCustomerID,
                                  custName: ap.selectedCustomerName,
                                  date: getText(),

                                  //customerName,

                                  comment: commentController.text,

                                  // invNum: (Random().nextInt(900000)).toString(),
                                  total: mobilFeedProvider.totalAmountOrder
                                      .toString(),
                                );

                                for (int i = 0;
                                    i < mobilFeedProvider.cartItems.length;
                                    i++) {
                                  newqtyController![i].clear();
                                }

                                drpDownSelectedItem.clear();
                                //ap.clearSectionSelect();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => OrderScreen(
                                      isOrderScreen: true,
                                      section: sectionSelect ?? '110100101002',
                                      storeName: storeName ?? 'HO-SALES STORE',
                                    ),
                                  ),
                                );

                                ap.deletefromSelected();
                                String jsString =
                                    jsonEncode(mobilFeedProvider.getOrders);
                                print("Good string $jsString");
                                mobilFeedProvider.clearWholeCart();

                                // newqtyController!.clear();
                              } else {
                                showCustomSnackBar(
                                    'Add data to complete Operation', context);
                              }
                            },
                            child: Text(
                              getTranslated("place_order", context),
                              style: poppinRegular.copyWith(fontSize: 16),
                            ),
                          ),
                        ),
                        // child: CustomButton(
                        //   buttonText: getTranslated("place_order", context),
                        //   btnColor: Colors.white,
                        //   onTap: () {
                        //     if (mobilFeedProvider.cartItems.isNotEmpty &&
                        //         customerName != null &&
                        //         customerID != null &&
                        //         sectionSelect != null) {
                        //       mobilFeedProvider.addOrderProcess(
                        //         mobilFeedProvider.cartItems.values.toList(),
                        //         customerName,
                        //         getText(),
                        //         customerID,
                        //         comment: commentController.text,

                        //         // invNum: (Random().nextInt(900000)).toString(),
                        //         total: mobilFeedProvider.totalAmountOrder
                        //             .toString(),
                        //       );

                        //       for (int i = 0;
                        //           i <= mobilFeedProvider.cartItems.length;
                        //           i++) {
                        //         newqtyController![i].clear();
                        //       }
                        //       drpDownSelectedItem.clear();

                        //       Navigator.push(
                        //           context,
                        //           MaterialPageRoute(
                        //               builder: (context) => OrderScreen(
                        //                     isOrderScreen: true,
                        //                     section: sectionSelect,
                        //                   )));
                        //       String jsString =
                        //           jsonEncode(mobilFeedProvider.getOrders);
                        //       print("Good string $jsString");
                        //       mobilFeedProvider.clearWholeCart();

                        //       // newqtyController!.clear();
                        //     } else {
                        //       showCustomSnackBar(
                        //           'Add data to complete Operation', context);
                        //     }
                        //   },
                        // ),
                      ),

                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              );
            },
          )),
    );
  }

  // Widget buildProdDialog(
  //   BuildContext context,
  //   MobilFeedProvider mobilFeedProvider,
  // ) {
  //   return AlertDialog(
  //     alignment: Alignment.center,

  //     title: const Padding(
  //       padding: EdgeInsets.all(8.0),
  //       child: Text(
  //         'Products List',
  //         textAlign: TextAlign.center,
  //       ),
  //     ),
  //     actions: [
  //       const Divider(
  //         thickness: 2,
  //       ),
  //       Center(
  //         child: CloseButton(
  //           onPressed: () {
  //             Navigator.pop(context);
  //           },
  //         ),
  //       ),
  //     ],
  //     insetPadding: EdgeInsets.zero,
  //     contentPadding: EdgeInsets.zero,

  //     // contentPadding: EdgeInsets.all(45.0),
  //     shape: const RoundedRectangleBorder(
  //         borderRadius: BorderRadius.all(Radius.circular(18.0))),
  //     content: Builder(
  //       builder: (context) {
  //         var height = MediaQuery.of(context).size.height;
  //         var width = MediaQuery.of(context).size.width;
  //         return NewProdDiagWidget(
  //           height: height,
  //           width: width - 4,
  //           prodSearchController: prodSrchContr,
  //         );
  //       },
  //     ),
  //   );
  // }

  buildCustomerListDialog() {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          alignment: Alignment.center,

          title: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Customer List',
                  textAlign: TextAlign.center,
                  style: chakraPetch.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return const AlertDialog(
                            content: Text('Hello'),
                          );
                        });
                  },
                  icon: const Icon(Icons.add),
                ),
                Consumer2<MobilFeedProvider, UserConfigurationProvider>(
                    builder: (context, mp, ap, child) {
                  return IconButton(
                      onPressed: () async {
                        String dir =
                            (await getExternalStorageDirectory())!.path;
                        var bytes = await customerListPdf(
                          PdfPageFormat.legal,
                          ap,
                        );
                        final file = File('$dir/customer_list.pdf');
                        await file.writeAsBytes(bytes);
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => PdfPreviewScreen(
                                path: '$dir/customer_list.pdf',
                                title: 'Customer List Pdf',
                                isResponsive: true,
                                file: file)));
                      },
                      icon: const Icon(Icons.picture_as_pdf));
                }),
              ],
            ),
          ),
          actions: [
            const Divider(
              thickness: 2,
            ),
            Center(
              child: CloseButton(
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ],
          insetPadding: EdgeInsets.zero,
          contentPadding: EdgeInsets.zero,

          // contentPadding: EdgeInsets.all(45.0),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(18.0))),
          content: Builder(
            builder: (context) {
              var height = MediaQuery.of(context).size.height;
              var width = MediaQuery.of(context).size.width;
              return SizedBox(
                  height: height / 2,
                  width: width,
                  child:
                      Consumer2<MobilFeedProvider, UserConfigurationProvider>(
                    builder: (context, mobilP, ap, child) => Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: TextField(
                            controller: searchController,
                            style: robotoRegular.copyWith(
                                color: Colors.black87, fontSize: 16),
                            decoration: InputDecoration(
                                hintText: 'Search Customer',
                                focusColor: Colors.green,
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 18, horizontal: 22),
                                suffixIcon: ap.isCustomerSearch
                                    ? IconButton(
                                        onPressed: () {
                                          searchController.text = '';
                                          ap.searchCustomer('');
                                        },
                                        icon: const Icon(
                                          Icons.close,
                                          color: Colors.red,
                                        ))
                                    : const Icon(
                                        Icons.search,
                                        color: Colors.black,
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
                                    borderSide: const BorderSide(
                                        width: 2, color: Color(0xFFFC6A57)))),
                            onChanged: (query) {
                              ap.searchCustomer(query);
                            },
                          ),
                          // child: CustomTextField(
                          //   hintText: 'Search',
                          //   isShowSuffixIcon: true,
                          //   controller: searchController,
                          //   suffixIconUrl: mobilP.isSearch ? Icons.close : Icons.search,
                          //   onSuffixTap: () {
                          //     if (mobilP.isSearch) {
                          //       searchController.clear();
                          //       mobilP.searchCustomer('');
                          //     }
                          //   },
                          //   isIcon: true,
                          //   onChanged: (query) {
                          //     mobilP.searchCustomer(query);
                          //   },
                          // ),
                        ),
                        !ap.isLoading
                            ? ap.customerList != null
                                ? ap.customerList!.isNotEmpty
                                    ? Expanded(
                                        child: Scrollbar(
                                          thumbVisibility: true,
                                          thickness: 10,
                                          radius: const Radius.circular(10),
                                          child: ListView.builder(
                                              itemCount:
                                                  ap.customerList!.length,
                                              padding: const EdgeInsets.all(
                                                Dimensions.PADDING_SIZE_DEFAULT,
                                              ),
                                              physics:
                                                  const BouncingScrollPhysics(),
                                              itemBuilder: (context, index) =>
                                                  InkWell(
                                                    onTap: () {
                                                      // print(ap.customerList![index].sirdesc);
                                                      // customerName = ap.customerList![index].sirdesc;
                                                      // customerID = ap.customerList![index].sircode;
                                                      // setState(() {
                                                      //   customerName == ap.customerList![index].sirdesc;
                                                      //   customerID == ap.customerList![index].sircode;
                                                      // });
                                                      // print("WORLD $customerName");
                                                      // print("customer work $customerID");
                                                      // mobilP.addProdtoCart(mobilP
                                                      //     .customerList![index]
                                                      //     .sirdesc!);
                                                      Navigator.pop(context);
                                                    },
                                                    child: Card(
                                                      elevation: 2,
                                                      child: ListTile(
                                                        leading:
                                                            const CircleAvatar(
                                                          backgroundColor:
                                                              Color.fromARGB(
                                                                  255,
                                                                  209,
                                                                  203,
                                                                  203),
                                                          child: Icon(
                                                            Icons.person,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                        title: Text(
                                                          '${ap.customerList![index].sirdesc}',
                                                          style: chakraPetch
                                                              .copyWith(
                                                            fontWeight:
                                                                FontWeight.w800,
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                        subtitle: Text(
                                                            'ID : ${ap.customerList![index].sircode}'),
                                                      ),
                                                    ),
                                                  )),
                                        ),
                                      )
                                    : Center(
                                        child: Container(
                                            margin:
                                                const EdgeInsets.only(top: 150),
                                            child: const Text(
                                              'No Data Found Please Check Your Internet Connection',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                              ),
                                            )))
                                : Expanded(child: EmployeeShimmer())
                            : SizedBox(
                                height: MediaQuery.of(context).size.height * .2,
                                child: Center(
                                    child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      ColorResources.getPrimary(context)),
                                )),
                              ),
                      ],
                    ),
                  ));
            },
          ),
        );
      },
    );
  }

  // Container titleContainer(
  //     BuildContext context, GlobalKey<ScaffoldState> _drawerKey,
  //     {double topSize = Dimensions.PADDING_SIZE_DEFAULT,
  //       double bottomSize = Dimensions.PADDING_SIZE_DEFAULT,
  //       double leftSize = Dimensions.PADDING_SIZE_DEFAULT,
  //       double rightSize = Dimensions.PADDING_SIZE_DEFAULT,
  //       bool isResponsive = false}) {
  //   return Container(
  //     decoration: BoxDecoration(
  //         color: Theme.of(context).primaryColor,
  //         borderRadius: BorderRadius.only(
  //             bottomLeft: Radius.circular(25),
  //             bottomRight: Radius.circular(25))),
  //     padding: EdgeInsets.only(
  //         left: leftSize, right: rightSize, top: topSize, bottom: bottomSize),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Expanded(
  //               child: Row(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   Image.asset(Images.app_logo,
  //                       width: isResponsive ? 70 : 50,
  //                       height: isResponsive ? 70 : 50,
  //                       fit: BoxFit.scaleDown,
  //                       color: Colors.white),
  //                   SizedBox(width: 10),
  //                   Expanded(
  //                     child: Column(
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: [
  //                         SizedBox(height: 12),
  //                         // Text(
  //                         //   'Good ${(DateTime.now().hour > 5 && DateTime.now().hour < 12) ? 'Morning' : (DateTime.now().hour >= 12 && DateTime.now().hour < 17) ? 'Afternoon' : 'Evening'}',
  //                         //   style: robotoRegular.copyWith(color: Colors.white, fontSize: isResponsive ? 18 : 14),
  //                         // ),
  //                         // SizedBox(height: 5),
  //                         Text('Bangladesh Export Processing Zones Authority',
  //                             style: robotoBold.copyWith(
  //                                 color: Colors.white,
  //                                 fontSize: isResponsive ? 18 : 14)),
  //
  //                         //Text('GM(MIS)-BEPZA H/O', style: titilliumRegular.copyWith(color: Colors.white)),
  //                       ],
  //                     ),
  //                   )
  //                 ],
  //               ),
  //             ),
  //             InkWell(
  //               onTap: () {
  //                 _drawerKey.currentState!.openEndDrawer();
  //               },
  //               child: Container(
  //                 width: isResponsive ? 50 : 40,
  //                 height: isResponsive ? 50 : 40,
  //                 alignment: Alignment.center,
  //                 padding: EdgeInsets.all(5),
  //                 decoration: BoxDecoration(
  //                     shape: BoxShape.circle,
  //                     border: Border.all(color: Colors.white)),
  //                 child: Icon(
  //                   Icons.menu,
  //                   color: Colors.white,
  //                   size: isResponsive ? 30 : 24,
  //                 ),
  //               ),
  //             )
  //           ],
  //         ),
  //         SizedBox(height: 10),
  //       ],
  //     ),
  //   );
  // }

  Future pickDateTime(BuildContext context) async {
    final date = await pickDate(context);
    if (date == null) return;

    // final time = await pickTime(context);
    // if (time == null) return;

    setState(() {
      _selectedDate = DateTime(
        date.year,
        date.month,
        date.day,
        // time.hour,
        // time.minute,
      );
    });
  }

  Future<DateTime?> pickDate(BuildContext context) async {
    final initialDate = DateTime.now();
    final newDate = await showDatePicker(
      context: context,
      builder: (context, child) {
        return Theme(
            data: ThemeData().copyWith(
                colorScheme: const ColorScheme.light(
              primary: Colors.green,
            )),
            child: child!);
      },
      initialDate: _selectedDate ?? initialDate,
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 10),
    );

    if (newDate == null) return null;

    return newDate;
  }

  Future<TimeOfDay?> pickTime(BuildContext context) async {
    // ignore: prefer_const_constructors
    final initialTime = TimeOfDay(hour: 9, minute: 0);
    final newTime = await showTimePicker(
      context: context,
      initialTime: _selectedDate != null
          ? TimeOfDay(hour: _selectedDate!.hour, minute: _selectedDate!.minute)
          : initialTime,
    );

    if (newTime == null) return null;

    return newTime;
  }

  List<DropdownMenuItem<String>> _dropDownItem() {
    List<String> ddI = ["CTN", "PCS"];
    return ddI
        .map((value) => DropdownMenuItem(
              value: value,
              child: Text(value),
            ))
        .toList();
  }
}

class EmployeeShimmer extends StatelessWidget {
  Widget titleWidget(
      {double left = 16,
      double right = 16,
      double top = 8,
      double bottom = 4}) {
    return Container(
      padding:
          EdgeInsets.only(left: left, top: top, bottom: bottom, right: right),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(flex: 2, child: Container(height: 23, color: Colors.white)),
          const SizedBox(width: 10),
          Expanded(flex: 3, child: Container(height: 23, color: Colors.white))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 15,
      shrinkWrap: true,
      padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        return Container(
          height: 200,
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey[300]!, blurRadius: 10, spreadRadius: 1)
              ]),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            enabled:
                Provider.of<MobilFeedProvider>(context).checkRetItem == null,
            child: Column(
              children: [
                titleWidget(),
                titleWidget(),
                titleWidget(),
              ],
            ),
          ),
        );
      },
    );
  }
}

class CartTile extends StatefulWidget {
  final int index;
  final MobilFeedProvider mobilFeedProvider;
  final List<TextEditingController>? newqtyController;
  final List<String>? drpDownSelectedItem;
  // final List<DropdownMenuItem<String>> fn;

  const CartTile({
    Key? key,
    required this.index,
    required this.mobilFeedProvider,
    this.newqtyController,
    this.drpDownSelectedItem,
    // required this.fn,
  }) : super(key: key);

  @override
  State<CartTile> createState() => _CartTileState();
}

class _CartTileState extends State<CartTile> {
  // List<String> drpDownSelectedItem = <String>[];

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 2,
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(style: BorderStyle.solid, color: Colors.grey),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: Text(
                        'Cart Item ${widget.index + 1}',
                        textAlign: TextAlign.center,
                        style: chakraPetch.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Provider.of<ThemeProvider>(context).darkTheme
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: InkWell(
                      onTap: () {
                        widget.mobilFeedProvider.removeItemFromCart(
                          widget.mobilFeedProvider.cartItems.values
                              .toList()[widget.index]
                              .rsircode!,
                          // mobilFeedProvider.cartItems.values.toList()[index].id!,
                        );
                        widget.newqtyController!.removeAt(widget.index);
                        widget.drpDownSelectedItem!.removeAt(widget.index);
                        // drpDownSelectedItem[index] ='PCS';

                        //newqtyController![index].clear();
                      },
                      child: CircleAvatar(
                        backgroundColor: Colors.red.shade400,
                        radius: 8,
                        child: const Icon(
                          Icons.clear,
                          size: 15,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),
            // SizedBox(
            //   height: 5,
            // ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0, bottom: 8),
                child: Text(
                  '${widget.mobilFeedProvider.cartItems.values.toList()[widget.index].sirdesc}',
                  // '${mobilFeedProvider.cartItems.values.toList()[index].title}',
                  style: chakraPetch.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: Provider.of<ThemeProvider>(context).darkTheme
                        ? Colors.lightGreenAccent
                        : const Color(0xE2076515),
                    //color: Colors.white,
                  ),
                ),
              ),
            ),

            // SizedBox(
            //   height: 5,
            // ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 16.0,
                ),
                child: Row(
                  //mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Enter Unit',
                          style: chakraPetch.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                            // color: Colors.white,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            // width: 70,
                            // height: 35,
                            decoration: BoxDecoration(
                                color: ColorResources.getHomeBg(context),
                                borderRadius: BorderRadius.circular(5),
                                border:
                                    Border.all(color: Colors.white, width: 1)),
                            child: DropdownButton(
                              value:
                                  widget.drpDownSelectedItem![widget.index],
                              underline: Container(),
                              style: TextStyle(
                                  color: ColorResources.getTextBg(context),
                                  fontWeight: FontWeight.w500),
                              items: ["CTN", "PCS"]
                                  .map((value) => DropdownMenuItem(
                                        value: value,
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 5),
                                          child: Text(value),
                                        ),
                                      ))
                                  .toList(),
                              onChanged: (String? value) {
                                setState(() {
                                  widget.drpDownSelectedItem![widget.index] =
                                      value!;
                                  // selectedDropDownBtn = value;
                                });

                                // debugPrint('Hellow dropdown ${selectedDropDownBtn}');
                                widget.newqtyController![widget.index].text
                                        .isNotEmpty
                                    ? widget.mobilFeedProvider.addToCart(
                                        prodId: widget.mobilFeedProvider
                                            .cartItems.values
                                            .toList()[widget.index]
                                            .rsircode!,
                                        title: widget.mobilFeedProvider
                                            .cartItems.values
                                            .toList()[widget.index]
                                            .sirdesc!,
                                        qty:
                                            widget.newqtyController?[widget.index].text
                                                    .toDouble() ??
                                                1,
                                        // unit: value,
                                        unit: widget.drpDownSelectedItem![
                                            widget.index],
                                        price: widget.mobilFeedProvider
                                            .cartItems.values
                                            .toList()[widget.index]
                                            .itmrat!,
                                        unitconv: widget.mobilFeedProvider
                                            .cartItems.values
                                            .toList()[widget.index]
                                            .siruconf,
                                        batchno: widget.mobilFeedProvider
                                            .cartItems.values
                                            .toList()[widget.index]
                                            .batchref1!)
                                    : widget.mobilFeedProvider.addToCart(
                                        prodId: widget.mobilFeedProvider
                                            .cartItems.values
                                            .toList()[widget.index]
                                            .rsircode!,
                                        title: widget.mobilFeedProvider
                                            .cartItems.values
                                            .toList()[widget.index]
                                            .sirdesc!,
                                        qty: 1,
                                        // unit: value,
                                        unit: value,
                                        price: widget.mobilFeedProvider
                                            .cartItems.values
                                            .toList()[widget.index]
                                            .itmrat!,
                                        unitconv: widget.mobilFeedProvider
                                            .cartItems.values
                                            .toList()[widget.index]
                                            .siruconf,
                                        batchno: widget.mobilFeedProvider
                                            .cartItems.values
                                            .toList()[widget.index]
                                            .batchref1!,
                                      );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),

                    // newqtyController![index].text.isEmpty
                    //     ? SizedBox.shrink()
                    //     :
                    Flexible(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          //  mainAxisAlignment:MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              'Quantity : ',

                              style: chakraPetch.copyWith(
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                                // color: Colors.white,
                              ),

                              //'Quantity : ${_cartController.text} $_dropDownValue',
                            ),
                            Flexible(
                              child: Text(
                                widget.newqtyController![widget.index].text
                                        .isEmpty
                                    ? '1 ${widget.drpDownSelectedItem![widget.index]}'
                                    : '${widget.newqtyController![widget.index].text} ${widget.drpDownSelectedItem![widget.index]}',
                                style: robotoRegular.copyWith(fontSize: 14),
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
            Padding(
              padding: const EdgeInsets.only(left: 8.0, bottom: 3),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Enter Quantity : ',
                      style: chakraPetch.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        // color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 120,
                    height: 35,
                    child: TextFormField(
                      controller: widget.newqtyController?[widget.index],
                      inputFormatters: [LengthLimitingTextInputFormatter(5)],
                      //autovalidateMode: AutovalidateMode.onUserInteraction,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      maxLines: 1,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(5.0, 1.0, 5.0, 1.0),
                        isDense: true,
                        border: OutlineInputBorder(),
                        labelText: 'Quantity',
                        labelStyle: TextStyle(fontSize: 10),
                        suffixIcon: Icon(
                          Icons.production_quantity_limits,
                        ),
                      ),

                      // onChanged: (value){
                      //   _cartController.text  = value;
                      //     cartP.addToCart(widget.prodId, cartAttr.title!,
                      //         qty: cartP.setname(  _cartController.text).toDouble(), unit: _dropDownValue);
                      // },
                      onChanged: (value) {
                        widget.mobilFeedProvider.addToCart(
                          prodId: widget.mobilFeedProvider.cartItems.values
                              .toList()[widget.index]
                              .rsircode!,
                          title: widget.mobilFeedProvider.cartItems.values
                              .toList()[widget.index]
                              .sirdesc!,
                          qty: widget.newqtyController?[widget.index].text
                              .toDouble(),
                          unit: widget.drpDownSelectedItem![widget.index],
                          price: widget.mobilFeedProvider.cartItems.values
                              .toList()[widget.index]
                              .itmrat!,
                          unitconv: widget.mobilFeedProvider.cartItems.values
                              .toList()[widget.index]
                              .siruconf,
                          batchno: widget.mobilFeedProvider.cartItems.values
                              .toList()[widget.index]
                              .batchref1!,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 8,
            ),

            // SizedBox(
            //   height: 5,
            // ),
            // Divider(),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, bottom: 18),
              child: Row(
                children: [
                  widget.newqtyController![widget.index].text.isNotEmpty
                      ? Flexible(
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(
                                  'Price : ',
                                  style: chakraPetch.copyWith(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                    // color: Colors.white,
                                  ),
                                ),
                              ),
                              Flexible(
                                child: Text(
                                  '${widget.drpDownSelectedItem![widget.index] == 'CTN' ? (widget.newqtyController![widget.index].text.toDouble() * widget.mobilFeedProvider.cartItems.values.toList()[widget.index].itmrat!.toDouble() * widget.mobilFeedProvider.cartItems.values.toList()[widget.index].siruconf!.toDouble()) : (widget.newqtyController![widget.index].text.toDouble() * widget.mobilFeedProvider.cartItems.values.toList()[widget.index].itmrat!)} Taka',
                                  // '${drpDownSelectedItem[index] == 'CTN' ? (newqtyController![index].text.toDouble() * mobilFeedProvider.cartItems.values.toList()[index].price!.toDouble() * mobilFeedProvider.cartItems.values.toList()[index].unitconv3!.toDouble()) : (newqtyController![index].text.toDouble() * mobilFeedProvider.cartItems.values.toList()[index].price!)} Taka',
                                  style: chakraPetch.copyWith(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : Flexible(
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(
                                  'Price : ',
                                  style: chakraPetch.copyWith(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                    // color: Colors.white,
                                  ),
                                ),
                              ),
                              Flexible(
                                child: Text(
                                  '${widget.drpDownSelectedItem![widget.index] == 'CTN' ? (widget.mobilFeedProvider.cartItems.values.toList()[widget.index].itmrat!.toDouble() * widget.mobilFeedProvider.cartItems.values.toList()[widget.index].siruconf!.toDouble()) : widget.mobilFeedProvider.cartItems.values.toList()[widget.index].itmrat!} Taka',
                                  // '${drpDownSelectedItem[index] == 'CTN' ? (mobilFeedProvider.cartItems.values.toList()[index].price!.toDouble() * mobilFeedProvider.cartItems.values.toList()[index].unitconv3!.toDouble()) : mobilFeedProvider.cartItems.values.toList()[index].price!} Taka',
                                  style: chakraPetch.copyWith(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                  const SizedBox(height: 20, child: VerticalDivider()),
                  // SizedBox(
                  //   width: 50,
                  // ),
                  widget.drpDownSelectedItem![widget.index] == 'CTN'
                      ? Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Row(
                              children: [
                                widget.newqtyController![widget.index].text
                                        .isEmpty
                                    ? Text(
                                        ' 1 CTN = ',
                                        style: chakraPetch.copyWith(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      )
                                    : Text(
                                        '${widget.newqtyController![widget.index].text} CTN = ',
                                        style: chakraPetch.copyWith(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                widget.newqtyController![widget.index].text
                                        .isEmpty
                                    ? Flexible(
                                        child: Text(
                                          '${widget.mobilFeedProvider.cartItems.values.toList()[widget.index].siruconf} PCS',
                                          style: chakraPetch.copyWith(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      )
                                    : Flexible(
                                        child: Text(
                                          '${(widget.newqtyController![widget.index].text.toDouble() * widget.mobilFeedProvider.cartItems.values.toList()[widget.index].siruconf!.toDouble())} PCS',
                                          style: chakraPetch.copyWith(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                              ],
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
