import 'package:flutter/material.dart';
import 'package:light_fair_bd_new/provider/auth_provider.dart';
import 'package:light_fair_bd_new/provider/theme_provider.dart';
import 'package:light_fair_bd_new/util/dimensions.dart';
import 'package:light_fair_bd_new/util/images.dart';
import 'package:light_fair_bd_new/util/theme/custom_themes.dart';
import 'package:light_fair_bd_new/view/base_widget/custom_app_bar.dart';
import 'package:light_fair_bd_new/view/home/menu_card.dart';
import 'package:light_fair_bd_new/view/menu/menu_screen.dart';
import 'package:marquee/marquee.dart';
import 'package:provider/provider.dart';

import '../../util/app_constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    _getorR();
    //_georR();
  }

  _getorR() async {
    await Provider.of<UserConfigurationProvider>(context, listen: false)
        .getOrderStatus("A");
  }

  // _georR() async {
  //   await Provider.of<UserConfigurationProvider>(context, listen: false).rejectedStatus();
  // }

  @override
  Widget build(BuildContext context) {
    //  Provider.of<AuthProvider>(context, listen: false).getCompanyBranchInfo();
    Provider.of<UserConfigurationProvider>(context, listen: false)
        .getTodayOrderNotif();
    // Provider.of<UserConfigurationProvider>(context, listen: false).getTodayOrderNotif();

    GlobalKey<ScaffoldState> drawerKey = GlobalKey();
    return Scaffold(
      backgroundColor: Provider.of<ThemeProvider>(context).darkTheme
          ? Colors.grey.shade800
          : const Color.fromARGB(255, 238, 246, 230),
      key: drawerKey,
      appBar: CustomAppBar(
        drawerKey: drawerKey,
        isHomeScreen: true,
        isBackButtonExist: false,
      ),
      //appBar: AppBar(),
      endDrawer: MenuScreen(),
      body: Consumer<UserConfigurationProvider>(
          builder: (context, authProvider, child) {
        return SafeArea(
          child: Column(
            children: [
              Expanded(
                child: LayoutBuilder(
                  builder: (context, layoutBuilder) {
                    return GridView.builder(
                        padding: const EdgeInsets.all(
                            Dimensions.PADDING_SIZE_DEFAULT),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisExtent: 130,
                          crossAxisSpacing: 10.0,
                          mainAxisSpacing: 10.0,
                        ),
                        itemCount: authProvider.getMenuList.length,
                        itemBuilder: (BuildContext ctx, index) {
                          return Stack(
                            children: [
                              MenuCard(
                                routePageName:
                                    authProvider.getMenuList[index].routeName,
                                color: authProvider.getMenuList[index].color,
                                imgColor:
                                    authProvider.getMenuList[index].imgColor,
                                imageUrl: authProvider.getMenuList[index].icon,
                                title: authProvider.getMenuList[index].menuName,
                              ),
                              authProvider.getMenuList[index].menuName ==
                                      "Pending Order"
                                  ? Positioned(
                                      right: 3,
                                      top: 3,
                                      child: CircleAvatar(
                                        radius: 10,
                                        backgroundColor: Colors.red,
                                        child: Text(
                                          '${authProvider.orderTodateList?.length}',
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w700),
                                        ),
                                      ),
                                    )
                                  // : authProvider.getMenuList[index].menuName == "Order Status"
                                  //     ? Positioned(
                                  //         right: 3,
                                  //         top: 3,
                                  //         child: CircleAvatar(
                                  //             radius: 10,
                                  //             backgroundColor: Colors.red,
                                  //             child: Text(
                                  //               '${authProvider.approvedList?.length}',
                                  //               style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700),
                                  //             )),
                                  //       )
                                  //     : authProvider.getMenuList[index].menuName == "Order"
                                  //         ? Positioned(
                                  //             right: 3,
                                  //             top: 3,
                                  //             child: CircleAvatar(
                                  //                 radius: 10,
                                  //                 backgroundColor: Colors.red,
                                  //                 child: Text(
                                  //                   '${authProvider.rejectedList?.length}',
                                  //                   style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700),
                                  //                 )),
                                  //           )
                                  : const SizedBox.shrink(),
                            ],
                          );
                        });
                  },
                ),
              ),
              authProvider.jwtTokenModel!.hccode == AppConstants.adminHccode ||
                      authProvider.jwtTokenModel!.hccode ==
                          AppConstants.lfbdEhsHccode ||
                      authProvider.jwtTokenModel!.hccode ==
                          AppConstants.lfbdRfsHccode ||
                      authProvider.jwtTokenModel!.hccode ==
                          AppConstants.superAdminHccode ||
                      authProvider.jwtTokenModel!.hccode ==
                          AppConstants.monowarHccode
                  ? MarqueeText(
                      text:
                          'You approved ${authProvider.approvedList!.length} order.')
                  : MarqueeText(
                      text:
                          'Your order has been approved. You have ${authProvider.approvedList!.length} approved order.'),
            ],
          ),
        );
      }),
    );
  }

  Container titleContainer(
      BuildContext context, GlobalKey<ScaffoldState> _drawerKey,
      {double topSize = Dimensions.PADDING_SIZE_DEFAULT,
      double bottomSize = Dimensions.PADDING_SIZE_DEFAULT,
      double leftSize = Dimensions.PADDING_SIZE_DEFAULT,
      double rightSize = Dimensions.PADDING_SIZE_DEFAULT,
      bool isResponsive = false}) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        //color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
      ),
      padding: EdgeInsets.only(
          left: leftSize, right: rightSize, top: topSize, bottom: bottomSize),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image.asset(Images.light_fair_logo,
                    //     width: isResponsive ? 70 : 50,
                    //     height: isResponsive ? 70 : 50,
                    //     fit: BoxFit.scaleDown,
                    //     color: Colors.white),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 12),
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Image.asset(
                              Images.spl2,
                              width: MediaQuery.of(context).size.height / 4,
                            ),
                          ),
                          // appTitleText(fontsize: 24),
                          // Text(
                          //   'Good ${(DateTime.now().hour > 5 && DateTime.now().hour < 12) ? 'Morning' : (DateTime.now().hour >= 12 && DateTime.now().hour < 17) ? 'Afternoon' : 'Evening'}',
                          //   style: robotoRegular.copyWith(color: Colors.white, fontSize: isResponsive ? 18 : 14),
                          // ),
                          // SizedBox(height: 5),
                          // Text('Light Fair BD',
                          //     style: robotoBold.copyWith(
                          //         color: Colors.white,
                          //         fontSize: isResponsive ? 18 : 14)),

                          //Text('GM(MIS)-BEPZA H/O', style: titilliumRegular.copyWith(color: Colors.white)),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  _drawerKey.currentState!.openEndDrawer();
                },
                child: Container(
                  width: isResponsive ? 50 : 40,
                  height: isResponsive ? 50 : 40,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: const Color.fromARGB(255, 22, 21, 21))),
                  child: Icon(
                    Icons.menu,
                    color: Colors.black,
                    size: isResponsive ? 30 : 24,
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

class MarqueeText extends StatelessWidget {
  String? text;
  MarqueeText({super.key, this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      color: Colors.white,
      child: Marquee(
        text: text.toString(),
        style: poppinRegular.copyWith(
            fontWeight: FontWeight.bold, color: Colors.green, fontSize: 16),
        scrollAxis: Axis.horizontal,
        crossAxisAlignment: CrossAxisAlignment.start,
        blankSpace: 20.0,
        velocity: 80.0,
        pauseAfterRound: const Duration(seconds: 1),
        startPadding: 10.0,
        accelerationDuration: const Duration(seconds: 1),
        accelerationCurve: Curves.linear,
        decelerationDuration: const Duration(milliseconds: 500),
        decelerationCurve: Curves.easeOut,
      ),
      // child: Text('You Have  ${authProvider.approvedList!.length} approved order'),
    );
  }
}
