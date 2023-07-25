import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:light_fair_bd_new/util/color_resources.dart';
import 'package:light_fair_bd_new/util/images.dart';

import '../../util/dimensions.dart';
import '../../util/theme/custom_themes.dart';

class CustomExtendAppBar extends StatelessWidget {
  final String title;
  final Widget child;
  final Widget? bottomChild;

  const CustomExtendAppBar({
    Key? key,
    required this.title,
    required this.child,
    this.bottomChild,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Stack(
        children: [
          //background of the AppBar
          Container(
            height: 150,
            width: Dimensions.fullWidth(context),
            color: Colors.white,
          ),

          Positioned(
              top: 40,

              left: Dimensions.PADDING_SIZE_SMALL,
              right: Dimensions.PADDING_SIZE_SMALL,
              child: Row(

                children: [
                  CupertinoNavigationBarBackButton(
                    color: Colors.black,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),

                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: titilliumRegular.copyWith(fontSize: 20, color: Colors.black),
                  ),
                ],
              )),
          Container(
            margin: EdgeInsets.only(top: 120),
            decoration: BoxDecoration(
                color: ColorResources.getHomeBg(context),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),),
            child: child,
          )
        ],
      ),
    );
  }
}
