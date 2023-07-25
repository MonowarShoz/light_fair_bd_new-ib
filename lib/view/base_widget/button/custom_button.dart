import 'package:flutter/material.dart';
import 'package:light_fair_bd_new/provider/theme_provider.dart';
import 'package:light_fair_bd_new/util/color_resources.dart';
import 'package:light_fair_bd_new/util/theme/custom_themes.dart';
import 'package:provider/provider.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback onTap;
  final String? buttonText;
  final Color? btnColor;
  final double? width;
  final double height;
  final bool isIcon;
  final IconData? iconDate;

  CustomButton(
      {required this.onTap,
      this.buttonText,
      this.width,
      this.height = 45,
      this.isIcon = false,
      this.iconDate, this.btnColor});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      padding: EdgeInsets.zero,
      onPressed: onTap,
      child: Container(
        height: height,
        width: width,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            //color: btnColor ?? ColorResources.getChatIcon(context),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 7,
                  offset: Offset(0, 1)), // changes position of shadow
            ],
            gradient: Provider.of<ThemeProvider>(context).darkTheme
                ? LinearGradient(colors: [
              Color.fromARGB(255, 255, 255, 255).withOpacity(.8),
              Color.fromARGB(255, 255, 255, 255).withOpacity(.9),
              Color.fromARGB(255, 255, 255, 255).withOpacity(.8),
            ])
                : LinearGradient(colors: [
                    Color.fromARGB(255, 67, 29, 221).withOpacity(.8),
                    Color.fromARGB(255, 87, 49, 236).withOpacity(.9),
                    Color.fromARGB(255, 72, 29, 228).withOpacity(.8),
                  ]),
            borderRadius: BorderRadius.circular(10)),
        child: !isIcon
            ? Text(buttonText!,
                style: titilliumSemiBold.copyWith(
                  fontSize: height != 45 ? 20 : 16,
                  color:Provider.of<ThemeProvider>(context).darkTheme ? Colors.black : Colors.white,
                ))
            : Icon(iconDate, color: Colors.white),
      ),
    );
  }

  MaterialButton buildFlatButton(BuildContext context,
      {double size = 45, double? width}) {
    return MaterialButton(
      padding: EdgeInsets.zero,
      onPressed: onTap,
      child: Container(
        height: size,
        width: MediaQuery.of(context).size.width * 0.60,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: ColorResources.getChatIcon(context),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 7,
                  offset: Offset(0, 1)), // changes position of shadow
            ],
            gradient: Provider.of<ThemeProvider>(context).darkTheme
                ? null
                : LinearGradient(colors: [
                    Colors.deepOrange.withOpacity(.8),
                    Colors.deepOrange.withOpacity(.9),
                    Colors.deepOrange.withOpacity(.8),
                  ]),
            borderRadius: BorderRadius.circular(10)),
        child: Text(buttonText!,
            style: titilliumSemiBold.copyWith(
              fontSize: size != 45 ? 20 : 16,
              color:  Theme.of(context).highlightColor,
            )),
      ),
    );
  }
}
