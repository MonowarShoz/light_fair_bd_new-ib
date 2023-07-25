import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:light_fair_bd_new/provider/auth_provider.dart';
import 'package:light_fair_bd_new/provider/mobil_feed_provider.dart';
import 'package:light_fair_bd_new/util/show_custom_snakbar.dart';
import 'package:light_fair_bd_new/view/home/under_constactor_screen.dart';
import 'package:provider/provider.dart';
import 'package:torch_light/torch_light.dart';

class ProductPreviewScreen extends StatelessWidget {
  const ProductPreviewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer2<MobilFeedProvider, UserConfigurationProvider>(
        builder: (context, mp, ap, child) {
      return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: AppBar(
            centerTitle: true,
            title: const Text(
              "Product Preview ",
              style: TextStyle(color: Colors.black),
            ),
            actions: [
              IconButton(
                onPressed: () async {
                  try {
                    await TorchLight.enableTorch();
                  } on Exception catch (_) {
                    showCustomSnackBar('Torch not available', context);
                    // Handle error
                  }

                  // try {
                  //   await TorchLight.disableTorch();
                  // } on Exception catch (_) {
                  //   showCustomSnackBar('Torch not available', context);
                  //   // Handle error
                  // }
                },
                icon: const Icon(
                  FontAwesomeIcons.lightbulb,
                  color: Colors.black,
                ),
              )
            ],
            leading: CupertinoNavigationBarBackButton(
              color: Colors.black,
              onPressed: () => Navigator.pop(context),
            ),
            backgroundColor: Colors.white,
          ),
        ),
        body: LayoutBuilder(builder: (context, constraints) {
          return GridView.builder(
              padding: const EdgeInsets.all(3),
              itemCount: mp.previewList.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                //  mainAxisExtent: 50,
                crossAxisCount: 3,
                crossAxisSpacing: 5,
                mainAxisSpacing: 15,
                //childAspectRatio: 3 / 3,
              ),
              itemBuilder: (context, index) {
                return Card(
                  clipBehavior: Clip.antiAlias,
                  margin: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(17),
                  ),
                  child: InkWell(
                    onTap: () {
                      mp.previewList[index].route != null
                          ? Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    mp.previewList[index].route!,
                              ))
                          : Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const UnderConstructionScreen(),
                              ));
                    },
                    child: Image.asset(
                      mp.previewList[index].image!,
                      //   fit: BoxFit.cover,
                      //   height: 5,

                      // height: 12,
                      // width: 20,
                      // fit: BoxFit.cover,
                    ),
                  ),
                );
              });
        }),
      );
    });
  }
}
