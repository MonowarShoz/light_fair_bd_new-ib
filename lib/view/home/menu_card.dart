import 'package:flutter/material.dart';
import 'package:light_fair_bd_new/provider/theme_provider.dart';
import 'package:light_fair_bd_new/util/images.dart';
import 'package:light_fair_bd_new/util/theme/custom_themes.dart';
import 'package:light_fair_bd_new/view/home/under_constactor_screen.dart';
import 'package:provider/provider.dart';

class MenuCard extends StatelessWidget {
  final Widget? routePageName;
  final String? imageUrl;
  final String? title;
  final Color? color;
  final Color? imgColor;
  final bool isTabResponsive;
  const MenuCard(
      {Key? key,
      this.routePageName,
      this.imageUrl,
      this.title,
      this.imgColor,
      this.color,
      this.isTabResponsive = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (routePageName != null) {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => routePageName!));
        } else {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => UnderConstructionScreen()));
        }
      },
      child: Column(
        //mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 130,
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(
                horizontal: isTabResponsive ? 20 : 10,
                vertical: isTabResponsive ? 55 : 15),
            decoration: BoxDecoration(
                color: Provider.of<ThemeProvider>(context).darkTheme ? Colors.grey : color!.withOpacity(.16),
                // boxShadow: [
                //   BoxShadow(
                //       color: Colors.grey.shade50,
                //       spreadRadius: 1,
                //       blurRadius: 5)
                // ],
                borderRadius: BorderRadius.circular(30)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: isTabResponsive ? 10 : 0),
                Container(
                  width: isTabResponsive ? 100 : 60,
                  height: isTabResponsive ? 100 : 60,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: Colors.white),
                  child: Image.asset(imageUrl!,
                      fit: BoxFit.cover,
                      color: imgColor,
                      width: 100,
                      height: 100,
                      ),
                ),
                SizedBox(height: isTabResponsive ? 15 : 0),
                FittedBox(
                    child: Text(title!,
                        style: titilliumSemiBold.copyWith(
                            fontWeight: FontWeight.w500,
                            fontSize: isTabResponsive ? 20 : 13,
                            color: Provider.of<ThemeProvider>(context).darkTheme ? Colors.white : color),
                        textAlign: TextAlign.center)),
              ],
            ),
          )
        ],
      ),
    );
  }
}
