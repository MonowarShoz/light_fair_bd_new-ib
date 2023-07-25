import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:light_fair_bd_new/util/color_resources.dart';
import 'package:light_fair_bd_new/util/dimensions.dart';
import 'package:light_fair_bd_new/util/theme/custom_themes.dart';

class UnderConstructionScreen extends StatelessWidget {
  const UnderConstructionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        height: Dimensions.fullHeight(context),
        width: Dimensions.fullWidth(context),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(
                FontAwesomeIcons.circleArrowLeft,
                size: 40,
                color: ColorResources.getHomeBg(context),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            Text(
              'THIS PAGE IS\nUNDER\nCONSTRUCTION',
              style: robotoBold.copyWith(color: ColorResources.orange, fontSize: 24),
            ),
          ],
        ),
      ),
    );
  }
}
