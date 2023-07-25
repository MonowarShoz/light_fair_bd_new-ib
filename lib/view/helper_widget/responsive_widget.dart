import 'package:flutter/material.dart';

class ResponsiveWidget extends StatelessWidget {
  final Widget? mobile;
  final Widget? tab;

  const ResponsiveWidget({Key? key, this.mobile, this.tab}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      print('Weight of ${constraints.maxWidth}');
      if (constraints.maxWidth < 768) {
        return mobile!;
      } else {
        return tab!;
      }
    });
  }
}
