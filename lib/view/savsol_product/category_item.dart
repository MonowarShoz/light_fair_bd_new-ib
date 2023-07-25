import 'package:flutter/material.dart';
import 'package:light_fair_bd_new/util/color_resources.dart';
import 'package:light_fair_bd_new/util/theme/custom_themes.dart';
import 'package:light_fair_bd_new/view/savsol_product/category_feed.dart';

class CategoryItem extends StatelessWidget {
  final String? categoryName;
  final String? categoryId;
  const CategoryItem({
    Key? key,
    this.categoryName,
    this.categoryId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CategoryFeed(
                categoryCode: categoryId!,
                categoryTitle: categoryName!,
              ),
            ));
        // Navigator.of(context)
        //     .pushNamed(CategoryFeed.routeName, arguments: ScreenArguments(reportTitle: categoryName, categoryID: categoryId));
      },
      splashColor: Theme.of(context).primaryColor,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        height: 50,
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 3,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],

          border: Border.all(color: Colors.white),
          color: ColorResources.getHomeBg(context),
          // gradient: LinearGradient(
          //   colors: [
          //     Colors.white,
          //     Colors.white,
          //     // color.withOpacity(0.7),
          //     // color,
          //   ],
          //   begin: Alignment.topLeft,
          //   end: Alignment.bottomRight,
          // ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          //  crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(categoryName!,
                //textAlign: TextAlign.center,
                style: poppinRegular.copyWith(
                  color: ColorResources.getTextBg(context),
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                )),
          ],
        ),
      ),
    );
  }
}
