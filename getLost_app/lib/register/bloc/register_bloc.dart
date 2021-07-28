import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
// import 'package:flutter/semantics.dart';
import 'package:meta/meta.dart';
import 'package:getLost_app/repository/user_repository.dart';
import 'package:getLost_app/validators.dart';
import 'package:rxdart/rxdart.dart';
// import 'package:meta/meta.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final UserRepository _userRepository;

  RegisterBloc({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(RegisterState.empty());

  @override
  Stream<Transition<RegisterEvent, RegisterState>> transformEvents(
    Stream<RegisterEvent> events,
    TransitionFunction<RegisterEvent, RegisterState> transitionFn,
  ) {
    final nonDebounceStream = events.where((event) {
      return (event is! EmailChanged &&
          event is! ConfirmEmailChanged &&
          event is! PasswordChanged &&
          event is! ConfirmPasswordChanged &&
          event is! UsernameChanged);
    });
    final debounceStream = events.where((event) {
      return (event is EmailChanged ||
          event is ConfirmEmailChanged ||
          event is PasswordChanged ||
          event is ConfirmPasswordChanged ||
          event is UsernameChanged);
    }).debounceTime(Duration(milliseconds: 300));
    return super.transformEvents(
      nonDebounceStream.mergeWith([debounceStream]),
      transitionFn,
    );
  }

  @override
  Stream<RegisterState> mapEventToState(
    RegisterEvent event,
  ) async* {
    if (event is EmailChanged) {
      yield* _mapEmailChangedToState(event.email);
    } else if (event is ConfirmEmailChanged) {
      yield* _mapConfirmEmailChangedToState(event.email, event.confirmEmail);
    } else if (event is PasswordChanged) {
      yield* _mapPasswordChangedToState(event.password);
    } else if (event is ConfirmPasswordChanged) {
      yield* _mapConfirmPasswordChangedToState(
          event.password, event.confirmPassword);
    } else if (event is UsernameChanged) {
      yield* _mapUsernameChangedToState(event.userName);
    } else if (event is Submitted) {
      yield* _mapFormSubmittedToState(
        event.userName,
        event.email,
        event.password,
        event.firstName,
        event.middleName,
        event.lastName,
      );
    }
  }

  Stream<RegisterState> _mapUsernameChangedToState(String username) async* {
    yield state.update(
      isUsernameValid: Validators.isValidUsername(username),
    );
  }

  Stream<RegisterState> _mapEmailChangedToState(String email) async* {
    yield state.update(
      isEmailValid: Validators.isValidEmail(email),
    );
  }

  Stream<RegisterState> _mapConfirmEmailChangedToState(
      String email, String confirmEmail) async* {
    yield state.update(
      isConfirmEmailValid: Validators.isValidConfirmEmail(email, confirmEmail),
    );
  }

  Stream<RegisterState> _mapPasswordChangedToState(String password) async* {
    yield state.update(
      isPasswordValid: Validators.isValidPassword(password),
    );
  }

  Stream<RegisterState> _mapConfirmPasswordChangedToState(
      String password, String confirmPassword) async* {
    yield state.update(
      isConfirmPasswordValid:
          Validators.isValidConfirmPassword(password, confirmPassword),
    );
  }

// Note to self: Parameter order matters!!!!!!
  Stream<RegisterState> _mapFormSubmittedToState(
    String userName,
    String email,
    String password,
    String firstName,
    String middleName,
    String lastName,
  ) async* {
    yield RegisterState.loading();
    try {
      await _userRepository.signUp(
        userName: userName,
        email: email, //if you change to "anemail@gmail.com", it works"
        password: password,
        firstName: firstName,
        middleName: middleName,
        lastName: lastName,
      );
      yield RegisterState.success();
    } catch (error) {
      yield RegisterState.failure();
      print("The error is:   $error");
      // yield RegisterState.success();
    }
  }
}
