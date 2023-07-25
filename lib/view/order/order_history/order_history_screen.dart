import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:light_fair_bd_new/provider/auth_provider.dart';
import 'package:light_fair_bd_new/provider/mobil_feed_provider.dart';
import 'package:light_fair_bd_new/provider/theme_provider.dart';
import 'package:light_fair_bd_new/util/date_converter.dart';
import 'package:light_fair_bd_new/util/dimensions.dart';
import 'package:light_fair_bd_new/util/show_custom_snakbar.dart';
import 'package:light_fair_bd_new/util/theme/custom_themes.dart';
import 'package:light_fair_bd_new/view/base_widget/tile_widget.dart';
import 'package:light_fair_bd_new/view/order/order_process/order_history_pdf.dart';
import 'package:light_fair_bd_new/view/order/pdf_preview_screen.dart';
import 'package:pdf/pdf.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/cupertino.dart';
import '../../../data/datasource/model/order_history_info_model.dart';


class OrderHistoryScreen extends StatefulWidget {
  final bool isPending;
  final bool isApproved;
  const OrderHistoryScreen(
      {Key? key, required this.isPending, required this.isApproved})
      : super(key: key);

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  String? drp;
  bool isChecked = false;
  String statusTitle = 'Approved';
  bool isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getbranc();
  }

  getbranc() async {
    await Provider.of<UserConfigurationProvider>(context, listen: false)
        .getCompanyBranchInfo();
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<UserConfigurationProvider>(context, listen: false).clearInfo();
    return Scaffold(
      backgroundColor: Provider.of<ThemeProvider>(context).darkTheme
          ? Color(0xFF303030)
          : Color.fromARGB(255, 238, 246, 230),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Find Order History',
          style: poppinRegular.copyWith(
              color: Colors.black, fontWeight: FontWeight.w500, fontSize: 18),
        ),
        leading: CupertinoNavigationBarBackButton(
          onPressed: () => Navigator.pop(context),
          color: Provider.of<ThemeProvider>(context).darkTheme
              ? Colors.white
              : Colors.black,
        ),
        actions: [
          Consumer<UserConfigurationProvider>(builder: (context, ap, child) {
            return IconButton(
              onPressed: () async {
                String dir = (await getExternalStorageDirectory())!.path;
                //  widget.isPending && !widget.isApproved
                // ? orderHistoryListView(ap, ap.orderHistoryList!)
                // : (!widget.isPending && widget.isApproved) && isChecked
                //     ? orderHistoryListView(ap, ap.approvedList!)
                //     : orderHistoryListView(ap, ap.rejectedList!)
                var bytes = await orderHistoryPdf(
                    PdfPageFormat.legal,
                    ap,
                    widget.isPending && !widget.isApproved
                        ? ap.orderHistoryList!
                        : (!widget.isPending && widget.isApproved) && isChecked
                            ? ap.approvedList
                            : ap.rejectedList,
                    widget.isPending && !widget.isApproved
                        ? 'Pending Order Details'
                        : (!widget.isPending && widget.isApproved) && isChecked
                            ? 'Approved order List'
                            : 'Rejected Order List');
                final file = File('$dir/order_info.pdf');
                await file.writeAsBytes(bytes);
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => PdfPreviewScreen(
                        path: '$dir/order_history.pdf',
                        title: 'order_info Pdf',
                        isResponsive: true,
                        file: file),
                  ),
                );
              },
              icon: Icon(Icons.picture_as_pdf),
            );
          })
        ],
        iconTheme: IconThemeData(
          color: Provider.of<ThemeProvider>(context).darkTheme
              ? Colors.white
              : Colors.brown,
        ),
      ),
      body: Consumer2<MobilFeedProvider, UserConfigurationProvider>(
          builder: (context, mp, ap, child) {
        return Column(
          children: [
            // ElevatedButton(
            //     onPressed: () {
            //       Navigator.of(context).push(
            //         MaterialPageRoute(builder: (_) => AllOrderScreen(),)
            //       );
            //     },
            //     child: Text('all order')),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Material(
                elevation: 3,
                borderRadius: BorderRadius.circular(4),
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  // color: Colors.grey.shade300,
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                        hint: Center(
                            child: Text(
                          'Pick Store',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                              fontSize: 15),
                        )),
                        borderRadius: BorderRadius.circular(4),
                        value: drp,
                        isExpanded: true,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                        ),
                        //alignment: Alignment.centerLeft,
                        iconSize: 30,
                        items: ap.branchList!
                            .map((e) => DropdownMenuItem(
                                value: e.sectcod,
                                child: Center(
                                  child: Text(
                                    '${e.sectname}',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15),
                                  ),
                                )))
                            .toList(),
                        onChanged: (String? val) {
                          setState(() {
                            drp = val;
                            debugPrint('office $drp');
                          });
                        }),
                  ),
                ),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height / 3.5,
              width: MediaQuery.of(context).size.width * .94,
              padding: const EdgeInsets.fromLTRB(
                  Dimensions.PADDING_SIZE_DEFAULT,
                  Dimensions.PADDING_SIZE_DEFAULT,
                  Dimensions.PADDING_SIZE_DEFAULT,
                  0),
              margin: const EdgeInsets.only(bottom: 15),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade300,
                    spreadRadius: 1,
                    blurRadius: 5,
                  )
                ],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Center(
                    child: Text(
                      'Select Date for query',
                      style: poppinRegular.copyWith(fontSize: 16),
                    ),
                  ),
                  Divider(),
                  InkWell(
                    onTap: () {
                      _showDatePicker(
                        ctx: context,
                        ap: ap,
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: titleWidget(
                            'From Date :',
                            ap.invFromDate,
                            //attendanceProvider.fromDate,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            _showDatePicker(
                              ctx: context,
                              ap: ap,
                            );
                          },
                          child: const Icon(Icons.calendar_today,
                              color: Colors.green),
                        ),
                      ],
                    ),
                  ),
                  const Divider(
                    thickness: 2,
                    color: Colors.black26,
                  ),
                  InkWell(
                    onTap: () {
                      _showDatePicker(
                        ctx: context,
                        ap: ap,
                        isFromDate: false,
                      );
                    },
                    child: Row(
                      children: [
                        Expanded(
                          child: titleWidget(
                            'To Date :',
                            //attendanceProvider.toDate,
                            ap.invToDate,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            _showDatePicker(
                              ctx: context,
                              ap: ap,
                              isFromDate: false,
                            );
                          },
                          child: const Icon(
                            Icons.calendar_today,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                  const Divider(),
                  !widget.isPending && widget.isApproved
                      ? Row(
                          children: [
                            isChecked
                                ? Text(
                                    'approved List',
                                    style: poppinRegular.copyWith(
                                      fontSize: 18,
                                      color: Color.fromARGB(255, 52, 123, 54),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  )
                                : Text(
                                    'Rejected List',
                                    style: poppinRegular.copyWith(
                                      fontSize: 18,
                                      color: Colors.red,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                            Switch(
                                value: isChecked,
                                onChanged: (bool? v) {
                                  setState(() {
                                    isChecked = v!;
                                  });
                                })
                          ],
                        )
                      : const SizedBox.shrink(),
                ],
              ),
            ),
            SizedBox(
              width: Dimensions.fullWidth(context) * .9,
              child: ElevatedButton(
                onPressed: () async {
                  // ordList.clear();
                  drp != null
                      ? await ap.submitForInfo(
                          drp!,
                          widget.isPending && !widget.isApproved
                              ? "D".trim()
                              : (!widget.isPending && widget.isApproved) &&
                                      isChecked
                                  ? "A"
                                  : "C",
                          context)
                      : showCustomSnackBar('Please Select Store', context);

                  // ap.getOrderHistoryInfo(drp, context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
                child: Text(
                  'Confirm',
                  style: poppinRegular.copyWith(fontSize: 18),
                ),
              ),
            ),

            widget.isPending && !widget.isApproved
                ? orderHistoryListView(ap, ap.orderHistoryList!)
                : (!widget.isPending && widget.isApproved) && isChecked
                    ? orderHistoryListView(ap, ap.approvedList!)
                    : orderHistoryListView(ap, ap.rejectedList!)
          ],
        );
      }),
    );
  }

  Widget orderHistoryListView(
      UserConfigurationProvider ap, List<OrderHistoryInfoModel> ordList) {
    //orderHistorList;
    return Expanded(
        child: ListView.builder(
            itemCount: ordList.length,
            itemBuilder: (context, index) {
              return Card(
                child: Column(
                  children: [
                    ordTitleWidget('Order Date :',
                        ' ${DateConverter.formatDateIOS(ordList[index].invdat!)}'),
                    ordTitleWidget('Invoice No:', '${ordList[index].invno1}'),
                    ordTitleWidget(
                        'Customer Name', '${ordList[index].custName}'),
                    ordTitleWidget(
                        'Bill Amount', '${ordList[index].billam} Taka'),
                    ordTitleWidget('Status', '${ordList[index].invstatus} '),
                    ap.jwtTokenModel!.hccode == "950600801003"
                        ? ordTitleWidget(
                            'Issued By', '${ordList[index].invbyName} ')
                        : SizedBox.shrink(),
                  ],
                ),
              );
            }));
  }

  Widget ordTitleWidget(String? key, String? value,
      {double left = 6, double right = 0, double top = 8, double bottom = 4}) {
    return value != null
        ? Container(
            padding: EdgeInsets.only(
                left: left, top: top, bottom: bottom, right: right),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                    flex: 2,
                    child: Text(key ?? '',
                        style: TextStyle(
                          fontSize: 15,
                          color: Color.fromARGB(255, 52, 123, 54),
                          fontWeight: FontWeight.w600,
                        ))),
                Expanded(
                    flex: 3,
                    child: Text(value,
                        style: TextStyle(fontSize: 14, color: Colors.black)))
              ],
            ),
          )
        : SizedBox.shrink();
  }

  Future _showDatePicker(
      {ctx, UserConfigurationProvider? ap, bool isFromDate = true}) async {
    DateTime? newDateTime = await showRoundedDatePicker(
      context: ctx,
      height: 300,
      theme: ThemeData(primarySwatch: Colors.deepOrange),
      initialDate: isFromDate
          ? DateConverter.convertStringToDateFormat2(ap!.invFromDate)
          : DateConverter.convertStringToDateFormat2(ap!.invToDate),
      firstDate: DateTime(DateTime.now().year - 10),
      lastDate: DateTime.now(),
      borderRadius: 2,
    );

    if (newDateTime != null) {
      if (isFromDate) {
        ap.invUpdateFromOrToDate(newDateTime, isFromDate: true);
      } else {
        ap.invUpdateFromOrToDate(newDateTime);
      }

      if (isFromDate) {
        ap.invOkFromOrToDate(ctx, isFromDate: true);
      } else {
        ap.invOkFromOrToDate(ctx);
      }
    }
  }
}
