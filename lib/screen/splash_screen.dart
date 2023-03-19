import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:sow_remember/routers.dart';
import 'package:sow_remember/service/user_service.dart';
import 'package:sow_remember/bloc/user_bloc.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      context.read<UserBloc>().init().then((value) {
        Navigator.pushReplacementNamed(
            context, UserService.isUserLogged() ? Routers.noteList : Routers.login);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Lottie.asset(
        'assets/animations/loading.json',
        width: 150.0,
        height: 150.0,
      )),
    );
  }
}
