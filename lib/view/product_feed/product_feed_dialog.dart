import 'package:badges/badges.dart' as bdge;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:intl/intl.dart';
import 'package:light_fair_bd_new/util/color_resources.dart';
import 'package:light_fair_bd_new/util/theme/custom_themes.dart';
import 'package:light_fair_bd_new/view/order/pdf_preview_screen.dart';
import 'package:light_fair_bd_new/view/product_feed/product_list_pdf.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:path_provider/path_provider.dart';
import '../../provider/mobil_feed_provider.dart';
import '../../provider/theme_provider.dart';
import '../../util/custom_text_field.dart';
import '../../util/dimensions.dart';
import '../order/order_process/new_order_screen.dart';
import 'product_item.dart';

class NewProdDiagWidget extends StatefulWidget {
  NewProdDiagWidget({
    Key? key,
    this.height,
    this.width,
    this.prodSearchController,
    required this.custId,
    this.isNewOrderScreen = true,
  }) : super(key: key);
  final bool isNewOrderScreen;
  final String? custId;
  final double? height;
  final double? width;
  TextEditingController? prodSearchController = TextEditingController();

  @override
  State<NewProdDiagWidget> createState() => _NewProdDiagWidgetState();
}

class _NewProdDiagWidgetState extends State<NewProdDiagWidget> {
  final searchProdController = TextEditingController();
  //final srch = TextEditingController();
  final scrContr = ScrollController();
  @override
  void initState() {
    getProd();
    super.initState();
  }

  getProd() async {
    await Provider.of<MobilFeedProvider>(context, listen: false)
        .postAccess(custId: widget.custId);
  }

