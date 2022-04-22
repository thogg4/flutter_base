import 'package:flutter/widgets.dart';
import 'package:flutter_login/app.dart';
import 'package:flutter_login/repositories/user_repository/lib/src/user_repository.dart';

void main() {
  runApp(App(
    userRepository: UserRepository(),
  ));
}
