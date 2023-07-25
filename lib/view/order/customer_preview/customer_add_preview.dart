import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:light_fair_bd_new/provider/auth_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:provider/provider.dart';

import '../../../provider/mobil_feed_provider.dart';
import '../../../util/color_resources.dart';
import '../../../util/dimensions.dart';
import '../../../util/theme/custom_themes.dart';
import '../../product_feed/customer_list_pdf.dart';
import '../order_process/new_order_screen.dart';
import '../pdf_preview_screen.dart';
import 'package:path_provider/path_provider.dart';

class CustomerListScreen extends StatefulWidget {
  const CustomerListScreen({Key? key}) : super(key: key);

  @override
  State<CustomerListScreen> createState() => _CustomerListScreenState();
}

class _CustomerListScreenState extends State<CustomerListScreen> {
  final searchController = TextEditingController();

  var _selectedMainHead;

  bool _isdrpval = false;

  var _selectedItemName;

  var _selectedItemCode;
  @override
  void initState() {
    super.initState();
    //  _getlist();
    //getcust();
  }

  getcust() async {
    await Provider.of<UserConfigurationProvider>(context, listen: false).initializeCustomerList();
  }

  _getlist() async {
    await Provider.of<UserConfigurationProvider>(context, listen: false).customerProcess();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Customer List',
            style: robotoBold.copyWith(fontSize: 16, color: Colors.black),
          ),
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
          actions: [
            Consumer2<MobilFeedProvider, UserConfigurationProvider>(builder: (context, mp, ap, child) {
              return IconButton(
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
                  icon: Icon(Icons.picture_as_pdf));
            }),
          ],
        ),
        body: Consumer2<MobilFeedProvider, UserConfigurationProvider>(
          builder: (context, mobilP, ap, child) => SizedBox(
            height: Dimensions.fullHeight(context),
            width: Dimensions.fullWidth(context),
            child: Column(
              //   mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: TextField(
                    controller: searchController,
                    style: robotoRegular.copyWith(color: Colors.black87, fontSize: 16),
                    decoration: InputDecoration(
                        hintText: 'Search Customer',
                        focusColor: Colors.green,
                        contentPadding: EdgeInsets.symmetric(vertical: 18, horizontal: 22),
                        suffixIcon: ap.isCustomerSearch
                            ? IconButton(
                                onPressed: () {
                                  searchController.text = '';
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
                            ? Flexible(
                                child: ListView.builder(
                                  itemCount: ap.customerList!.length,
                                  padding: const EdgeInsets.all(
                                    Dimensions.PADDING_SIZE_DEFAULT,
                                  ),
                                  // physics: const BouncingScrollPhysics(),
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
                                          child: Icon(
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
                                  ),
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
                            valueColor: AlwaysStoppedAnimation<Color>(ColorResources.getPrimary(context)),
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ));
  }
}
