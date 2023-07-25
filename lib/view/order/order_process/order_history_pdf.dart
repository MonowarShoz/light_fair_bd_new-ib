import 'dart:typed_data';
import 'package:light_fair_bd_new/provider/auth_provider.dart';
import 'package:light_fair_bd_new/util/date_converter.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../../data/datasource/model/order_history_info_model.dart';

Future<Uint8List> orderHistoryPdf(
  PdfPageFormat pageFormat,
  UserConfigurationProvider ap,
  List<OrderHistoryInfoModel>? _ordList,
  String title,

// String rand,
) async {
  final doc = pw.Document(pageMode: PdfPageMode.outlines);
  doc.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.legal,
      build: (context) => <pw.Widget>[
            pw.Column(children: [
              pw.Text(
                'Light Fair BD LTD',
                textScaleFactor: 1,
                style: pw.TextStyle(fontSize: 15, fontWeight: pw.FontWeight.bold, lineSpacing: 2),
              ),
              pw.Text(
                title,
                textScaleFactor: 1,
                style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.normal, lineSpacing: 2),
              ),
              pw.Divider(),
            ]),
            //  _ordList!.isNotEmpty
            _ordList!.isNotEmpty
                ? pw.Table.fromTextArray(
                    context: context,
                    headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    headerDecoration: pw.BoxDecoration(
                      color: PdfColor.fromInt(0xe7e8ee),

                      //color: PdfColor.fromInt(0xFFc7c7c7),
                    ),
                    data: <List<String>>[
                        <String>[
                          'SI',
                          'DATE',
                          'INV NO',
                          'Customer ID',
                          'Customer Name',
                          'Bill Amount',
                        ],
                        for (int i = 0; i < _ordList.length; i++)
                          <String>[
                            (i + 1).toString(),
                            DateConverter.formatDateIOS(_ordList[i].invdat!),
                            _ordList[i].invno1!,
                            _ordList[i].custid!,
                            _ordList[i].custName!,
                            _ordList[i].billam!.toString()
                            // DateConverter.formatDateIOS(_ordList![i].invdat!),
                            // _ordList![i].invno1!,
                            // _ordList![i].custid!,
                            // _ordList![i].custName!,
                            // _ordList![i].billam!.toString()
                          ],
                      ],
                    columnWidths: {
                        0: pw.FlexColumnWidth(1),
                        1: pw.FlexColumnWidth(2),
                        2: pw.FlexColumnWidth(2),
                        3: pw.FlexColumnWidth(2),
                        4: pw.FlexColumnWidth(3),
                        5: pw.FlexColumnWidth(2),
                      })
                : pw.Center(
                    child: pw.Text(
                      'No Data Found',
                      style: pw.TextStyle(fontSize: 18),
                    ),
                  ),
            // pw.Table.fromTextArray(
            //     context: context,
            //     headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            //     headerDecoration: pw.BoxDecoration(
            //       color: PdfColor.fromInt(0xe7e8ee),
            //
            //       //color: PdfColor.fromInt(0xFFc7c7c7),
            //     ),
            //     cellHeight: 40,
            //     cellAlignment: pw.Alignment.center,
            //     data: <List<dynamic>>[
            //       <String>["Sl", "Product Name", "Quantity", "Unit", "Amount"],
            //       for (var i = 0; i < mobilFeedProvider.getOrders!.length; i++)
            //         for (var j = 0; j < mobilFeedProvider.getOrders![i].mobilCartProducts!.length; j++)
            //           <String>[
            //             (j + 1).toString(),
            //             mobilFeedProvider.getOrders![i].mobilCartProducts![j].title!,
            //             mobilFeedProvider.getOrders![i].mobilCartProducts![j].quantity!.toString(),
            //             mobilFeedProvider.getOrders![i].mobilCartProducts![j].unit!,
            //             (mobilFeedProvider.getOrders![i].mobilCartProducts![j].quantity! *
            //                 mobilFeedProvider.getOrders![i].mobilCartProducts![j].price!)
            //                 .toString()
            //           ],
            //     ],
            //     columnWidths: {
            //       0: pw.FlexColumnWidth(1),
            //       1: pw.FlexColumnWidth(3),
            //       2: pw.FlexColumnWidth(2),
            //       3: pw.FlexColumnWidth(2),
            //       4: pw.FlexColumnWidth(3),
            //     })
          ]));
  return await doc.save();
}
