import 'dart:typed_data';

import 'package:light_fair_bd_new/data/datasource/model/ret_sale_item.dart';
import 'package:light_fair_bd_new/provider/mobil_feed_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

Future<Uint8List> prodCategory(
  PdfPageFormat pageFormat,
  List<RetItemSale> ret,
  String title,

// String rand,
) async {
  final doc = pw.Document(pageMode: PdfPageMode.outlines);
  doc.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.legal,
      build: (context) => <pw.Widget>[
            pw.Column(children: [
              pw.Center(
                child: pw.Text(
                  'Light Fair BD LTD',
                  textScaleFactor: 1,
                  style: pw.TextStyle(fontSize: 15, fontWeight: pw.FontWeight.bold, lineSpacing: 2),
                ),
              ),
            ]),
            pw.SizedBox(height: 10),
            pw.Center(
              child: pw.Text(
                '$title List',
                style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold, lineSpacing: 2),
              ),
            ),
            pw.Divider(),
            pw.SizedBox(height: 10),
            ret.isNotEmpty
                ? pw.Table.fromTextArray(
                    context: context,
                    headerDecoration: pw.BoxDecoration(
                      color: PdfColor.fromInt(0xFFc7c7c7),

                      //color: PdfColor.fromInt(0xFFc7c7c7),
                    ),
                    cellAlignment: pw.Alignment.center,
                    data: <List<dynamic>>[
                        <String>['Sl', 'Product ID', 'Product Name'],
                        for (var i = 0; i < ret.length; i++)
                          <String>[
                            (i + 1).toString(),
                            ret[i].sircode!,
                           ret[i].sirdesc!
                          ]
                      ],
                    columnWidths: {
                        0: pw.FlexColumnWidth(1),
                        1: pw.FlexColumnWidth(2),
                        2: pw.FlexColumnWidth(3),
                      })
                : pw.Center(
                    child: pw.Text(
                      'No Data Found',
                      style: pw.TextStyle(fontSize: 18),
                    ),
                  ),
          ]));

  return await doc.save();
}
