import 'package:equatable/equatable.dart';
import 'package:flutter_login/login/models/password.dart';
import 'package:flutter_login/login/models/username.dart';

class LoginState extends Equatable {
  const LoginState({
    this.status = 'unknown',
    this.username = const Username.pure(),
    this.password = const Password.pure(),
  });

  final String status;
  final Username username;
  final Password password;

  LoginState copyWith({
    String? status,
    Username? username,
    Password? password,
  }) {
    return LoginState(
      status: status ?? this.status,
      username: username ?? this.username,
      password: password ?? this.password,
    );
  }

  @override
  List<Object> get props => [status, username, password];
}
