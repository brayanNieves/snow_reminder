import 'package:flutter/material.dart';
import 'package:sow_remember/screen/create_word_screen.dart';
import 'package:sow_remember/screen/home_menu.dart';
import 'package:sow_remember/routers.dart';
import 'package:sow_remember/screen/login/login_screen.dart';
import 'package:sow_remember/screen/login/sign_up_screen.dart';
import 'package:sow_remember/screen/splash_screen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed
    //print('settings.name ${settings.name}');
    final args = settings.arguments;
    switch (settings.name) {
      case Routers.defaultRoute:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case Routers.home:
        return MaterialPageRoute(builder: (_) => const HomeMenuScreen());
      case Routers.createWord:
        return MaterialPageRoute(builder: (_) => const CreateWordScreen());
      case Routers.signUp:
        return MaterialPageRoute(builder: (_) => const SignUpScreen());
      case Routers.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      default:
        // If there is no such named route in the switch statement, e.g. /third
        return MaterialPageRoute(
            builder: (_) =>
                const Scaffold(body: SafeArea(child: Text('Route Error'))));
    }
  }
}
