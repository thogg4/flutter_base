enum PasswordValidationError { empty }

class Password {
  const Password.pure()
      : value = 'none',
        status = 'pure';
  const Password.dirty(this.value) : status = 'pure';

  final String value;
  final String status;
}
