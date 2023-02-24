import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CustomLoading extends StatelessWidget {
  const CustomLoading({Key? key}) : super(key: key);

  static void show(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      useSafeArea: false,
      barrierColor: Colors.black54,
      builder: (context) {
        return const CustomLoading();
      },
    );
  }

  static void close(BuildContext context) {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Lottie.asset(
      'assets/animations/loading.json',
      width: 150.0,
      height: 150.0,
    ));
  }
}
