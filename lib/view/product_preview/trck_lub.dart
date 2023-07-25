import 'package:flutter/material.dart';
import 'package:light_fair_bd_new/view/savsol_product/category_feed.dart';
import 'package:provider/provider.dart';

import '../../provider/mobil_feed_provider.dart';

class TrackLubScreen extends StatelessWidget {
  const TrackLubScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Provider.of<MobilFeedProvider>(context, listen: false).getCategoryWiseProducts();
    return Consumer<MobilFeedProvider>(builder: (context, mp, child) {
      return Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Column(
            children: [
              ...mp.categoryItems!
                  .map((e) => Card(
                        child: ExpansionTile(
                          title: Text(e.msirdesc!),
                          controlAffinity: ListTileControlAffinity.leading,
                          //  childrenPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                          expandedCrossAxisAlignment: CrossAxisAlignment.end,
                          // maintainState: true,
                          children: [
                            ...mp
                                .findByCateGory(e.msircode!)
                                .map((e) => ListTile(
                                      title: Text(e.sirdesc!),
                                    ))
                                .toList()
                          ],
                        ),
                      ))
                  .toList()
            ],
          ),
        ),
      );
    });
  }
}
