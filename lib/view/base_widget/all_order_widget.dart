import 'package:flutter/material.dart';
import 'package:light_fair_bd_new/util/color_resources.dart';

import '../../util/dimensions.dart';
import '../../util/theme/custom_themes.dart';

class AllOrderTileWidget extends StatelessWidget {
  final String? title;
  final String? value;
  final double left;
  final double right;
  final double top;
  final double bottom;
  const AllOrderTileWidget({
    Key? key,
    this.title,
    this.value,
    this.left = 6,
    this.right = 0,
    this.top = 8,
    this.bottom = 4,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: left, top: top, bottom: bottom, right: right),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 2,
            child: SizedBox(
              width: Dimensions.fullWidth(context) / 2.9,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title ?? '',
                    style: poppinRegular.copyWith(
                      fontSize: 14,
                      color: ColorResources.getTextBgGreen(context),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    ':',
                    style: TextStyle(
                      fontSize: 15,
                       color: ColorResources.getTextBgGreen(context),
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
            ),
          ),
          Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(value!,
                    style:
                        poppinRegular.copyWith(fontSize: 12, fontWeight: FontWeight.w500,color: ColorResources.getTextBg(context),)),
              ))
        ],
      ),
    );
  }
}
