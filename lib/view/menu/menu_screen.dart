import 'package:flutter/material.dart';
import 'package:light_fair_bd_new/provider/auth_provider.dart';
import 'package:light_fair_bd_new/provider/theme_provider.dart';
import 'package:light_fair_bd_new/util/color_resources.dart';
import 'package:light_fair_bd_new/util/dimensions.dart';
import 'package:light_fair_bd_new/util/images.dart';
import 'package:light_fair_bd_new/util/theme/custom_themes.dart';
import 'package:light_fair_bd_new/view/auth/login_screen.dart';
import 'package:light_fair_bd_new/view/home/home.dart';
import 'package:light_fair_bd_new/view/menu/settings_screen.dart';
import 'package:provider/provider.dart';

class MenuScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth < 768) {
        return menuContainer(context);
      } else {
        return menuContainer(context,
            width: constraints.maxWidth * 0.40, isResponsive: true);
      }
    });
  }

  menuContainer(BuildContext context,
      {double? width, bool isResponsive = false}) {
    return Drawer(
      child: Container(
        width: width ?? MediaQuery.of(context).size.width * 0.80,
        child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Consumer<UserConfigurationProvider>(
                builder: (context, authProvider, child) => Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(color: Colors.green),
                  padding: EdgeInsets.symmetric(vertical: 50),
                  child: Column(

                      // mainAxisSize: MainAxisSize.max,
                      // mainAxisAlignment: MainAxisAlignment.end,

                      children: [
                        CircleAvatar(
                          radius: 28,
                          child: Center(
                            child: Text(
                              '${authProvider.jwtTokenModel?.hcname![0]}',
                              textAlign: TextAlign.center,
                              style: chakraPetch.copyWith(
                                  fontSize: 30, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),

                        // SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.only(
                              right: 8.0, top: 8, bottom: 6),
                          child: Text(
                            '  ${authProvider.jwtTokenModel?.hcname ?? ''}',
                            textAlign: TextAlign.center,
                            style: chakraPetch.copyWith(
                                color: Colors.white,
                                fontSize: isResponsive ? 20 : 17),
                          ),
                        ),
                        Text(
                          'USER ID : ${authProvider.jwtTokenModel?.hccode ?? ''} ',

                          //'${authProvider.userConfigModel!.empInfo!.name}',
                          textAlign: TextAlign.center,
                          style: chakraPetch.copyWith(
                            fontSize: 15,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          'Designation : ${authProvider.jwtTokenModel?.designation ?? ''} ',

                          //'${authProvider.userConfigModel!.empInfo!.name}',
                          textAlign: TextAlign.center,
                          style: chakraPetch.copyWith(
                            fontSize: 15,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Device Model : ${authProvider.deviceName} ',

                          //'${authProvider.userConfigModel!.empInfo!.name}',
                          textAlign: TextAlign.center,
                          style: chakraPetch.copyWith(
                            fontSize: 15,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),

                        Text(
                          // 'Emp-ID: ${authProvider.userConfigModel!.empId}',
                          '',
                          style: robotoRegular.copyWith(
                              color: Colors.white,
                              fontSize: isResponsive ? 17 : 14),
                        ),
                      ]),
                ),
              ),
              Expanded(
                child: Container(
                  color: !Provider.of<ThemeProvider>(context).darkTheme
                      ? Colors.white
                      : Colors.grey.shade800,
                  child: Column(children: [
                    ListTile(
                      onTap: () {
                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (_) => HomeScreen()));
                      },
                      leading: Icon(Icons.home_outlined,
                          color: !Provider.of<ThemeProvider>(context).darkTheme
                              ? ColorResources.black
                              : Colors.white,
                          size: isResponsive ? 30 : 22),
                      title: Text('Home',
                          style: chakraPetch.copyWith(
                            fontSize:
                                isResponsive ? 20 : Dimensions.FONT_SIZE_LARGE,
                            color:
                                !Provider.of<ThemeProvider>(context).darkTheme
                                    ? ColorResources.black
                                    : Colors.white,
                          )),
                    ),
                    // ListTile(
                    //   onTap: () {
                    //     Navigator.push(context, MaterialPageRoute(builder: (context) {
                    //       return const OrderHistoryScreen();
                    //     }));
                    //   },
                    //   leading: Icon(FontAwesomeIcons.clockRotateLeft,
                    //       color: !Provider.of<ThemeProvider>(context).darkTheme ? ColorResources.black : Colors.white,
                    //       size: isResponsive ? 30 : 22),
                    //   title: Text(
                    //     'PURCHASE HISTORY',
                    //     style: chakraPetch.copyWith(
                    //       fontSize: isResponsive ? 20 : Dimensions.FONT_SIZE_LARGE,
                    //       color: !Provider.of<ThemeProvider>(context).darkTheme ? ColorResources.black : Colors.white,
                    //     ),
                    //   ),
                    // ),
                    ListTile(
                      title: Text(
                        'Settings',
                        style: chakraPetch.copyWith(
                          fontSize:
                              isResponsive ? 20 : Dimensions.FONT_SIZE_LARGE,
                          color: !Provider.of<ThemeProvider>(context).darkTheme
                              ? ColorResources.black
                              : Colors.white,
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => const SettingsScreen()));
                      },
                      leading: Icon(
                        Icons.settings,
                        color: !Provider.of<ThemeProvider>(context).darkTheme
                            ? ColorResources.black
                            : Colors.white,
                      ),
                    ),
                    ListTile(
                      onTap: () {
                        Provider.of<UserConfigurationProvider>(context,
                                listen: false)
                            .clearToken();
                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (_) => LoginScreen()));
                      },
                      leading: Icon(Icons.logout,
                          color: !Provider.of<ThemeProvider>(context).darkTheme
                              ? ColorResources.black
                              : Colors.white,
                          size: isResponsive ? 30 : 20),
                      title: Text('Logout',
                          style: chakraPetch.copyWith(
                              color:
                                  !Provider.of<ThemeProvider>(context).darkTheme
                                      ? ColorResources.black
                                      : Colors.white,
                              fontSize: isResponsive
                                  ? 20
                                  : Dimensions.FONT_SIZE_LARGE)),
                    ),
                    // SizedBox(
                    //   height: MediaQuery.of(context).size.height / 2.9,
                    // ),

                    Expanded(
                      child: Align(
                        alignment: FractionalOffset.bottomCenter,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              width: double.infinity,
                              color: Colors.white,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Powered By: ',
                                    style: titilliumRegular.copyWith(
                                      fontSize: 10,
                                      color: Colors.blueGrey,
                                    ),
                                  ),
                                  Image.asset(
                                    Images.pirthi_logo,
                                    width: isResponsive ? 30 : 20,
                                    height: isResponsive ? 30 : 20,
                                    fit: BoxFit.scaleDown,
                                  ),
                                  Text(
                                    'Pirthe Limited.',
                                    textAlign: TextAlign.center,
                                    style: chakraPetch.copyWith(
                                        fontSize: 13, color: Colors.blueGrey),
                                  ),
                                ],
                              ),
                            ),
                            Divider(),
                            // Container(
                            //   width: double.infinity,
                            //   color: Colors.white,
                            //   child: Row(
                            //     mainAxisAlignment: MainAxisAlignment.center,
                            //     children: [
                            //       Text(
                            //         'Developed By: ',
                            //         style: chakraPetch.copyWith(
                            //             fontSize: 10, color: Colors.blueGrey),
                            //       ),
                            //       Image.asset(
                            //         Images.asit_logo,
                            //         width: isResponsive ? 50 : 20,
                            //         height: isResponsive ? 50 : 20,
                            //         fit: BoxFit.scaleDown,
                            //       ),
                            //       Text(
                            //         'ASIT Services Limited.',
                            //         style: chakraPetch.copyWith(
                            //             fontSize: 13, color: Colors.blueGrey),
                            //       ),
                            //     ],
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    ),
                  ]),
                ),
              ),
            ]),
      ),
    );
  }
}
