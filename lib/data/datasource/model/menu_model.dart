import 'package:flutter/material.dart';
import 'package:light_fair_bd_new/data/datasource/model/config_model.dart';

class MenuModel {
  //EmpMenuList? empMenuList;
  String? menuName;
  Widget? routeName;
  Color? imgColor;
  Color? color;
  IconData? iconData;
  String? icon;
  MenuModel({
    //this.empMenuList,
    this.routeName,
    this.iconData,
    this.color,
    this.imgColor,
    this.icon,
    required this.menuName,
  });
}
