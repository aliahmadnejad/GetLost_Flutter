part of 'register_bloc.dart';

@immutable
class RegisterState {
  final bool isFirstNameValid;
  final bool isMiddleNameValid;
  final bool isLastNameValid;
  final bool isUsernameValid;
  final bool isEmailValid;
  final bool isConfirmEmailValid;
  final bool isPasswordValid;
  final bool isConfirmPasswordValid;
  final bool isSubmitting;
  final bool isSuccess;
  final bool isFailure;

  bool get isFormValid =>
      isUsernameValid &&
      isEmailValid &&
      isConfirmEmailValid &&
      isPasswordValid &&
      isConfirmPasswordValid;

  RegisterState({
    @required this.isFirstNameValid,
    @required this.isMiddleNameValid,
    @required this.isLastNameValid,
    @required this.isUsernameValid,
    @required this.isEmailValid,
    @required this.isConfirmEmailValid,
    @required this.isPasswordValid,
    @required this.isConfirmPasswordValid,
    @required this.isSubmitting,
    @required this.isSuccess,
    @required this.isFailure,
  });

  factory RegisterState.empty() {
    return RegisterState(
      isFirstNameValid: true,
      isMiddleNameValid: true,
      isLastNameValid: true,
      isUsernameValid: true,
      isEmailValid: true,
      isConfirmEmailValid: true,
      isPasswordValid: true,
      isConfirmPasswordValid: true,
      isSubmitting: false,
      isSuccess: false,
      isFailure: false,
    );
  }

  factory RegisterState.loading() {
    return RegisterState(
      isFirstNameValid: true,
      isMiddleNameValid: true,
      isLastNameValid: true,
      isUsernameValid: true,
      isEmailValid: true,
      isConfirmEmailValid: true,
      isPasswordValid: true,
      isConfirmPasswordValid: true,
      isSubmitting: true,
      isSuccess: false,
      isFailure: false,
    );
  }

  factory RegisterState.failure() {
    return RegisterState(
      isFirstNameValid: true,
      isMiddleNameValid: true,
      isLastNameValid: true,
      isUsernameValid: true,
      isEmailValid: true,
      isConfirmEmailValid: true,
      isPasswordValid: true,
      isConfirmPasswordValid: true,
      isSubmitting: false,
      isSuccess: false,
      isFailure: true,
    );
  }

  factory RegisterState.success() {
    return RegisterState(
      isFirstNameValid: true,
      isMiddleNameValid: true,
      isLastNameValid: true,
      isUsernameValid: true,
      isEmailValid: true,
      isConfirmEmailValid: true,
      isPasswordValid: true,
      isConfirmPasswordValid: true,
      isSubmitting: false,
      isSuccess: true,
      isFailure: false,
    );
  }

  get displayName => null;

  RegisterState update({
    bool isFirstNameValid,
    bool isMiddleNameValid,
    bool isLastNameValid,
    bool isUsernameValid,
    bool isEmailValid,
    bool isConfirmEmailValid,
    bool isPasswordValid,
    bool isConfirmPasswordValid,
  }) {
    return copyWith(
      isFirstNameValid: isFirstNameValid,
      isMiddleNameValid: isMiddleNameValid,
      isLastNameValid: isLastNameValid,
      isUsernameValid: isUsernameValid,
      isEmailValid: isEmailValid,
      isConfirmEmailValid: isConfirmEmailValid,
      isPasswordValid: isPasswordValid,
      isConfirmPasswordValid: isConfirmPasswordValid,
      isSubmitting: false,
      isSuccess: false,
      isFailure: false,
    );
  }

  RegisterState copyWith({
    bool isFirstNameValid,
    bool isMiddleNameValid,
    bool isLastNameValid,
    bool isUsernameValid,
    bool isEmailValid,
    bool isConfirmEmailValid,
    bool isPasswordValid,
    bool isConfirmPasswordValid,
    bool isSubmitEnabled,
    bool isSubmitting,
    bool isSuccess,
    bool isFailure,
  }) {
    return RegisterState(
      isFirstNameValid: isFirstNameValid ?? this.isFirstNameValid,
      isMiddleNameValid: isMiddleNameValid ?? this.isMiddleNameValid,
      isLastNameValid: isLastNameValid ?? this.isLastNameValid,
      isUsernameValid: isUsernameValid ?? this.isUsernameValid,
      isEmailValid: isEmailValid ?? this.isEmailValid,
      isConfirmEmailValid: isConfirmEmailValid ?? this.isConfirmEmailValid,
      isPasswordValid: isPasswordValid ?? this.isPasswordValid,
      isConfirmPasswordValid:
          isConfirmPasswordValid ?? this.isConfirmPasswordValid,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      isFailure: isFailure ?? this.isFailure,
    );
  }

  @override
  String toString() {
    return '''RegisterState {
      isFirstNameValid: $isFirstNameValid,
      isMiddleNameValid: $isMiddleNameValid,
      isLastNameValid: $isLastNameValid,
      isUsernameValid: $isUsernameValid,
      isEmailValid: $isEmailValid,
      isConfirmEmailValid: $isConfirmEmailValid,
      isPasswordValid: $isPasswordValid,
      isConfirmPasswordValid: $isConfirmPasswordValid,
      isSubmitting: $isSubmitting,
      isSuccess: $isSuccess,
      isFailure: $isFailure,
    }''';
  }
}
