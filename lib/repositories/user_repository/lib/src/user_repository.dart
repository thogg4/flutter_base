import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'models/user.dart';

enum UserLoginStatus { unknown, authenticated, unauthenticated }

class UserRepository {
  User? _user;
  final _controller = StreamController<UserLoginStatus>();

  Stream<UserLoginStatus> get loginStatus async* {
    final preferences = await SharedPreferences.getInstance();
    final userId = preferences.getString('userId');

    yield userId == null
        ? UserLoginStatus.unauthenticated
        : UserLoginStatus.authenticated;

    yield* _controller.stream;
  }

  Future<User?> getUser() async {
    if (_user != null) return _user;

    final preferences = await SharedPreferences.getInstance();
    final userId = preferences.getString('userId');

    if (userId == null) throw Error();

    _user = User(userId);
    return _user;
  }

  Future<void> logIn({
    required String username,
    required String password,
  }) async {
    // request to get user

    final preferences = await SharedPreferences.getInstance();
    await preferences.setString('userId', const Uuid().v4());
    _controller.add(UserLoginStatus.authenticated);
  }

  void logOut() async {
    _controller.add(UserLoginStatus.unauthenticated);

    final preferences = await SharedPreferences.getInstance();
    await preferences.remove('userId');
  }

  void dispose() => _controller.close();
}
