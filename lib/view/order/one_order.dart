// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:light_fair_bd_new/provider/mobil_feed_provider.dart';
// import 'package:light_fair_bd_new/view/order/pdf_preview_screen.dart';
// import 'package:pdf/pdf.dart';
// import 'package:provider/provider.dart';
// import 'package:path_provider/path_provider.dart';

// import '../../data/datasource/model/order_process_model.dart';
// import '../../util/dimensions.dart';
// import '../../util/images.dart';
// import '../../util/theme/custom_themes.dart';
// import 'order_details/order_details_pdf.dart';
// import 'order_process/order_history_pdf.dart';

// class OrderHistory extends StatelessWidget {
//   const OrderHistory({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final ordHistory = Provider.of<MobilFeedProvider>(context);
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         iconTheme: const IconThemeData(
//           color: Color.fromARGB(255, 15, 10, 15),
//         ),
//         title: Text(
//           'Order History',
//           style: TextStyle(color: Colors.black),
//         ),
//         actions: [
//           // Consumer<MobilFeedProvider>(
//           //   builder: (context,mp,child) {
//           //     return IconButton(onPressed: ()async{
//           //       String dir = (await getExternalStorageDirectory())!.path;
//           //       var bytes = await orderHistoryPdf(
//           //         PdfPageFormat.legal,
//           //         mp,
//           //       );
//           //       final file = File('$dir/order_history.pdf');
//           //       await file.writeAsBytes(bytes);
//           //       Navigator.of(context).push(MaterialPageRoute(
//           //           builder: (_) => PdfPreviewScreen(
//           //               path: '$dir/order_history.pdf',
//           //               title: 'order_history Pdf',
//           //               isResponsive: true,
//           //               file: file)));


//           //     }, icon: Icon(Icons.picture_as_pdf),);
//           //   }
//           // )
//         ],
//       ),

//       body: ordHistory.orderHistory!.isEmpty
//           ? Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   SizedBox(
//                     height: 60,
//                     width: 60,
//                     child: Image.asset(
//                       Images.empord,
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Text(
//                       'No order yet',
//                       style: GoogleFonts.chakraPetch(
//                         fontWeight: FontWeight.w600,
//                         fontSize: 20,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             )
//           : ListView.builder(
//               itemCount: ordHistory.orderHistory!.length,
//               //itemCount: ordList!.length,
//               itemBuilder: ((context, index) {
//                 return OrderHistoryWidget(
//                   orderAttr: ordHistory.orderHistory![index],
//                 );
//               })),
//     );
//   }
// }

// class OrderHistoryWidget extends StatefulWidget {
//   final OrdersAttr orderAttr;

//   const OrderHistoryWidget({
//     Key? key,
//     required this.orderAttr,
//   }) : super(key: key);

//   @override
//   _OrderHistoryWidgetState createState() => _OrderHistoryWidgetState();
// }

// class _OrderHistoryWidgetState extends State<OrderHistoryWidget> {
//   @override
//   Widget build(BuildContext context) {
//     var _expand = false;
//     return SafeArea(
//       child: Column(
//         // mainAxisSize: MainAxisSize.max,
//         children: [
//           Card(
//             elevation: 4,
//             margin: const EdgeInsets.all(10),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Center(
//                     child: Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Text(
//                   'Date : ${widget.orderAttr.dateTime}',
//                         style: TextStyle(fontWeight: FontWeight.bold),
//                 ),
//                     )),
//                 invoiceTileWidget('customer id: ', widget.orderAttr.custId),
//                 invoiceTileWidget('Invoice number: ', widget.orderAttr.invNum),
//                 invoiceTileWidget('customer name: ', widget.orderAttr.custName),
//                 invoiceTileWidget('Total Price', '${widget.orderAttr.totalAmount} \u{09F3}'),

//                 SizedBox(
//                   height: 46,
//                   child: Card(
//                     color: Colors.grey.shade300,
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         const Padding(
//                           padding: EdgeInsets.all(8.0),
//                           child: Center(
//                             child: Text(
//                               'Ordered Products',
//                               style: TextStyle(
//                                 fontWeight: FontWeight.w500,
//                                 fontSize: 15,
//                               ),
//                             ),
//                           ),
//                         ),

//                       ],
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: SingleChildScrollView(child: _createDataTable()),
//                 ),
//                 widget.orderAttr.comment!.isEmpty ? SizedBox.shrink() : Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Row(
//                     children: [
//                       Text('Comment : ', style: TextStyle(fontWeight: FontWeight.bold),),
//                       Text('${widget.orderAttr.comment}')
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Row invoiceTileWidget(String? title, String? value) {
//     return Row(
//       //mainAxisAlignment: MainAxisAlignment.spaceAround,
//       children: [
//         Expanded(
//           flex: 7,
//           child: Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Text(
//               title!,
//               style: GoogleFonts.chakraPetch(
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ),
//         ),

//         Expanded(
//             flex: 2,
//             child: Text(
//               ' :',
//               style: TextStyle(fontWeight: FontWeight.bold),
//             )),
//         // Padding(
//         //   padding: EdgeInsets.only(left: 80),
//         //   child: Text(
//         //     ':',
//         //     style: TextStyle(fontWeight: FontWeight.bold),
//         //   ),
//         // ),
//         Expanded(
//           flex: 8,
//           child: Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Text(
//               value!,
//               style: GoogleFonts.chakraPetch(
//                 fontWeight: FontWeight.w500,
//                 fontSize: 13,
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   DataTable _createDataTable() {
//     return DataTable(
//       horizontalMargin: 9,
//       border: TableBorder.all(
//         style: BorderStyle.solid,
//         color: Colors.black26,
//       ),
//       // border: TableBorder.symmetric(
//       //   outside: BorderSide.none,
//       // ),
//       // decoration: BoxDecoration(
//       //   border: Border.all(),
//       // ),
//       columnSpacing: 15,
//       showBottomBorder: true,
//       columns: _createColumns(),
//       rows: _createRows(),
//     );
//   }

//   List<DataColumn> _createColumns() {
//     return [
//       DataColumn(
//         label: Text(
//           'Product Name',
//           textAlign: TextAlign.center,
//           style: GoogleFonts.chakraPetch(
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//       ),
//       DataColumn(
//           label: Text(
//         'Quantity',
//         style: GoogleFonts.chakraPetch(
//           fontWeight: FontWeight.w600,
//         ),
//       )),
//       DataColumn(
//         label: Text(
//           'Unit',
//           style: GoogleFonts.chakraPetch(
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//       ),
//       DataColumn(
//         label: Text(
//           'Amount',
//           style: GoogleFonts.chakraPetch(
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//       ),
//       // DataColumn(
//       //   label: Text(
//       //     'Price',
//       //     style: GoogleFonts.chakraPetch(
//       //       fontWeight: FontWeight.w600,
//       //     ),
//       //   ),
//       // ),
//     ];
//   }

//   List<DataRow> _createRows() {
//     return widget.orderAttr.mobilCartProducts!
//         .map((prod) => DataRow(cells: [
//               DataCell(
//                 Text(
//                   '${prod.title}',
//                   style: robotoSlab.copyWith(fontSize: 12, fontWeight: FontWeight.w500),
//                   // style: GoogleFonts.robotoSlab(
//                   //   fontSize: 12,
//                   // ),
//                 ),
//               ),
//               DataCell(
//                 Text(
//                   '${prod.quantity}',
//                 ),
//               ),
//               DataCell(
//                 Text(
//                   '${prod.unit}',
//                 ),
//               ),
//               DataCell(
//                 Text(
//                   '${prod.price! * prod.quantity!}',
//                 ),
//               ),
//             ]))
//         .toList();
//   }
// }
