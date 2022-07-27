import 'package:flutter_test/flutter_test.dart';
import 'package:log_in/screens/authenticate/log_in.dart';

void main() {

  test('empty email returns error string', () {

    final result = EmailFieldValidator.validate('');
    expect(result, 'Enter an email');
  });

  test('non-empty email returns null', () {

    final result = EmailFieldValidator.validate('email');
    expect(result, null);
  });

  test('empty password returns error string', () {

    final result = PasswordFieldValidator.validate('');
    expect(result, 'Enter a password at least 6 characters long');
  });

  test('non-empty password returns null', () {

    final result = PasswordFieldValidator.validate('password');
    expect(result, null);
  });
}