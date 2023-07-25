import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:light_fair_bd_new/localization/language_constraints.dart';
import 'package:light_fair_bd_new/provider/auth_provider.dart';
import 'package:light_fair_bd_new/provider/mobil_feed_provider.dart';
import 'package:light_fair_bd_new/provider/theme_provider.dart';
import 'package:light_fair_bd_new/util/app_constants.dart';
import 'package:light_fair_bd_new/util/color_resources.dart';
import 'package:light_fair_bd_new/util/dimensions.dart';
import 'package:light_fair_bd_new/util/theme/custom_themes.dart';
import 'package:light_fair_bd_new/view/base_widget/animated_custom_dialog.dart';
import 'package:light_fair_bd_new/view/base_widget/custom_extended_appbar.dart';
import 'package:light_fair_bd_new/view/menu/widget/language_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomExtendAppBar(
        title: 'Setting Screen',
        child: Column(
          children: [
            SwitchListTile(
              onChanged: (bool value) {
                Provider.of<ThemeProvider>(context, listen: false)
                    .toggleTheme();
              },
              value: Provider.of<ThemeProvider>(context).darkTheme,
              title: const Text('Dark Theme'),
            ),
            TextButton(
              child: const Text('Choose Language'),
              onPressed: () {
                showAnimatedDialog(context, const CurrencyDialog());
              },
            ),
            Consumer<UserConfigurationProvider>(builder: (context, mp, child) {
              return ElevatedButton(
                  onPressed: () {
                    mp.readFile(
                      context,
                      const AppUpdateDialog(),
                    );
                  },
                  child: const Text('Press'));
            }),
          ],
        ),
      ),
    );
  }
}

class AppUpdateDialog extends StatefulWidget {
  const AppUpdateDialog({Key? key}) : super(key: key);

  @override
  State<AppUpdateDialog> createState() => _AppUpdateDialogState();
}

class _AppUpdateDialogState extends State<AppUpdateDialog> {
  final Uri fileurl = Uri.parse(AppConstants.appDownlinkUrl);

  Future<void> _launchUrl() async {
    launchUrl(fileurl);
    if (!await launchUrl(
      fileurl,
    )) {
      throw 'Could not launch $fileurl';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 100,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  'Update is Available',
                  textAlign: TextAlign.center,
                  style: robotoBold.copyWith(
                      fontWeight: FontWeight.w600, fontSize: 20),
                ),
              ),
            ),
          ),
          Divider(
            height: Dimensions.PADDING_SIZE_EXTRA_SMALL,
            color: ColorResources.getHint(context),
          ),
          Row(children: [
            // TextButton(
            //   onPressed: () => Navigator.pop(context),
            //   child: Text(getTranslated('cancel', context),
            //   style: robotoRegular.copyWith(
            //       color: ColorResources.getYellow(context))),
            // ),
            // Container(
            //   height: 50,
            //   padding: EdgeInsets.symmetric(
            //       vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
            //   child: VerticalDivider(
            //       width: Dimensions.PADDING_SIZE_EXTRA_SMALL,
            //       color: Theme.of(context).hintColor),
            // ),
            Expanded(
                child: TextButton(
              onPressed: () async {
                if (await launchUrl(fileurl)) {
                  await launchUrl(fileurl,
                      mode: LaunchMode.externalApplication);
                } else {
                  throw 'Could not launch $fileurl';
                }

                // Map<Permission, PermissionStatus> statuses = await [
                //   Permission.storage,
                //   //add more permission to request here.
                // ].request();
                // if (statuses[Permission.storage]!.isGranted) {
                //   var dir = await getApplicationDocumentsDirectory();
                //   String savename = "file.jpg";
                //   String savePath ='${dir.path}/file.jpg';
                //   print(savePath);
                //   try {
                //     await Dio().download(fileurl, savePath,
                //         onReceiveProgress: (received, total) {
                //       if (total != -1) {
                //         print(
                //             (received / total * 100).toStringAsFixed(0) + "%");
                //       }
                //     });
                //      print("File is saved to download folder.");
                //   } on DioError catch (e) {
                //     print(e.message);
                //   }
                //   // var dir = await
                // }

                // Navigator.pop(context);
              },
              child: Text(
                getTranslated('ok', context),
                style: robotoBold.copyWith(
                  fontSize: 18,
                ),
              ),
            )),
          ]),
        ],
      ),
    );
  }
}
