import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:light_fair_bd_new/provider/auth_provider.dart';
import 'package:light_fair_bd_new/util/background_img.dart';
import 'package:light_fair_bd_new/util/images.dart';
import 'package:light_fair_bd_new/util/show_custom_snakbar.dart';
import 'package:light_fair_bd_new/util/theme/custom_themes.dart';
import 'package:light_fair_bd_new/view/auth/login_screen.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _route();
  }

  void _route() {
    // Provider.of<AuthProvider>(context, listen: false).getToken().then((isSuccess) {
    //   if (isSuccess) {
    //     Timer(Duration(seconds: 2), () {
    //       Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => LoginScreen()));
    //     });
    //   }
    // });
    // Provider.of<AuthProvider>(context,listen: false).readFile(context);
    Provider.of<UserConfigurationProvider>(context, listen: false).isUpdate
        ? showCustomSnackBar('You need to update', context)
        : Timer(const Duration(seconds: 3), () {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => LoginScreen()));
            debugPrint("HELLO FLUTTER DOT ORG");
          });
  }

  bool isResponsive = false;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.white));
    Provider.of<UserConfigurationProvider>(context).getInfo();

    // Provider.of<AuthProvider>(context, listen: false).getCompanyBranchInfo();
    // Provider.of<AuthProvider>(context,listen: false ).getTodayOrderNotif();

    return Stack(
      children: [
        const BackgroungImage(),
        Scaffold(
          backgroundColor: Colors.transparent,
          key: _globalKey,
          body:
              // BackgroungImage(),
              // appTitleText(fontsize: 13),
              SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: 3,
                  child: Align(
                    alignment: FractionalOffset.center,
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Image.asset(Images.spl2),
                    ),
                    // child: appTitleText(
                    //   fontsize: 35,
                    // ),
                  ),
                ),
                Expanded(
                  child: Text(
                      'version : ${Provider.of<UserConfigurationProvider>(context, listen: false).versionName}'),
                ),
                // Text('LIGHT FAIR BD',
                //     style: robotoBold.copyWith(
                //         fontSize: 25, color: Colors.blueGrey)),

                const CircularProgressIndicator(),

                Expanded(
                  child: Align(
                    alignment: FractionalOffset.bottomCenter,
                    child: Container(
                      width: double.infinity,
                      color: Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            Images.asit_logo,
                            width: isResponsive ? 50 : 20,
                            height: isResponsive ? 50 : 20,
                            fit: BoxFit.scaleDown,
                          ),
                          Text(
                            'ASIT Services Limited.',
                            style: titilliumRegular.copyWith(
                                fontSize: 15, color: Colors.blueGrey),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // Container(
                //     margin: const EdgeInsets.only(top: 20),
                //     alignment: Alignment.center,
                //     child: Text('Developed By ',
                //         style: titilliumRegular.copyWith(
                //             fontSize: 10, color: Colors.blueGrey))),
              ],
            ),
          ),

          // Image.asset(
          //   Images.splash_img,
          //   width: double.infinity,
          //   height: double.infinity,
          //   fit: BoxFit.fill,
          // ),

          // Text('LIGHT FAIR BD',
          //     style:
          //         robotoBold.copyWith(fontSize: 25, color: Colors.blueGrey)),
          // const SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),
          // const LinearProgressIndicator(),
          // Container(
          //     margin: const EdgeInsets.only(top: 20),
          //     alignment: Alignment.centerRight,
          //     child: Text('- Pirthe Ltd.',
          //         style: titilliumRegular.copyWith(
          //             fontSize: 10, color: Colors.blueGrey))),
        ),
      ],
    );
  }
}
