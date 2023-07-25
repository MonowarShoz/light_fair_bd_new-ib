import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:light_fair_bd_new/util/color_resources.dart';
import 'package:light_fair_bd_new/util/dimensions.dart';
import 'package:light_fair_bd_new/util/theme/custom_themes.dart';

class SignOutConfirmationDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        SizedBox(height: 20),
        CircleAvatar(
          radius: 30,
          backgroundColor: Theme.of(context).primaryColor,
          child: Icon(Icons.contact_support, size: 50),
        ),
        Padding(
          padding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
          child: Text('want_to_sign_out',
              style: titilliumBold, textAlign: TextAlign.center),
        ),
        Divider(height: 0, color: Colors.grey),
        Row(children: [
          Expanded(
              child: InkWell(
            onTap: () {},
            child: Container(
              padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.only(bottomLeft: Radius.circular(10))),
              child: Text('yes',
                  style: titilliumBold.copyWith(
                      color: ColorResources.getPrimary(context))),
            ),
          )),
          Expanded(
              child: InkWell(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Colors.deepOrange,
                  borderRadius:
                      BorderRadius.only(bottomRight: Radius.circular(10))),
              child: Text('no',
                  style: titilliumBold.copyWith(color: Colors.white)),
            ),
          )),
        ]),
      ]),
    );
  }
}
