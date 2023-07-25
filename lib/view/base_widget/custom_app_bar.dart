import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:light_fair_bd_new/util/dimensions.dart';
import 'package:light_fair_bd_new/util/images.dart';
import 'package:light_fair_bd_new/util/theme/custom_themes.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool isBackButtonExist;
  final IconThemeData? iconThemeData;
  final bool isOrderScreen;
  final bool isResponsive;
  final bool isHomeScreen;

  final GlobalKey<ScaffoldState>? drawerKey;

  const CustomAppBar({
    Key? key,
    this.title,
    this.isBackButtonExist = true,
    this.iconThemeData,
    this.isResponsive = false,
    this.isHomeScreen = false,
    this.isOrderScreen = false,
    this.drawerKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(

      title: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: isHomeScreen
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Image.asset(
                    Images.spl2,
                    width: MediaQuery.of(context).size.height / 4,
                  ),
                ),
              )
            : Text(
                title!,
                style: robotoRegular.copyWith(
                    fontSize: isResponsive ? 20 : Dimensions.FONT_SIZE_LARGE,
                    color: Theme.of(context).textTheme.bodyText1!.color),
              ),
      ),
      iconTheme: const IconThemeData(color: Color.fromARGB(255, 15, 10, 15)),
      backgroundColor: Colors.white,
      leading: isBackButtonExist
          ? IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back_ios),
              color: Theme.of(context).textTheme.bodyText1!.color,
            )
          : const SizedBox(),
      actions: [
        isHomeScreen
            ? IconButton(
                onPressed: () {
                  drawerKey!.currentState?.openEndDrawer();
                },
                icon: const Icon(Icons.menu),
              )
            : isOrderScreen
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(FontAwesomeIcons.clock),
                  )
                : SizedBox.shrink()
      ],
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size(double.maxFinite, 50);
}
