import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_login/login/view/view.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:user_repository/user_repository.dart';

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  group('LoginPage', () {
    late UserRepository userRepository;

    setUp(() {
      userRepository = MockUserRepository();
    });

    test('is routable', () {
      expect(LoginPage.route(), isA<MaterialPageRoute>());
    });

    testWidgets('renders a LoginForm', (tester) async {
      await tester.pumpWidget(
        RepositoryProvider.value(
          value: userRepository,
          child: MaterialApp(
            home: Scaffold(body: LoginPage()),
          ),
        ),
      );
      expect(find.byType(LoginForm), findsOneWidget);
    });
  });
}
