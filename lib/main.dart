import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:light_fair_bd_new/provider/auth_provider.dart';
import 'package:light_fair_bd_new/localization/app_localization.dart';
import 'package:light_fair_bd_new/provider/FormProvider.dart';
import 'package:light_fair_bd_new/provider/employee_provider.dart';
import 'package:light_fair_bd_new/provider/localization_provider.dart';
import 'package:light_fair_bd_new/provider/mobil_feed_provider.dart';
import 'package:light_fair_bd_new/provider/order_provider.dart';
import 'package:light_fair_bd_new/provider/theme_provider.dart';
import 'package:light_fair_bd_new/util/app_constants.dart';
import 'package:light_fair_bd_new/util/theme/dark_theme.dart';
import 'package:light_fair_bd_new/util/theme/light_theme.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:light_fair_bd_new/view/splash/splash_screen.dart';
import 'package:provider/provider.dart';
import 'di_container.dart' as di;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  await di.init();

  // SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky, overlays: [
  //   SystemUiOverlay.top
  // ]).then((_) {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => di.sl<UserConfigurationProvider>()),
    ChangeNotifierProvider(create: (context) => di.sl<ThemeProvider>()),
    ChangeNotifierProvider(create: (context) => di.sl<OrderProvider>()),
    ChangeNotifierProvider(create: ((context) => di.sl<EmployeeProvider>())),
    ChangeNotifierProvider(create: ((context) => di.sl<MobilFeedProvider>())),
    ChangeNotifierProvider(create: ((context) => di.sl<FormProvider>())),
    ChangeNotifierProvider(create: (context) => di.sl<LocalizationProvider>()),
  ], child: const MyApp()));
  // }
  // );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Locale> _locals = [];
    AppConstants.languages.forEach((language) {
      _locals.add(Locale(language.languageCode!, language.countryCode));
    });
    return MaterialApp(
      // builder: (context, child) {
      //   return ResponsiveWrapper.builder(child, maxWidth: 480, minWidth: 480, defaultScale: true, breakpoints: [
      //     ResponsiveBreakpoint.resize(480, name: MOBILE),
      //     // ResponsiveBreakpoint.autoScale(
      //     //   600,
      //     //   name: MOBILE,
      //     // ),
      //   ]);
      // },
      debugShowCheckedModeBanner: false,
      title: 'Light Fair BD',
      theme: Provider.of<ThemeProvider>(context).darkTheme ? dark : light,
      locale: Provider.of<LocalizationProvider>(context).locale,
      localizationsDelegates: const [
        AppLocalization.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: _locals,
      home: const SplashScreen(),
      //  onGenerateRoute: (settings) => generateRoute(settings),
    );
  }
}