  @override
  Widget build(BuildContext context) {
    // Provider.of<MobilFeedProvider>(context, listen: false)
    //     .postAccess(custId: widget.custId);
    return Scaffold(
      appBar: AppBar(
          iconTheme: IconThemeData(
              color: Provider.of<ThemeProvider>(context).darkTheme
                  ? Colors.white
                  : Colors.brown,
            ),
        backgroundColor: ColorResources.getHomeBg(context),
        
        title: Text(
          'Products List',
          style: poppinRegular.copyWith(
            fontWeight: FontWeight.w600,
            color: Provider.of<ThemeProvider>(context).darkTheme
                ? Colors.white
                : Colors.black,
          ),
        ),
        //iconTheme: const IconThemeData(color: Color.fromARGB(255, 15, 10, 15)),
        actions: [
          Consumer<MobilFeedProvider>(
            builder: (_, cart, ch) => Padding(
              padding: const EdgeInsets.only(right: 19.0, top: 9),
              child: bdge.Badge(
                position: bdge.BadgePosition.topEnd(
                  top: -5,
                ),
                badgeColor: Colors.green,
                animationType: bdge.BadgeAnimationType.slide,
                //toAnimate: false,
                badgeContent: Text(
                  cart.cartItems.length.toString(),
                  style: TextStyle(color: Colors.white),
                ),
                child: InkWell(
                    onTap: () {
                      widget.isNewOrderScreen
                          ? Navigator.pop(context)
                          : Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => NewOrderScreen(),
                              ));
                      //Navigator.pop(context);
                    },
                    onLongPress: () {
                      cart.clearWholeCart();
                    },
                    child: Icon(FontAwesomeIcons.cartShopping)),
                // child: IconButton(
                //   onPressed: (){
                //     Navigator.pop(context);
                //   },
                //   icon: Icon(FontAwesomeIcons.cartShopping,color: Colors.black,),
                // ),
              ),
            ),
          ),
          Consumer<MobilFeedProvider>(builder: (context, mp, child) {
            return IconButton(
                onPressed: () async {
                  String dir = (await getExternalStorageDirectory())!.path;
                  var bytes = await productListPdf(
                    PdfPageFormat.legal,
                    mp,
                  );
                  final file = File('$dir/product_list.pdf');
                  await file.writeAsBytes(bytes);
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => PdfPreviewScreen(
                          path: '$dir/product_list.pdf',
                          title: 'Product List Pdf',
                          isResponsive: true,
                          file: file)));
                },
                icon: Icon(Icons.picture_as_pdf));
          })
        ],
      ),
      body: SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Consumer<MobilFeedProvider>(builder: (context, mobilP, child) {
            return Column(
              //mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
                  child: TextField(
                    // controller: searchProdController,
                    controller: widget.prodSearchController,
                    style: robotoRegular.copyWith(
                        color: Colors.black87, fontSize: 16),
                    decoration: InputDecoration(
                        hintText: 'Search Products',
                        focusColor: Colors.green,
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 18, horizontal: 22),
                        suffixIcon: mobilP.isnsearch
                            ? IconButton(
                                onPressed: () {
                                  searchProdController.text = '';
                                  //  widget.prodSearchController!.text = '';
                                  mobilP.newSearchCheckProd('');
                                },
                                icon: Icon(
                                  Icons.close,
                                  color: Colors.red,
                                ))
                            : Icon(
                                Icons.search,
                                color: Colors.black,
                              ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(width: 1, color: Colors.green),
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(
                                width: 2, color: Color(0xFFFC6A57)))),
                    onChanged: (query) {
                      mobilP.newSearchCheckProd(query);
                    },
                  ),
                  // child: CustomTextField(
                  //   hintText: 'Search',
                  //   isShowSuffixIcon: true,
                  //   controller: widget.prodSearchController,
                  //   suffixIconUrl: mobilP.isnsearch ? Icons.close : Icons.search,
                  //   onSuffixTap: () {
                  //     if (mobilP.isnsearch) {
                  //       widget.prodSearchController!.clear();
                  //       mobilP.newSearchCheckProd('');
                  //     }
                  //   },
                  //   isIcon: true,
                  //   onChanged: (query) {
                  //     mobilP.newSearchCheckProd(query);
                  //   },
                  // ),
                ),
                // !mobilP.isLoading
                //     ? mobilP.retItemSale != null
                //         ? mobilP.retItemSale!.isNotEmpty
                !mobilP.isLoading
                    ? mobilP.checkRetItem != null
                        ? mobilP.checkRetItem!.isNotEmpty
                            ? Expanded(
                                child: Scrollbar(
                                  controller: scrContr,
                                  thumbVisibility: true,
                                  trackVisibility: true,
                                  thickness: 10,
                                  radius: const Radius.circular(10),
                                  child: ListView.builder(
                                      controller: scrContr,
                                      itemCount: mobilP.checkRetItem!.length,
                                      padding: const EdgeInsets.all(
                                        Dimensions.PADDING_SIZE_DEFAULT,
                                      ),
                                      physics: const BouncingScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        return ChangeNotifierProvider.value(
                                          // value: mobilP.retItemSale![index],
                                          value: mobilP.checkRetItem![index],
                                          child: ProductItem(
                                            index: index,
                                          ),
                                        );
                                      }),
                                ),
                              )
                            : Center(
                                child: const Text(
                                'No Data Found ',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 23,
                                  fontWeight: FontWeight.w500,
                                ),
                              ))
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
            );
          }

              // return Consumer<MobilFeedProvider>(
              //   builder: (context, mobilP, child) {
              //     return Column(
              //       mainAxisSize: MainAxisSize.min,
              //       children: [
              //         Padding(
              //           padding: const EdgeInsets.symmetric(horizontal: 15),
              //           child: CustomTextField(
              //             hintText: 'Search',
              //             isShowSuffixIcon: true,
              //             controller: searchController,
              //             suffixIconUrl: mobilP.isSearch ? Icons.close : Icons.search,
              //             onSuffixTap: () {
              //               if (mobilP.isSearch) {
              //                 searchController.text = '';
              //                 mobilP.searchProd('');
              //               }
              //             },
              //             isIcon: true,
              //             onChanged: (query) {
              //               mobilP.searchProd(query);
              //             },
              //           ),
              //         ),
              //         // !mobilP.isLoading
              //         //     ? mobilP.retItemSale != null
              //         //     ? mobilP.retItemSale!.isNotEmpty
              //         //     ?
              //         Expanded(
              //           child: Scrollbar(
              //             isAlwaysShown: true,
              //             showTrackOnHover: true,
              //             thickness: 10,
              //             radius: const Radius.circular(10),
              //             child: ListView.builder(
              //                 itemCount: mobilP.retItemSale!.length,
              //                 padding: const EdgeInsets.all(
              //                   Dimensions.PADDING_SIZE_DEFAULT,
              //                 ),
              //                 physics: const BouncingScrollPhysics(),
              //                 itemBuilder: (context, index) {
              //                   return ChangeNotifierProvider.value(
              //                     value: mobilP.retItemSale![index],
              //                     child: ProductItem(
              //                       index: index,
              //                     ),
              //                   );
              //                 }),
              //           ),
              //         )
              //         //   : Center(
              //         //   child: Container(
              //         //       margin: const EdgeInsets.only(top: 150),
              //         //       child: const Text(
              //         //         'No Data Found Please Check Your Internet Connection',
              //         //         textAlign: TextAlign.center,
              //         //         style: const TextStyle(
              //         //           fontWeight: FontWeight.w500,
              //         //         ),
              //         //       )))
              //         //   : Expanded(child: EmployeeShimmer())
              //         //   : SizedBox(
              //         // height: MediaQuery.of(context).size.height * .2,
              //         // child: Center(
              //         //     child: CircularProgressIndicator(
              //         //       valueColor: new AlwaysStoppedAnimation<Color>(ColorResources.getPrimary(context)),
              //         //     )),
              //         // ),
              //       ],
              //     );
              //   },
              // );

              ),
        ),
      ),
    );
  }
}
