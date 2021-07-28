class Validators {
  static final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
  );

  static final RegExp _passwordRegExp = RegExp(
    // r'^(((?=.*[a-z])(?=.*[A-Z]))|((?=.*[a-z])(?=.*[0-9]))|((?=.*[A-Z])(?=.*[0-9])))(?=.{6,})',
    r'^.{6,}$',
  );

  static isValidEmail(String email) {
    return _emailRegExp.hasMatch(email);
  }

  static isValidConfirmEmail(String email, String confirmEmail) {
    if (email.toString() == confirmEmail.toString()) {
      return _emailRegExp.hasMatch(confirmEmail);
    } else {
      return false;
    }
  }

  static isValidUsername(String username) {
    if (username.toString().length != 0) {
      return true;
    } else {
      return false;
    }
  }

  static isValidPassword(String password) {
    return _passwordRegExp.hasMatch(password);
  }

  static isValidConfirmPassword(String password, String confirmPassword) {
    if (password.toString() == confirmPassword.toString()) {
      return _passwordRegExp.hasMatch(password);
    } else {
      return false;
    }
  }

  static isPinCodeValid(int pinCode) {
    if (pinCode.toString().length == 6) {
      return true;
    }
    return false;
  }
}
