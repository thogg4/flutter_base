import 'package:bloc/bloc.dart';
import 'package:flutter_login/login/bloc/login_event.dart';
import 'package:flutter_login/login/bloc/login_state.dart';
import 'package:flutter_login/login/models/password.dart';
import 'package:flutter_login/login/models/username.dart';
import 'package:flutter_login/repositories/user_repository/lib/src/user_repository.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc({
    required UserRepository userRepository,
  })  : _userRepository = userRepository,
        super(const LoginState()) {
    on<LoginUsernameChanged>(_onUsernameChanged);
    on<LoginPasswordChanged>(_onPasswordChanged);
    on<LoginSubmitted>(_onSubmitted);
  }

  final UserRepository _userRepository;

  void _onUsernameChanged(
      LoginUsernameChanged event, Emitter<LoginState> emit) {
    final username = Username.dirty(event.username);
    emit(state.copyWith(
      username: username,
      status: 'usernameChecked',
    ));
  }

  void _onPasswordChanged(
    LoginPasswordChanged event,
    Emitter<LoginState> emit,
  ) {
    final password = Password.dirty(event.password);
    emit(state.copyWith(
      password: password,
      status: 'passwordChecked',
    ));
  }

  void _onSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    if (state.status == 'passwordChecked') {
      emit(state.copyWith(status: 'submitting'));
      try {
        await _userRepository.logIn(
          username: state.username.value,
          password: state.password.value,
        );
        emit(state.copyWith(status: 'success'));
      } catch (_) {
        emit(state.copyWith(status: 'failure'));
      }
    }
  }
}
