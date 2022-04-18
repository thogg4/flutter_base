import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_login/authentication/authentication.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:user_repository/user_repository.dart';

class MockAuthenticationRepository extends Mock implements UserRepository {}

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  const user = User('id');
  late UserRepository userRepository;

  setUp(() {
    when(() => userRepository.loginStatus)
        .thenAnswer((_) => const Stream.empty());
    userRepository = MockUserRepository();
  });

  group('AuthenticationBloc', () {
    test('initial state is AuthenticationState.unknown', () {
      final authenticationBloc = AuthenticationBloc(
        userRepository: userRepository,
      );
      expect(authenticationBloc.state, const AuthenticationState.unknown());
      authenticationBloc.close();
    });

    blocTest<AuthenticationBloc, AuthenticationState>(
      'emits [unauthenticated] when status is unauthenticated',
      setUp: () {
        when(() => userRepository.loginStatus).thenAnswer(
          (_) => Stream.value(UserLoginStatus.unauthenticated),
        );
      },
      build: () => AuthenticationBloc(
        userRepository: userRepository,
      ),
      expect: () => const <AuthenticationState>[
        AuthenticationState.unauthenticated(),
      ],
    );

    blocTest<AuthenticationBloc, AuthenticationState>(
      'emits [authenticated] when status is authenticated',
      setUp: () {
        when(() => userRepository.loginStatus).thenAnswer(
          (_) => Stream.value(UserLoginStatus.authenticated),
        );
        when(() => userRepository.getUser()).thenAnswer((_) async => user);
      },
      build: () => AuthenticationBloc(
        userRepository: userRepository,
      ),
      expect: () => const <AuthenticationState>[
        AuthenticationState.authenticated(user),
      ],
    );
  });

  group('AuthenticationStatusChanged', () {
    blocTest<AuthenticationBloc, AuthenticationState>(
      'emits [authenticated] when status is authenticated',
      setUp: () {
        when(() => userRepository.loginStatus).thenAnswer(
          (_) => Stream.value(UserLoginStatus.authenticated),
        );
        when(() => userRepository.getUser()).thenAnswer((_) async => user);
      },
      build: () => AuthenticationBloc(
        userRepository: userRepository,
      ),
      act: (bloc) => bloc.add(
        const AuthenticationStatusChanged(UserLoginStatus.authenticated),
      ),
      expect: () => const <AuthenticationState>[
        AuthenticationState.authenticated(user),
      ],
    );

    blocTest<AuthenticationBloc, AuthenticationState>(
      'emits [unauthenticated] when status is unauthenticated',
      setUp: () {
        when(() => userRepository.loginStatus).thenAnswer(
          (_) => Stream.value(UserLoginStatus.unauthenticated),
        );
      },
      build: () => AuthenticationBloc(
        userRepository: userRepository,
      ),
      act: (bloc) => bloc.add(
        const AuthenticationStatusChanged(UserLoginStatus.unauthenticated),
      ),
      expect: () => const <AuthenticationState>[
        AuthenticationState.unauthenticated(),
      ],
    );

    blocTest<AuthenticationBloc, AuthenticationState>(
      'emits [unauthenticated] when status is authenticated but getUser fails',
      setUp: () {
        when(() => userRepository.getUser()).thenThrow(Exception('oops'));
      },
      build: () => AuthenticationBloc(
        userRepository: userRepository,
      ),
      act: (bloc) => bloc.add(
        const AuthenticationStatusChanged(UserLoginStatus.authenticated),
      ),
      expect: () => const <AuthenticationState>[
        AuthenticationState.unauthenticated(),
      ],
    );

    blocTest<AuthenticationBloc, AuthenticationState>(
      'emits [unauthenticated] when status is authenticated '
      'but getUser returns null',
      setUp: () {
        when(() => userRepository.getUser()).thenAnswer((_) async => null);
      },
      build: () => AuthenticationBloc(
        userRepository: userRepository,
      ),
      act: (bloc) => bloc.add(
        const AuthenticationStatusChanged(UserLoginStatus.authenticated),
      ),
      expect: () => const <AuthenticationState>[
        AuthenticationState.unauthenticated(),
      ],
    );

    blocTest<AuthenticationBloc, AuthenticationState>(
      'emits [unknown] when status is unknown',
      setUp: () {
        when(() => userRepository.loginStatus).thenAnswer(
          (_) => Stream.value(UserLoginStatus.unknown),
        );
      },
      build: () => AuthenticationBloc(
        userRepository: userRepository,
      ),
      act: (bloc) => bloc.add(
        const AuthenticationStatusChanged(UserLoginStatus.unknown),
      ),
      expect: () => const <AuthenticationState>[
        AuthenticationState.unknown(),
      ],
    );
  });

  group('AuthenticationLogoutRequested', () {
    blocTest<AuthenticationBloc, AuthenticationState>(
      'calls logOut on userRepository '
      'when AuthenticationLogoutRequested is added',
      build: () => AuthenticationBloc(
        userRepository: userRepository,
      ),
      act: (bloc) => bloc.add(AuthenticationLogoutRequested()),
      verify: (_) {
        verify(() => userRepository.logOut()).called(1);
      },
    );
  });
}
