import 'package:flutter/material.dart';

class BackgroungImage extends StatelessWidget {
  const BackgroungImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            'assets/images/login_bg.png',
          ),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
