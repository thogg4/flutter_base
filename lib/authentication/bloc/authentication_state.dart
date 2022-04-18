part of 'authentication_bloc.dart';

class AuthenticationState extends Equatable {
  const AuthenticationState._({
    this.status = UserLoginStatus.unknown,
    this.user = User.empty,
  });

  const AuthenticationState.unknown() : this._();

  const AuthenticationState.authenticated(User user)
      : this._(status: UserLoginStatus.authenticated, user: user);

  const AuthenticationState.unauthenticated()
      : this._(status: UserLoginStatus.unauthenticated);

  final UserLoginStatus status;
  final User user;

  @override
  List<Object> get props => [status, user];
}
