import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_login/authentication/authentication.dart';
import 'package:flutter_login/home/view/home_page.dart';
import 'package:flutter_login/login/view/view.dart';
import 'package:flutter_login/splash/splash.dart';
import 'package:user_repository/user_repository.dart';

class App extends StatelessWidget {
  const App({
    Key? key,
    required this.userRepository,
  }) : super(key: key);

  final UserRepository userRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: userRepository,
      child: BlocProvider(
        create: (_) => AuthenticationBloc(
          userRepository: userRepository,
        ),
        child: AppView(),
      ),
    );
  }
}

class AppView extends StatefulWidget {
  @override
  _AppViewState createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navigatorKey,
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state.status == UserLoginStatus.unknown) {
            return SplashPage();
          }

          if (state.status == UserLoginStatus.authenticated) {
            return HomePage();
          }

          return LoginPage();
        },
      ),
      onGenerateRoute: (_) => SplashPage.route(),
    );
  }
}
