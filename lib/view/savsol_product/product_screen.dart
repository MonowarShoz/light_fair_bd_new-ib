import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:light_fair_bd_new/provider/mobil_feed_provider.dart';
import 'package:light_fair_bd_new/provider/theme_provider.dart';
import 'package:light_fair_bd_new/util/theme/custom_themes.dart';
import 'package:light_fair_bd_new/view/menu/menu_screen.dart';
import 'package:light_fair_bd_new/view/savsol_product/category_item.dart';
import 'package:provider/provider.dart';
import '../../util/color_resources.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({Key? key}) : super(key: key);

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  @override
  Widget build(BuildContext context) {
    Provider.of<MobilFeedProvider>(context, listen: false)
        .getCategoryWiseProducts();
    return Consumer<MobilFeedProvider>(builder: (context, category, child) {
      return Scaffold(
        backgroundColor: ColorResources.getHomeBg(context),
        endDrawer: MenuScreen(),
        appBar: AppBar(
          backgroundColor: ColorResources.getHomeBg(context),
          title: Text(
            'Product Category',
            style: poppin.copyWith(
              fontSize: 17,
              //color: Colors.white,
              color: ColorResources.getTextBg(context),
            ),
          ),
          leading:  CupertinoNavigationBarBackButton(
             color: Provider.of<ThemeProvider>(context).darkTheme ? Colors.white : Colors.black,
          ),
          actions: [
            // CupertinoNavigationBarBackButton(color: Colors.black,),
          ],
          iconTheme: IconThemeData(
            color: Provider.of<ThemeProvider>(context).darkTheme
                ? Colors.white
                : Colors.black,
          ),
        ),
        body: Container(
          margin: const EdgeInsets.all(2),
          child: !category.isLoading
              ? ListView.builder(
                  itemCount: category.categoryItems!.length,
                  itemBuilder: ((context, index) {
                    return CategoryItem(
                      categoryId: category.categoryItems![index].msircode,
                      categoryName: category.categoryItems![index].msirdesc,
                    );
                  }),
                )
              : const Center(
                  child: CircularProgressIndicator(),
                ),
          // child: GridView(

          //   children: category.categoryItems!
          //       .map((e) => CategoryItem(
          //             categoryId: e.msircode,
          //             categoryName: e.msirdesc,
          //           ))
          //       .toList(),
          //   gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          //     maxCrossAxisExtent: 180,
          //     childAspectRatio: 2 / 2,

          //     crossAxisSpacing: 5,
          //     mainAxisSpacing: 2,
          //   ),
          // ),
        ),
      );
    });
  }
}
