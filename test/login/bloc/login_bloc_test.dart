import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_login/login/bloc/login_bloc.dart';
import 'package:flutter_login/login/bloc/login_event.dart';
import 'package:flutter_login/login/bloc/login_state.dart';
import 'package:flutter_login/login/models/password.dart';
import 'package:flutter_login/login/models/username.dart';
import 'package:flutter_login/repositories/user_repository/lib/src/user_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockuserRepository extends Mock implements UserRepository {}

void main() {
  late UserRepository userRepository;

  setUp(() {
    userRepository = MockuserRepository();
  });

  group('LoginBloc', () {
    test('initial state is LoginState', () {
      final loginBloc = LoginBloc(
        userRepository: userRepository,
      );
      expect(loginBloc.state, const LoginState());
    });

    group('LoginSubmitted', () {
      blocTest<LoginBloc, LoginState>(
        'emits [submissionInProgress, submissionSuccess] '
        'when login succeeds',
        setUp: () {
          when(
            () => userRepository.logIn(
              username: 'username',
              password: 'password',
            ),
          ).thenAnswer((_) => Future.value('user'));
        },
        build: () => LoginBloc(
          userRepository: userRepository,
        ),
        act: (bloc) {
          bloc
            ..add(const LoginUsernameChanged('username'))
            ..add(const LoginPasswordChanged('password'))
            ..add(const LoginSubmitted());
        },
        expect: () => const <LoginState>[
          LoginState(
            username: Username.dirty('username'),
            status: 'usernameChecked',
          ),
          LoginState(
            username: Username.dirty('username'),
            password: Password.dirty('password'),
            status: 'passwordChecked',
          ),
          LoginState(
            username: Username.dirty('username'),
            password: Password.dirty('password'),
            status: 'submitting',
          ),
          LoginState(
            username: Username.dirty('username'),
            password: Password.dirty('password'),
            status: 'success',
          ),
        ],
      );

      blocTest<LoginBloc, LoginState>(
        'emits [LoginInProgress, LoginFailure] when logIn fails',
        setUp: () {
          when(
            () => userRepository.logIn(
              username: 'username',
              password: 'password',
            ),
          ).thenThrow(Exception('oops'));
        },
        build: () => LoginBloc(
          userRepository: userRepository,
        ),
        act: (bloc) {
          bloc
            ..add(const LoginUsernameChanged('username'))
            ..add(const LoginPasswordChanged('password'))
            ..add(const LoginSubmitted());
        },
        expect: () => const <LoginState>[
          LoginState(
            username: Username.dirty('username'),
            status: 'usernameChecked',
          ),
          LoginState(
            username: Username.dirty('username'),
            password: Password.dirty('password'),
            status: 'passwordChecked',
          ),
          LoginState(
            username: Username.dirty('username'),
            password: Password.dirty('password'),
            status: 'submitting',
          ),
          LoginState(
            username: Username.dirty('username'),
            password: Password.dirty('password'),
            status: 'failure',
          ),
        ],
      );
    });
  });
}
