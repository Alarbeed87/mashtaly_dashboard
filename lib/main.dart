import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mashtaly_dashboard/constants/style.dart';
import 'package:mashtaly_dashboard/controllers/menu_controller.dart'
    as menu_controller;
import 'package:mashtaly_dashboard/controllers/navigation_controller.dart';
import 'package:mashtaly_dashboard/layout.dart';
import 'package:mashtaly_dashboard/pages/404/error.dart';
import 'package:mashtaly_dashboard/pages/authentication/authentication.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'Animations/splash_screen.dart';
import 'firebase_options.dart';
import 'routing/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Get.put(menu_controller.MenuController());
  Get.put(NavigationController());
  runApp(SplashScreenApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    late String route;
    try {
      FirebaseAuth.instance.currentUser!.uid;
      route = overviewPageRoute;
    } catch (e) {
      route = authenticationPageRoute;
    }
    return GetMaterialApp(
      initialRoute: route,
      unknownRoute: GetPage(
          name: '/not-found',
          page: () => const PageNotFound(),
          transition: Transition.fadeIn),
      getPages: [
        GetPage(
            name: rootRoute,
            page: () {
              return SiteLayout();
            }),
        GetPage(
            name: authenticationPageRoute,
            page: () => const AuthenticationPage()),
      ],
      debugShowCheckedModeBanner: false,
      title: 'Dashboard',
      theme: ThemeData(
        scaffoldBackgroundColor: light,
        textTheme: GoogleFonts.mulishTextTheme(Theme.of(context).textTheme)
            .apply(bodyColor: Colors.black),
        pageTransitionsTheme: const PageTransitionsTheme(builders: {
          TargetPlatform.iOS: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
        }),
        primarySwatch: Colors.blue,
      ),
      // home: AuthenticationPage(),
    );
  }
}

//8/12/2023--
class SplashScreenApp extends StatelessWidget {
  const SplashScreenApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(
        onSplashFinished: () {
          runApp(const MyApp());
        },
      ),
    );
  }
}
