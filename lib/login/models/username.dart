enum UsernameValidationError { empty }

class Username {
  const Username.pure()
      : status = 'pure',
        value = 'none';
  const Username.dirty(this.value) : status = 'pure';

  final String status;
  final String value;
}
