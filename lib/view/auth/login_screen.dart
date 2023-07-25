import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:light_fair_bd_new/data/datasource/model/user_model.dart';
import 'package:light_fair_bd_new/localization/language_constraints.dart';
import 'package:light_fair_bd_new/provider/auth_provider.dart';
import 'package:light_fair_bd_new/provider/mobil_feed_provider.dart';
import 'package:light_fair_bd_new/util/background_img.dart';
import 'package:light_fair_bd_new/util/color_resources.dart';
import 'package:light_fair_bd_new/util/images.dart';
import 'package:light_fair_bd_new/util/show_custom_snakbar.dart';
import 'package:light_fair_bd_new/util/theme/custom_themes.dart';
import 'package:light_fair_bd_new/view/home/home.dart';
import 'package:light_fair_bd_new/view/menu/settings_screen.dart';
import 'package:provider/provider.dart';

import '../../provider/theme_provider.dart';
import '../../util/dimensions.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final userIdController = TextEditingController();
  final passwordController = TextEditingController();
  FocusNode userIdFocusNode = FocusNode();

  FocusNode passwordFocusNode = FocusNode();

  bool isChecked = false;
  final _formKey = GlobalKey<FormState>();
  bool _obscureText = true;
  final FocusNode _passwordFocusNode = FocusNode();
  User loginBody = User();
  String? deviceID = 'samsung';

  @override
  void initState() {
    userIdController.text =
        Provider.of<UserConfigurationProvider>(context, listen: false)
            .getUserEmail();
    passwordController.text =
        Provider.of<UserConfigurationProvider>(context, listen: false)
            .getUserPassword();
    super.initState();
  }

  _login(
    UserConfigurationProvider authProvider,
  ) {
    if (userIdController.text.isEmpty) {
      showCustomSnackBar('Please Enter your User ID', context);
    } else if (passwordController.text.isEmpty) {
      showCustomSnackBar('Please Enter your password', context);
    } else if (passwordController.text.length < 3) {
      showCustomSnackBar(
          'Password should be at least 3 character long', context);
    }
    if (authProvider.isActiveRememberMe) {
      authProvider.saveUserNumberAndPassword(
        userIdController.text,
        passwordController.text,
      );
    } else {
      authProvider.clearUserEmailAndPassword();
    }

    authProvider
        .login(
            User(
              userId: userIdController.text.trim(),
              password: passwordController.text.trim(),
              terminalID: authProvider.deviceName,
            ),
            context)
        .then((value) {
      if (value.isSuccess) {
        // authProvider.getTodayOrderNotif();
        authProvider.jwtTokenModel!.istokenstr!
            ? Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (_) => const HomeScreen(),
                ),
              )
            : showCustomSnackBar(
                'User Name or Password not correct',
                context,
                isError: true,
              );
        //  : showCustomSnackBar('Invalid Credential', context);
      } else {
        showCustomSnackBar(value.message, context);
      }
    });
  }

  @override
  void dispose() {
    userIdController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<UserConfigurationProvider>(context, listen: false).readFile(
      context,
      const AppUpdateDialog(),
    );

    final size = MediaQuery.of(context).size;
    print('size : ${size.width}');
    return Stack(
      children: [
        const BackgroungImage(),
        Scaffold(
          backgroundColor: Provider.of<ThemeProvider>(context).darkTheme
              ? Colors.grey.shade600
              : Colors.transparent,
          //backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            //  physics: BouncingScrollPhysics(),
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 100),
                        child: SizedBox(
                          height: 150,
                          //color: Provider.of<ThemeProvider>(context).darkTheme ? Colors.white : Colors.black,
                          child: Center(
                            child: Image.asset(
                              Images.light_fair_logo,
                              width: Dimensions.fullWidth(context) / 1.2,
                            ),
                          ),
                        ),
                      ),
                      Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: TextFormField(
                                controller: userIdController,
                                scrollPadding:
                                    const EdgeInsets.only(bottom: 40),
                                key: const ValueKey(
                                  'userId',
                                ),
                                validator: (value) {
                                  if (value!.isEmpty || !value.contains('@')) {
                                    return 'Please Enter your user id';
                                  }
                                  return null;
                                },
                                textInputAction: TextInputAction.next,
                                onEditingComplete: () => FocusScope.of(context)
                                    .requestFocus(_passwordFocusNode),
                                keyboardType: TextInputType.text,
                                textCapitalization:
                                    TextCapitalization.characters,
                                decoration: InputDecoration(
                                    border: const OutlineInputBorder(),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Provider.of<ThemeProvider>(
                                                      context)
                                                  .darkTheme
                                              ? Colors.white
                                              : Colors.blue,
                                          width: 2.0),
                                      borderRadius: BorderRadius.circular(4.0),
                                    ),
                                    filled: true,
                                    prefixIcon: Icon(
                                      Icons.person,
                                      color: Provider.of<ThemeProvider>(context)
                                              .darkTheme
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                    fillColor:
                                        Provider.of<ThemeProvider>(context)
                                                .darkTheme
                                            ? Colors.grey
                                            : Colors.white,
                                    labelText:
                                        getTranslated("user_id", context),
                                    labelStyle: TextStyle(
                                      color: Provider.of<ThemeProvider>(context).darkTheme
                                          ? Colors.white
                                          : Colors.black45,
                                    )),
                                onSaved: (value) {
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Consumer<UserConfigurationProvider>(
                                  builder: (context, authpr, child) {
                                return TextFormField(
                                  controller: passwordController,
                                  obscureText: _obscureText,
                                  scrollPadding: EdgeInsets.only(
                                      bottom: MediaQuery.of(context)
                                              .viewInsets
                                              .bottom +
                                          16 * 4),
                                  key: const ValueKey(
                                    'password',
                                  ),
                                  validator: (value) {
                                    if (value!.isEmpty || value.length < 7) {
                                      return 'Please Enter your password';
                                    }
                                    return null;
                                  },
                                  focusNode: _passwordFocusNode,
                                  keyboardType: TextInputType.visiblePassword,
                                  onEditingComplete: () {
                                    if (passwordController.text.isEmpty) {
                                      showCustomSnackBar(
                                          'Enter Password', context);
                                    } else if (passwordController.text.length <
                                        3) {
                                      showCustomSnackBar(
                                          'Password Length should be at least 3 characters long',
                                          context);
                                    } else {
                                      authpr.getInfo();
                                      //authpr.getTodayOrderNotif();

                                      _login(
                                        authpr,
                                      );
                                    }
                                  },
                                  // onEditingComplete: _formSubmit,
                                  decoration: InputDecoration(
                                    border: const OutlineInputBorder(),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Provider.of<ThemeProvider>(
                                                      context)
                                                  .darkTheme
                                              ? Colors.white
                                              : Colors.blue,
                                          width: 2.0),
                                      borderRadius: BorderRadius.circular(4.0),
                                    ),
                                    filled: true,
                                    prefixIcon: Icon(Icons.lock,
                                        color:
                                            Provider.of<ThemeProvider>(context)
                                                    .darkTheme
                                                ? Colors.white
                                                : Colors.black),
                                    suffixIcon: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _obscureText = !_obscureText;
                                        });
                                      },
                                      child: Icon(
                                        _obscureText
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                      ),
                                    ),
                                    labelText:
                                        getTranslated("password", context),
                                    labelStyle: TextStyle(
                                      color: Provider.of<ThemeProvider>(context)
                                              .darkTheme
                                          ? Colors.white
                                          : Colors.black45,
                                    ),
                                    fillColor:
                                        Provider.of<ThemeProvider>(context)
                                                .darkTheme
                                            ? Colors.grey
                                            : Colors.white,
                                  ),
                                  onSaved: (value) {
                                  },
                                );
                              }),
                            ),
                          ],
                        ),
                      ),
                      Consumer<UserConfigurationProvider>(
                          builder: (context, authProvider, child) => InkWell(
                                onTap: () {
                                  authProvider.toggleRememberMe();
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(14.0),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 18,
                                        height: 18,
                                        decoration: BoxDecoration(
                                            color: authProvider
                                                    .isActiveRememberMe
                                                ? (Provider.of<ThemeProvider>(
                                                            context)
                                                        .darkTheme
                                                    ? Colors.white
                                                    : Colors.purple)
                                                : Colors.white,
                                            border: Border.all(
                                                color: authProvider
                                                        .isActiveRememberMe
                                                    ? Colors.transparent
                                                    : Colors.grey),
                                            borderRadius:
                                                BorderRadius.circular(3)),
                                        child: authProvider.isActiveRememberMe
                                            ? Icon(
                                                Icons.done,
                                                color:
                                                    Provider.of<ThemeProvider>(
                                                                context)
                                                            .darkTheme
                                                        ? Colors.black
                                                        : Colors.white,
                                                size: 17,
                                              )
                                            : const SizedBox.shrink(),
                                      ),
                                      const SizedBox(
                                          width: Dimensions.PADDING_SIZE_SMALL),
                                      Text(
                                        getTranslated("remember_me", context),
                                        style: poppinRegular.copyWith(
                                          color: Provider.of<ThemeProvider>(
                                                      context)
                                                  .darkTheme
                                              ? Colors.white
                                              : Colors.black,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              )),
                      // Consumer<AuthProvider>(
                      //     builder: (context, authProvider, child) {
                      //   return InkWell(
                      //     onTap: () => authProvider.toggleRememberMe(),
                      //     child: Row(
                      //       children: [
                      //         Checkbox(
                      //             value: isChecked,
                      //             onChanged: (bool? val) {
                      //               setState(() {
                      //                 isChecked = val!;
                      //               });
                      //             }),
                      //         Text(
                      //           'Remember Me',
                      //           style: TextStyle(fontWeight: FontWeight.w500),
                      //         ),
                      //       ],
                      //     ),
                      //   );
                      // }),
                      Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: ConstrainedBox(
                            constraints: BoxConstraints.tightFor(
                                width: MediaQuery.of(context).size.width / 1.3,
                                height: 50),
                            child: Consumer<UserConfigurationProvider>(
                                builder: (context, authProvider, child) {
                              return !authProvider.isLoading
                                  ? Consumer<UserConfigurationProvider>(
                                      builder: (context, authpr, child) {
                                      return CupertinoButton(
                                          color: Colors.indigo,
                                          child: Text(
                                            getTranslated("login", context),
                                            style: TextStyle(
                                              letterSpacing: 1,
                                              color: Provider.of<ThemeProvider>(
                                                          context)
                                                      .darkTheme
                                                  ? Colors.black
                                                  : Colors.white,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 20,
                                            ),
                                          ),
                                          onPressed: () async {
                                            authpr.getInfo();
                                            _login(
                                              authProvider,
                                            );
                                         
                                          });
                                      // return ElevatedButton(
                                      //   style: ButtonStyle(
                                      //     elevation:
                                      //         MaterialStateProperty.all(4),
                                      //     backgroundColor:
                                      //         MaterialStateProperty.all(
                                      //             Provider.of<ThemeProvider>(
                                      //                         context)
                                      //                     .darkTheme
                                      //                 ? Colors.white
                                      //                 : Colors.indigo),
                                      //     shape: MaterialStateProperty.all<
                                      //         RoundedRectangleBorder>(
                                      //       RoundedRectangleBorder(
                                      //         borderRadius:
                                      //             BorderRadius.circular(12),
                                      //         side: BorderSide(
                                      //             color: Colors.black),
                                      //       ),
                                      //     ),
                                      //   ),
                                      //   onPressed: () async {
                                      //     //  authpr.readFile(context,);
                                      //     authpr.getInfo();
                                      //     //authpr.getTodayOrderNotif();
                                      //     //   await  authpr.getOrderHistoryInfo("%",DateConverter.formatDateIOS(DateTime.now().toIso8601String()),DateConverter.formatDateIOS(DateTime.now().toIso8601String()),context);

                                      //     // Navigator.of(context).pushReplacement(
                                      //     //     MaterialPageRoute(
                                      //     //         builder: (_) =>
                                      //     //             HomeScreen()));
                                      //     _login(authProvider);
                                      //   },
                                      //   child: Text(
                                      //     getTranslated("login", context),
                                      //     style: TextStyle(
                                      //       letterSpacing: 1,
                                      //       color: Provider.of<ThemeProvider>(
                                      //                   context)
                                      //               .darkTheme
                                      //           ? Colors.black
                                      //           : Colors.white,
                                      //       fontWeight: FontWeight.w500,
                                      //       fontSize: 16,
                                      //     ),
                                      //   ),
                                      // );
                                    })
                                  : Center(
                                      child: CircularProgressIndicator(
                                        valueColor: AlwaysStoppedAnimation<
                                                Color>(
                                            ColorResources.getPrimary(context)),
                                      ),
                                    );
                            }),
                          ),
                        ),
                      ),
                      Consumer<MobilFeedProvider>(
                          builder: (context, mp, child) {
                        return TextButton(
                          onPressed: () async {
                            await mp.searchUriFromInternet(isLogin: true);
                          },
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: getTranslated('need_help', context),
                                  style: TextStyle(
                                    color: Provider.of<ThemeProvider>(context)
                                            .darkTheme
                                        ? Colors.white
                                        : Colors.purple,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                TextSpan(
                                  text: getTranslated('call_support', context),
                                  style: TextStyle(
                                    color: Provider.of<ThemeProvider>(context)
                                            .darkTheme
                                        ? Colors.white
                                        : Colors.purple,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                      // TextButton(
                      //   onPressed: () {},
                      //   child: Text(
                      //     'Continue as a Guest',
                      //     style: TextStyle(
                      //       color: Colors.black,
                      //       fontSize: 15,
                      //       fontWeight: FontWeight.w500,
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  // Expanded(
                  //   //flex: 3,
                  //   child: Column(
                  //     mainAxisAlignment: MainAxisAlignment.end,
                  //     children: [
                  //       Container(
                  //         width: double.infinity,
                  //         color: Provider.of<ThemeProvider>(context).darkTheme
                  //             ? Colors.grey.shade600
                  //             : Colors.white,
                  //         child: Row(
                  //           mainAxisAlignment: MainAxisAlignment.center,
                  //           children: [
                  //             Text(
                  //               'Powered By: ',
                  //               style: titilliumRegular.copyWith(
                  //                 fontSize: 10,
                  //                 color: Provider.of<ThemeProvider>(context)
                  //                         .darkTheme
                  //                     ? Colors.white
                  //                     : Colors.blueGrey,
                  //               ),
                  //             ),
                  //             Image.asset(
                  //               Images.pirthi_logo,
                  //               width: 30,
                  //               height: 20,
                  //               fit: BoxFit.scaleDown,
                  //             ),
                  //             Text(
                  //               'Pirthe Limited.',
                  //               textAlign: TextAlign.center,
                  //               style: titilliumRegular.copyWith(
                  //                   fontSize: 13,
                  //                   color: Provider.of<ThemeProvider>(context)
                  //                           .darkTheme
                  //                       ? Colors.white
                  //                       : Colors.blueGrey),
                  //             ),
                  //           ],
                  //         ),
                  //       ),
                  //       Container(
                  //           height: 10,
                  //           color: Provider.of<ThemeProvider>(context).darkTheme
                  //               ? Colors.grey.shade600
                  //               : Colors.white,
                  //           child: Divider()),
                  //       Container(
                  //         width: double.infinity,
                  //         //height: 40,
                  //         color: Provider.of<ThemeProvider>(context).darkTheme
                  //             ? Colors.grey.shade600
                  //             : Colors.white,
                  //         child: Row(
                  //           mainAxisAlignment: MainAxisAlignment.center,
                  //           children: [
                  //             Text(
                  //               'Developed By: ',
                  //               style: titilliumRegular.copyWith(
                  //                 fontSize: 10,
                  //                 color: Provider.of<ThemeProvider>(context)
                  //                         .darkTheme
                  //                     ? Colors.white
                  //                     : Colors.blueGrey,
                  //               ),
                  //             ),
                  //             Image.asset(
                  //               Images.asit_logo,
                  //               width: 50,
                  //               height: 20,
                  //               fit: BoxFit.scaleDown,
                  //             ),
                  //             Text(
                  //               'ASIT Services Limited.',
                  //               style: titilliumRegular.copyWith(
                  //                   fontSize: 10,
                  //                   color: Provider.of<ThemeProvider>(context)
                  //                           .darkTheme
                  //                       ? Colors.white
                  //                       : Colors.blueGrey),
                  //             ),
                  //           ],
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  // Expanded(
                  //   child: Align(
                  //     alignment: FractionalOffset.bottomCenter,
                  //     child: Row(
                  //       mainAxisAlignment: MainAxisAlignment.start,
                  //       children: [
                  //         Expanded(
                  //           flex: 3,
                  //           child: Container(
                  //             color: Colors.indigo,
                  //             height: 50,
                  //             child: Center(
                  //               child: Text(
                  //                 'www.lightfairbd.com',
                  //                 textAlign: TextAlign.center,
                  //                 style: TextStyle(
                  //                     color: Colors.white,
                  //                     fontWeight: FontWeight.w500),
                  //               ),
                  //             ),
                  //           ),
                  //         ),
                  //         Expanded(
                  //           flex: 4,
                  //           child: Container(
                  //             color: Colors.grey.shade800,
                  //             height: 50,
                  //             child: Padding(
                  //               padding: const EdgeInsets.all(8.0),
                  //               child: Column(
                  //                 crossAxisAlignment: CrossAxisAlignment.start,
                  //                 children: [
                  //                   Text(
                  //                     'Contact no. 255555656',
                  //                     style: TextStyle(color: Colors.white),
                  //                   ),
                  //                   Text(
                  //                     'Contact no. 01154456456',
                  //                     style: TextStyle(color: Colors.white),
                  //                   )
                  //                 ],
                  //               ),
                  //             ),
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
