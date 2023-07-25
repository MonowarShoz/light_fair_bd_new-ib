import 'package:flutter/material.dart';
import 'package:light_fair_bd_new/util/theme/custom_themes.dart';

Widget titleWidget(String? key, String? value,{double left=6,double right=0,double top=8,double bottom=4}) {
  return value!=null?Container(
    padding: EdgeInsets.only(left: left, top: top, bottom: bottom,right: right),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(flex: 2,child: Text(key ?? '', style: poppinRegular.copyWith(fontSize: 18, color: Color.fromARGB(255, 52, 123, 54),fontWeight: FontWeight.w500))),
        Expanded(flex: 3, child: Text(value , style: poppinRegular.copyWith(fontSize: 19, color: Colors.black,fontWeight: FontWeight.w500)))
      ],
    ),
  ):SizedBox.shrink();
}