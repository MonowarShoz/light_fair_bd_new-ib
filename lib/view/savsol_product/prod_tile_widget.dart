import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:light_fair_bd_new/util/images.dart';
import 'package:light_fair_bd_new/view/home/under_constactor_screen.dart';

class ProdTileWidget extends StatelessWidget {
  final Widget? routePageName;
  final String? img;
  final String? menuName;

  const ProdTileWidget({Key? key, required this.routePageName, this.img, this.menuName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (routePageName != null) {
          Navigator.of(context).push(MaterialPageRoute(builder: (_) => routePageName!));
        } else {
          Navigator.of(context).push(MaterialPageRoute(builder: (_) => UnderConstructionScreen()));
        }
      },
      child: Card(
        elevation: 5,
        child: Column(
          children: [
            Image.asset(
              img!,
              width: 100,
            ),
            // Center(
            //     child: Text(
            //   menuName!,
            //   style: TextStyle(fontSize: 13),
            //   textAlign: TextAlign.center,
            // )),
          ],
        ),
      ),
    );
  }
}
