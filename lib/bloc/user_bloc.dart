import 'package:flutter/cupertino.dart';
import 'package:sow_remember/service/user_service.dart';

class UserBloc with ChangeNotifier {
  String username = '';

  Future init() async {
    await UserService.getUserName().then((value) {
      username = value;
      notifyListeners();
    });
  }
}
