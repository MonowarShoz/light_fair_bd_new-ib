import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:light_fair_bd_new/data/datasource/model/order_process_model.dart';
import 'package:light_fair_bd_new/provider/auth_provider.dart';
import 'package:light_fair_bd_new/provider/mobil_feed_provider.dart';
import 'package:light_fair_bd_new/util/date_converter.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:provider/provider.dart';
import 'package:number_to_character/number_to_character.dart';

Future<Uint8List> orderDetailsPdf(
  PdfPageFormat pageFormat,
  MobilFeedProvider mobilFeedProvider,
  String customerId,
  String customerName,
  String storeName,
  String dateTime,
  // String comment,
  String invoicenum,
  UserConfigurationProvider authProvider,

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
              pw.SizedBox(
                height: 10,
              ),
              pw.Row(mainAxisAlignment: pw.MainAxisAlignment.center, children: [
                pw.Text('Address: '),
                pw.Center(
                  child: pw.Text('Arambag, Mirpur,Dhaka'),
                ),
              ]),
              pw.Divider(),
              pw.Center(
                child: pw.Text(
                  'INVOICE',
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
              pw.SizedBox(height: 15),
              pw.Padding(
                padding: const pw.EdgeInsets.all(8),
                child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Row(children: [
                        pw.Text(
                          'Customer ID : ',
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                        pw.Text(customerId),
                      ]),
                      pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                        pw.Row(children: [
                          pw.Text('Invoice No: ',
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                                fontSize: 13,
                              )),
                          pw.Text(invoicenum),
                        ]),
                      ]),
                    ]),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.all(8),
                child: pw.Row(children: [
                  pw.Text('Invoice Date: ',
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 13,
                      )),
                  pw.Text(DateConverter.formatDateIOS(dateTime)),
                ]),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.all(8),
                child: pw.Row(children: [
                  pw.Text('Customer Name : ',
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 13,
                      )),
                  pw.Text(customerName),
                ]),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.all(8),
                child: pw.Row(children: [
                  pw.Text('Store Name : ',
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 13,
                      )),
                  pw.Text(storeName),
                ]),
              ),
              // comment.isEmpty
              //     ? pw.SizedBox.shrink()
              //     : pw.Padding(
              //         padding: const pw.EdgeInsets.all(8),
              //         child: pw.Row(children: [
              //           pw.Text('Remarks: ',
              //               style: pw.TextStyle(
              //                 fontWeight: pw.FontWeight.bold,
              //                 fontSize: 13,
              //               )),
              //           pw.Text(comment),
              //         ]),
              //       ),
            ]),
            pw.Divider(),
            pw.SizedBox(height: 10),
            authProvider.editProdList.isNotEmpty
                ? pw.Table.fromTextArray(
                    
                    context: context,
                    headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    headerDecoration: pw.BoxDecoration(
                      color: PdfColor.fromInt(0xe7e8ee),

                      //color: PdfColor.fromInt(0xFFc7c7c7),
                    ),
                    cellHeight: 40,
                    cellAlignment: pw.Alignment.center,
                    data: <List<dynamic>>[
                        <String>["Sl", "Product Name", "Quantity", "Unit", "Amount", "Note"],
                        for (var i = 0; i < authProvider.editProdList.length; i++)
                          <String>[
                            (i + 1).toString(),
                            authProvider.editProdList[i].sirdesc!,
                            authProvider.editProdList[i].invqty!.toString(),
                            authProvider.editProdList[i].sirunit!,
                            (authProvider.editProdList[i].sirunit == 'PCS'
                                    ? (authProvider.editProdList[i].invqty! * authProvider.editProdList[i].itmrat!)
                                    : (authProvider.editProdList[i].invqty! *
                                        authProvider.editProdList[i].itmrat! *
                                        authProvider.editProdList[i].siruconf!.toDouble()))
                                .toString(),
                            authProvider.editProdList[i].invrmrk!,
                            // mobilFeedProvider
                            //     .getOrders![i].mobilCartProducts![j].title!,
                            // mobilFeedProvider
                            //     .getOrders![i].mobilCartProducts![j].quantity!
                            //     .toString(),
                            // mobilFeedProvider
                            //     .getOrders![i].mobilCartProducts![j].unit!,
                            // (mobilFeedProvider.getOrders![i]
                            //                 .mobilCartProducts![j].unit ==
                            //             'PCS'
                            //         ? (mobilFeedProvider.getOrders![i]
                            //                 .mobilCartProducts![j].quantity! *
                            //             mobilFeedProvider.getOrders![i]
                            //                 .mobilCartProducts![j].price!)
                            //         : (mobilFeedProvider.getOrders![i]
                            //                 .mobilCartProducts![j].quantity! *
                            //             mobilFeedProvider.getOrders![i]
                            //                 .mobilCartProducts![j].price! *
                            //             mobilFeedProvider.getOrders![i]
                            //                 .mobilCartProducts![j].unitconv3!
                            //                 .toDouble()))
                            //     .toString()
                          ],
                      ],
                    columnWidths: {
                        0: pw.FlexColumnWidth(1),
                        1: pw.FlexColumnWidth(3),
                        2: pw.FlexColumnWidth(2),
                        3: pw.FlexColumnWidth(2),
                        4: pw.FlexColumnWidth(3),
                      })
                : pw.Center(
                    child: pw.Text(
                      'No Data Found',
                      style: pw.TextStyle(fontSize: 18),
                    ),
                  ),
            pw.SizedBox(height: 10),
            pw.Column(children: [
              pw.Padding(
                padding: const pw.EdgeInsets.all(8),
                child: pw.Row(mainAxisAlignment: pw.MainAxisAlignment.end, children: [
                  pw.Text('Total Amount : ',
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 13,
                      )),
                  pw.Text('${authProvider.totalAmountOrder} Taka'),
                ]),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.all(8),
                child: pw.Row(mainAxisAlignment: pw.MainAxisAlignment.end, children: [
                  pw.Text('In word : ',
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 10,
                      )),
                  pw.Text('${authProvider.numberText(authProvider.totalAmountOrder)} Taka',
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 10,
                      )),
                ]),
              ),
            ]),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.start,
              children: [
                pw.Column(
                  children: [
                    pw.Table.fromTextArray(
                      data: [
                        <String>['Grand Total', '${authProvider.totalAmountOrder}'],
                        <String>[
                          'Paid Amount',
                          ' ',
                        ],
                        <String>['Current Dues', '${authProvider.totalAmountOrder}'],
                        <String>['Previous Dues', '${authProvider.totalAmountOrder}']
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
      footer: (pw.Context context) {
        return pw.Container(
          alignment: pw.Alignment.centerRight,
          child: pw.Column(children: [
            pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
              pw.Text('Page ${context.pageNumber}'),
              pw.Text('Order Issued By ${authProvider.jwtTokenModel!.hcname!}'),
            ]),
          ]),
        );
      }));
  return await doc.save();
}
