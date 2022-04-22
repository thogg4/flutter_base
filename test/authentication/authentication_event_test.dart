// ignore_for_file: prefer_const_constructors
import 'package:flutter_login/authentication/authentication.dart';
import 'package:flutter_login/repositories/user_repository/lib/src/user_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AuthenticationEvent', () {
    group('LoggedOut', () {
      test('supports value comparisons', () {
        expect(
          AuthenticationLogoutRequested(),
          AuthenticationLogoutRequested(),
        );
      });
    });

    group('AuthenticationStatusChanged', () {
      test('supports value comparisons', () {
        expect(
          AuthenticationStatusChanged(UserLoginStatus.unknown),
          AuthenticationStatusChanged(UserLoginStatus.unknown),
        );
      });
    });
  });
}
