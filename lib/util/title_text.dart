
import 'package:flutter/material.dart';

import 'package:light_fair_bd_new/util/theme/custom_themes.dart';
//fascinate
class AppTitleText extends StatelessWidget {
  final double fontsize;
  const AppTitleText({
    Key? key,
    required this.fontsize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(children: [
        TextSpan(
          text: 'LI',
          style: chakraPetch.copyWith(
            color: Colors.green,
            fontSize: fontsize,
          ),
        ),
        TextSpan(
          text: 'G',
          style: chakraPetch.copyWith(
            color: Colors.red,
            fontSize: fontsize,
          ),
        ),
        TextSpan(
          text: 'HT ',
          style: chakraPetch.copyWith(
            color: Colors.green,
            fontSize: fontsize,
          ),
        ),
        TextSpan(
          text: 'FAIR BD LTD',
          style: chakraPetch.copyWith(
            color: Colors.indigo.shade900,
            fontSize: fontsize,
          ),
        ),
      ]),
    );
  }
}