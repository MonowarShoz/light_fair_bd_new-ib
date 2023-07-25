import 'dart:io';

import 'package:flutter/material.dart';
import 'package:light_fair_bd_new/util/dimensions.dart';
import 'package:light_fair_bd_new/util/theme/custom_themes.dart';
import 'package:provider/provider.dart';

import 'package:share_plus/share_plus.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfPreviewScreen extends StatelessWidget {
  final String? path;
  final String? title;
  final File? file;
  final bool isResponsive;
  final Provider? atAgalanceProvider;

  const PdfPreviewScreen({
    Key? key,
    this.path,
    this.title,
    this.isResponsive = false,
    this.file,
    this.atAgalanceProvider,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final file = File('$path');
        if (file.existsSync()) await file.delete();
        print('file Remove Successfully');

        Navigator.of(context).pop();
        return Future.value(true);
      },
      child: Scaffold(
          appBar: AppBar(
            title: Text(title!,
                style: robotoRegular.copyWith(
                    fontSize: isResponsive ? 20 : Dimensions.FONT_SIZE_LARGE,
                    color: Theme.of(context).textTheme.bodyText1!.color)),
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
                icon: Icon(Icons.arrow_back_ios),
                color: Theme.of(context).textTheme.bodyText1!.color,
                onPressed: () async {
                  final file = File('$path');
                  if (file.existsSync()) await file.delete();
                  print('file Remove Successfully');
                  Navigator.pop(context);
                }),
            actions: [
              IconButton(
                  icon: Icon(Icons.share, color: Colors.green.shade600),
                  onPressed: () {
                    Share.shareFiles([path!], text: '$title');
                  })
            ],
          ),
          body: SfPdfViewer.file(file!)),
    );
  }
}
