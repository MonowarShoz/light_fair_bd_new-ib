import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../provider/auth_provider.dart';
import '../../../provider/mobil_feed_provider.dart';
import '../../../util/color_resources.dart';
import '../../../util/dimensions.dart';
import '../../../util/theme/custom_themes.dart';
import '../order_process/new_order_screen.dart';

class CustomerDialog extends StatefulWidget {
  const CustomerDialog({
    Key? key,
  }) : super(key: key);

  @override
  State<CustomerDialog> createState() => _CustomerDialogState();
}

class _CustomerDialogState extends State<CustomerDialog> {
  final searchController = TextEditingController();
  bool isMode = false;

  @override
  Widget build(BuildContext context) {
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
              style: poppinRegular.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            Row(
              children: [
                // IconButton(
                //   onPressed: () {
                //     //Navigator.pop(context);
                //     showDialog(
                //       context: context,
                //       builder: (context) {
                //         return CustomerAddScreen();
                //       },
                //     );
                //   },
                //   icon: Icon(Icons.add),
                // ),
                // Consumer2<MobilFeedProvider, AuthProvider>(builder: (context, mp, ap, child) {
                //   return IconButton(
                //       onPressed: () async {
                //         String dir = (await getExternalStorageDirectory())!.path;
                //         var bytes = await customerListPdf(
                //           PdfPageFormat.legal,
                //           ap,
                //         );
                //         final file = File('$dir/customer_list.pdf');
                //         await file.writeAsBytes(bytes);
                //         Navigator.of(context).push(MaterialPageRoute(
                //             builder: (_) => PdfPreviewScreen(
                //                 path: '$dir/customer_list.pdf', title: 'Customer List Pdf', isResponsive: true, file: file)));
                //       },
                //       icon: Icon(Icons.picture_as_pdf));
                // }),
              ],
            ),
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
          return Container(
              height: height / 2,
              width: width,
              child: Consumer2<MobilFeedProvider, UserConfigurationProvider>(
                builder: (context, mobilP, ap, child) => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: TextField(
                        controller: searchController,
                        style: poppinRegular.copyWith(
                            color: Colors.black87, fontSize: 16),
                        decoration: InputDecoration(
                            hintText: 'Search Customer',
                            focusColor: Colors.green,
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 18, horizontal: 22),
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
                                borderSide: BorderSide(
                                    width: 2, color: Color(0xFFFC6A57)))),
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
                                        itemBuilder: (context, index) =>
                                            InkWell(
                                          onTap: () {
                                            ap.selectCustomer(
                                              customerName: ap.customerList![index].sirdesc!,
                                              customerID: ap
                                                  .customerList![index]
                                                  .sircode!,
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
                                          child: Padding(
                                            padding: const EdgeInsets.all(4),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color: ColorResources.getHomeBg(context),
                                                  border: Border.all(
                                                      color: Colors.grey),
                                                  borderRadius:
                                                      BorderRadius.circular(4)),
                                              child: ListTile(
                                                // leading: const CircleAvatar(
                                                //   child: Icon(
                                                //     Icons.person,
                                                //     color: Colors.black,
                                                //   ),
                                                //   backgroundColor:
                                                //       const Color.fromARGB(
                                                //           255, 209, 203, 203),
                                                // ),
                                                title: Text(
                                                  '${ap.customerList![index].sirdesc}',
                                                  style: poppinRegular.copyWith(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 12,
                                                    color:ColorResources.getTextBg(context)
                                                  ),
                                                ),
                                                subtitle: Text(
                                                  'ID : ${ap.customerList![index].sircode}',
                                                  style: poppinRegular.copyWith(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 14,
                                                    color:ColorResources.getTextBg(context)
                                                  ),
                                                ),
                                              ),
                                            ),
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
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    ColorResources.getPrimary(context)),
                              ),
                            ),
                          ),
                  ],
                ),
              ));
        },
      ),
    );
  }
}
