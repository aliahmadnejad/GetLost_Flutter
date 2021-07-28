import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:rxdart/rxdart.dart';

// import 'package:flutter/semantics.dart';
// import 'package:getLost_app/bloc/authentication_bloc.dart';
import 'package:getLost_app/repository/user_repository.dart';
import 'package:getLost_app/validators.dart';

part 'login_event.dart';
part 'login_state.dart';

// class LoginBloc extends Bloc<LoginEvent, LoginState> {
//   final UserRepository userRepository;
//   final AuthenticationBloc authenticationBloc;

//   LoginBloc({
//     @required this.userRepository,
//     @required this.authenticationBloc,
//   })  : assert(userRepository != null),
//         assert(authenticationBloc != null),
//         super(LoginInitial());

//   @override
//   Stream<LoginState> mapEventToState(
//     LoginEvent event,
//   ) async* {
//     if (event is LoginButtonPressed) {
//       yield LoginInitial();

//       try {
//         final user = await userRepository.authenticate(
//           username: event.username,
//           password: event.password,
//         );

//         authenticationBloc.add(LoggedIn(user: user));
//         yield LoginInitial();
//       } catch (error) {
//         yield LoginFaliure(error: error.toString());
//       }
//     }
//   }
// }

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  UserRepository _userRepository;

  LoginBloc({
    @required UserRepository userRepository,
  })  : assert(userRepository != null),
        _userRepository = userRepository,
        super(LoginState(
            isSuccess: null,
            isFailure: null,
            isPasswordValid: false,
            isSubmitting: null,
            isUsernameValid: false));

  @override
  Stream<Transition<LoginEvent, LoginState>> transformEvents(
    Stream<LoginEvent> events,
    TransitionFunction<LoginEvent, LoginState> transitionFn,
  ) {
    final nonDebounceStream = events.where((event) {
      return (event is! UsernameChanged && event is! PasswordChanged);
    });
    final debounceStream = events.where((event) {
      return (event is UsernameChanged || event is PasswordChanged);
    }).debounceTime(Duration(milliseconds: 300));
    return super.transformEvents(
      nonDebounceStream.mergeWith([debounceStream]),
      transitionFn,
    );
  }

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is UsernameChanged) {
      yield* _mapUsernameToState(event.username);
    } else if (event is PasswordChanged) {
      yield* _mapPasswordToState(event.password);
    } else if (event is LoginWithCredentialsPressed) {
      yield* _mapLoginWithCredentialsPressedToState(
        username: event.username,
        password: event.password,
      );
    }
  }

  Stream<LoginState> _mapUsernameToState(String username) async* {
    yield state.update(
      isUsernameValid: Validators.isValidUsername(username),
    );
  }

  Stream<LoginState> _mapPasswordToState(String password) async* {
    yield state.update(
      isPasswordValid: Validators.isValidPassword(password),
    );
  }

  Stream<LoginState> _mapLoginWithCredentialsPressedToState(
      {String username, String password}) async* {
    yield LoginState.loading();
    try {
      await _userRepository.signInWithCredentials(
          username: username, password: password);
      yield LoginState.success();
    } catch (_) {
      yield LoginState.failure();
    }
  }
}
