part of 'register_bloc.dart';

abstract class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object> get props => [];
}

class UsernameChanged extends RegisterEvent {
  final String userName;
  const UsernameChanged({@required this.userName});

  @override
  List<Object> get props => [userName];

  @override
  String toString() => 'UsernameChanged { username: $userName}';
}

class EmailChanged extends RegisterEvent {
  final String email;
  const EmailChanged({@required this.email});

  @override
  List<Object> get props => [email];

  @override
  String toString() => 'EmailChanged { email: $email }';
}

class ConfirmEmailChanged extends RegisterEvent {
  final String email;
  final String confirmEmail;
  const ConfirmEmailChanged(
      {@required this.email, @required this.confirmEmail});

  @override
  List<Object> get props => [confirmEmail]; //maybe add email

  @override
  String toString() => 'ConfirmEmailChanged { confirmEmail: $confirmEmail }';
}

class PasswordChanged extends RegisterEvent {
  final String password;
  const PasswordChanged({@required this.password});

  @override
  List<Object> get props => [password];

  @override
  String toString() => 'PasswordChanged { password: $password }';
}

class ConfirmPasswordChanged extends RegisterEvent {
  final String password;
  final String confirmPassword;
  const ConfirmPasswordChanged(
      {@required this.password, @required this.confirmPassword});

  @override
  List<Object> get props => [confirmPassword]; // maybe add password

  @override
  String toString() =>
      'ConfirmPasswordChanged { confirmEmail: $confirmPassword }';
}

class Submitted extends RegisterEvent {
  final String userName;
  final String firstName;
  final String middleName;
  final String lastName;
  final String email;
  // final String confirmEmail;
  final String password;

  const Submitted({
    @required this.userName,
    @required this.firstName,
    @required this.middleName,
    @required this.lastName,
    @required this.email,
    // @required this.confirmEmail,
    @required this.password,
  });

  @override
  List<Object> get props => [
        firstName,
        middleName,
        lastName,
        userName,
        email,
        // confirmEmail,
        password
      ];

  @override
  String toString() {
    return 'Submitted { first_name: $firstName, middle_name: $middleName, last_name: $lastName, username: $userName, email: $email, password: $password}';
  }
}
