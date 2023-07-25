import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:light_fair_bd_new/util/dimensions.dart';
import 'package:pdf/pdf.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';

import '../../../provider/auth_provider.dart';
import '../../../provider/mobil_feed_provider.dart';
import '../../../util/color_resources.dart';
import '../../../util/theme/custom_themes.dart';
import '../../product_feed/customer_list_pdf.dart';
import '../order_process/new_order_screen.dart';
import '../pdf_preview_screen.dart';
import 'package:accordion/accordion.dart';

class CustomerMenuScreen extends StatefulWidget {
  const CustomerMenuScreen({Key? key}) : super(key: key);

  @override
  State<CustomerMenuScreen> createState() => _CustomerMenuScreenState();
}

class _CustomerMenuScreenState extends State<CustomerMenuScreen> {
  final _searchController = TextEditingController();
  final custNameController = TextEditingController();
  final custTypeController = TextEditingController();
  final custdescController = TextEditingController();
  bool isExpand = false;

  getcust() async {
    await Provider.of<UserConfigurationProvider>(context, listen: false).initializeCustomerList();
  }

  @override
  void initState() {
    getcust();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<MobilFeedProvider, UserConfigurationProvider>(builder: (context, mp, ap, child) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            'Customer',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          leading: CupertinoNavigationBarBackButton(
            color: Colors.black,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: [
            IconButton(
                onPressed: () async {
                  String dir = (await getExternalStorageDirectory())!.path;
                  var bytes = await customerListPdf(
                    PdfPageFormat.legal,
                    ap,
                  );
                  final file = File('$dir/customer_list.pdf');
                  await file.writeAsBytes(bytes);
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => PdfPreviewScreen(
                          path: '$dir/customer_list.pdf', title: 'Customer List Pdf', isResponsive: true, file: file)));
                },
                icon: Icon(
                  Icons.picture_as_pdf,
                  color: Colors.black,
                )),
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.add,
                color: Colors.black,
              ),
            ),
          ],
        ),
        floatingActionButton: SizedBox(
          height: 80,
          child: FloatingActionButton(
            elevation: 4,
            isExtended: true,
            onPressed: () {
              showModalBottomSheet(
                  isScrollControlled: true,
                  context: context,
                  builder: (context) {
                    return Container(
                      height: Dimensions.fullHeight(context),
                      color: Colors.white,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'ADD CUSTOMER DATA',
                              style: robotoBold.copyWith(fontSize: 18),
                            ),
                          ),

                          InkWell(
                            onTap: () {
                              ap.getSubHead();
                              // setState(() {
                              //   isExpand = !isExpand;
                              // });
                            },
                            child: Card(
                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(color: Colors.black26),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('CUSTOMER CORPORATE'),
                                      Icon(
                                        ap.isExpanded ? Icons.arrow_circle_down_outlined : Icons.arrow_circle_up_outlined,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),

                          ap.isExpanded
                              ? Container(
                                  height: 40,
                                  width: double.infinity,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: 5,
                                    itemBuilder: (context, index) {
                                      return Card(
                                        color: Colors.black,
                                        child: Center(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              'Niloy Motors Dealer DEPo $index',
                                              style: TextStyle(color: Colors.white, fontSize: 13),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                )
                              : SizedBox.shrink(),
                          Card(
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(color: Colors.black26),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('CUSTOMER CORPORATE'),
                                    Icon(
                                      Icons.arrow_circle_down_outlined,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          // Padding(
                          //   padding: const EdgeInsets.all(8.0),
                          //   child: Card(
                          //     child: Container(
                          //       decoration: BoxDecoration(
                          //         border: Border.all(
                          //           color: Colors.black,
                          //           // color: Colors.green,
                          //         ),
                          //         borderRadius: BorderRadius.circular(5),
                          //       ),
                          //       child: ExpansionTile(
                          //         title: Text('Customer General TRADING'),
                          //         //backgroundColor: Colors.blue,
                          //         children: [
                          //           Container(
                          //             decoration: BoxDecoration(
                          //               border: Border.all(
                          //                 color: Colors.black,
                          //                 // color: Colors.green,
                          //               ),
                          //               borderRadius: BorderRadius.circular(5),
                          //             ),
                          //             child: ExpansionTile(
                          //               expandedAlignment: Alignment.centerLeft,
                          //               childrenPadding: EdgeInsets.only(left: 10),
                          //               title: Text('CUSTOMER CORPORATE'),
                          //               children: [
                          //                 ListTile(
                          //                   title: Text('CUSTOMER CORPORATE'),
                          //                 ),
                          //                 ListTile(
                          //                   title: Text('CUSTOMER CORPORATE'),
                          //                 ),
                          //                 ListTile(
                          //                   title: Text('CUSTOMER CORPORATE'),
                          //                 ),
                          //                 ListTile(
                          //                   title: Text('CUSTOMER CORPORATE'),
                          //                 ),
                          //                 ListTile(
                          //                   title: Text('CUSTOMER CORPORATE'),
                          //                 ),
                          //               ],
                          //             ),
                          //           ),
                          //           ExpansionTile(
                          //             title: Text('CUSTOMER GENERAL'),
                          //           ),
                          //         ],
                          //       ),
                          //     ),
                          //   ),
                          // ),

                          // Accordion(
                          //   children: [
                          //     AccordionSection(
                          //       isOpen: true,
                          //       leftIcon: const Icon(Icons.insights_rounded, color: Colors.white),
                          //       headerBackgroundColor: Colors.black,
                          //       headerBackgroundColorOpened: Colors.red,
                          //       header: Text('Introduction',
                          //           style: TextStyle(color: Color(0xff999999), fontSize: 14, fontWeight: FontWeight.w700)),
                          //       content: Text('_loremIpsum',
                          //           style: TextStyle(color: Color(0xff999999), fontSize: 14, fontWeight: FontWeight.w700)),
                          //       contentHorizontalPadding: 20,
                          //       contentBorderWidth: 1,
                          //     ),
                          //     AccordionSection(
                          //       isOpen: true,
                          //       leftIcon: const Icon(Icons.insights_rounded, color: Colors.white),
                          //       headerBackgroundColor: Colors.black,
                          //       headerBackgroundColorOpened: Colors.red,
                          //       header: Text('Introduction',
                          //           style: TextStyle(color: Color(0xff999999), fontSize: 14, fontWeight: FontWeight.w700)),
                          //       content: Text('_loremIpsum',
                          //           style: TextStyle(color: Color(0xff999999), fontSize: 14, fontWeight: FontWeight.w700)),
                          //       contentHorizontalPadding: 20,
                          //       contentBorderWidth: 1,
                          //     ),
                          //     // onOpenSection: () => print('onOpenSection ...'),
                          //     // onCloseSection: () => print('onCloseSection ...'),)
                          //   ],
                          // ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: TextField(
                              controller: custNameController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Enter Customer Name',
                                prefixIcon: Icon(Icons.person_add),
                                focusColor: Colors.green,
                                contentPadding: EdgeInsets.symmetric(vertical: 18, horizontal: 22),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    width: 2.0,
                                    color: Colors.green,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: BorderSide(width: 2, color: Color(0xFFFC6A57))),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              controller: custdescController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Enter Customer Phone/Bar code',
                                prefixIcon: Icon(FontAwesomeIcons.phone),
                                focusColor: Colors.green,
                                contentPadding: EdgeInsets.symmetric(vertical: 18, horizontal: 22),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    width: 2.0,
                                    color: Colors.green,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: BorderSide(width: 2, color: Color(0xFFFC6A57))),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              controller: custTypeController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Enter Customer Type ',
                                prefixIcon: Icon(FontAwesomeIcons.personCircleQuestion),
                                focusColor: Colors.green,
                                contentPadding: EdgeInsets.symmetric(vertical: 18, horizontal: 22),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    width: 2.0,
                                    color: Colors.green,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: BorderSide(width: 2, color: Color(0xFFFC6A57))),
                              ),
                            ),
                          ),
                          Consumer<UserConfigurationProvider>(builder: (context, ap, child) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                width: Dimensions.fullWidth(context) / .2,
                                child: CupertinoButton(
                                  onPressed: () {
                                    int a = 555100205;
                                    ap.addcustomer(
                                      name: custNameController.text,
                                      desc: custdescController.text,
                                      type: custTypeController.text,
                                    );
                                    ap.addCustomerDataProcess(
                                      custName: custNameController.text,
                                      custID: a.toString().replaceRange(9, null, '001'),
                                      hcCode: ap.jwtTokenModel!.hccode,
                                      sessionID: ap.jwtTokenModel!.sessionid!,
                                      deviceID: ap.deviceName,
                                      typeDes: custdescController.text,
                                      custType: custTypeController.text,
                                      userName: ap.jwtTokenModel!.hcname,
                                      //subHeadCode: a.toString(),
                                    );
                                    // for (var i = 0; i < ap.addedCustomer!.length; i++) {
                                    //   print('ola new cust ${ap.addedCustomer![i].sirdesc}');
                                    // }
                                    Navigator.pop(context);
                                  },
                                  color: Colors.green,
                                  child: Text('ENTER'),
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                    );
                  });
            },
            child: Icon(Icons.add),
            backgroundColor: Colors.green,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        body: Container(
            height: Dimensions.fullHeight(context),
            width: Dimensions.fullWidth(context),
            child: Consumer2<MobilFeedProvider, UserConfigurationProvider>(
              builder: (context, mobilP, ap, child) => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: TextField(
                      controller: _searchController,
                      style: robotoRegular.copyWith(color: Colors.black87, fontSize: 16),
                      decoration: InputDecoration(
                          hintText: 'Search Customer',
                          focusColor: Colors.green,
                          contentPadding: EdgeInsets.symmetric(vertical: 18, horizontal: 22),
                          suffixIcon: ap.isCustomerSearch
                              ? IconButton(
                                  onPressed: () {
                                    _searchController.text = '';
                                    ap.searchCustomer('');
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
                              color: Colors.green,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(width: 2, color: Color(0xFFFC6A57)))),
                      onChanged: (query) {
                        ap.searchCustomer(query);
                      },
                    ),
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
                                        itemCount: ap.customerList!.length,
                                        padding: const EdgeInsets.all(
                                          Dimensions.PADDING_SIZE_DEFAULT,
                                        ),
                                        physics: const BouncingScrollPhysics(),
                                        itemBuilder: (context, index) => InkWell(
                                              onTap: () {
                                                ap.selectCustomer(
                                                  customerName: ap.customerList![index].sirdesc!,
                                                  customerID: ap.customerList![index].sircode!,
                                                );
                                                // print(ap.customerList![index].sirdesc);
                                                // widget.customerName = ap.customerList![index].sirdesc!;
                                                // widget.customerID = ap.customerList![index].sircode!;
                                                // // setState(() {
                                                // //   customerName == ap.customerList![index].sirdesc;
                                                // //   customerID == ap.customerList![index].sircode;
                                                // // });
                                                // print("WORLD ${widget.customerName}");
                                                // print("customer work ${widget.customerName}");
                                                // // mobilP.addProdtoCart(mobilP
                                                // //     .customerList![index]
                                                // //     .sirdesc!);
                                                Navigator.pop(context);
                                              },
                                              child: Card(
                                                elevation: 2,
                                                child: ListTile(
                                                  leading: const CircleAvatar(
                                                    child: const Icon(
                                                      Icons.person,
                                                      color: Colors.black,
                                                    ),
                                                    backgroundColor: const Color.fromARGB(255, 209, 203, 203),
                                                  ),
                                                  title: Text(
                                                    '${ap.customerList![index].sirdesc}',
                                                    style: chakraPetch.copyWith(
                                                      fontWeight: FontWeight.w800,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                  subtitle: Text('ID : ${ap.customerList![index].sircode}'),
                                                ),
                                              ),
                                            )),
                                  ),
                                )
                              : Center(
                                  child: Container(
                                      margin: const EdgeInsets.only(top: 150),
                                      child: const Text(
                                        'No Data Found or Please Check Your Internet Connection',
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                        ),
                                      )))
                          : Expanded(child: EmployeeShimmer())
                      : SizedBox(
                          height: MediaQuery.of(context).size.height * .2,
                          child: Center(
                            child: CircularProgressIndicator(
                              valueColor: new AlwaysStoppedAnimation<Color>(ColorResources.getPrimary(context)),
                            ),
                          ),
                        ),
                ],
              ),
            )),
      );
    });
  }
}
