import 'package:flutter/widgets.dart';
import 'package:instagramclone/models/user.dart';
import 'package:instagramclone/response/auth.dart';

class UserProvider with ChangeNotifier {
  User _user;

  final Auth _authnew = Auth();

  User get getUser => _user;

  Future<void> refreshUser() async {
    User user = await _authnew.getUserDetails();
    _user = user;
    notifyListeners();
  }
}
