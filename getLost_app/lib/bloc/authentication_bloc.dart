import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:getLost_app/api_connection/api_connection.dart';
import 'package:getLost_app/model/api_model.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
// import 'package:flutter/semantics.dart';

import 'package:getLost_app/repository/user_repository.dart';
// import 'package:getLost_app/model/user_model.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

// class AuthenticationBloc
//     extends Bloc<AuthenticationEvent, AuthenticationState> {
//   final UserRepository userRepository;

//   AuthenticationBloc({@required this.userRepository})
//       : assert(UserRepository != null),
//         super(AuthenticationUninitialized());

//   @override
//   Stream<AuthenticationState> mapEventToState(
//     AuthenticationEvent event,
//   ) async* {
//     if (event is AppStarted) {
//       final bool hasToken = await userRepository.hasToken();

//       if (hasToken) {
//         yield AuthenticationAuthenticated();
//       } else {
//         yield AuthenticationUnauthenticated();
//       }
//     }
//     if (event is LoggedIn) {
//       yield AuthenticationLoading();

//       await userRepository.persistToken(user: event.user);
//       yield AuthenticationAuthenticated();
//     }

//     if (event is LoggedOut) {
//       yield AuthenticationLoading();

//       await userRepository.deleteToken(id: 0);
//       yield AuthenticationUnauthenticated();
//     }
//   }
// }

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserRepository _userRepository;

  AuthenticationBloc({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(Uninitialized());

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is AppStarted) {
      yield* _mapAppStartedToState();
    }
    if (event is LoggedIn) {
      yield* _mapLoggedInToState();
    }
    if (event is LoggedOut) {
      yield* _mapLoggedOutToState();
    }
  }

  Stream<AuthenticationState> _mapAppStartedToState() async* {
    final isSignedIn = await _userRepository.isSignedIn();
    if (isSignedIn) {
      final name = await _userRepository.getUser();
      final token = await _userRepository.getUserToken();
      final TravelerSignup traveler = await getTraveler();
      // print("hey man here are the stuff ------ ${traveler.id}");
      yield Authenticated(name, token, traveler);
    } else {
      yield Unauthenticated();
    }
  }

  Stream<AuthenticationState> _mapLoggedInToState() async* {
    final name = await _userRepository.getUser();
    final token = await _userRepository.getUserToken();
    final TravelerSignup traveler = await getTraveler();
    yield Authenticated(name, token, traveler);
  }

  Stream<AuthenticationState> _mapLoggedOutToState() async* {
    _userRepository.signOut();
    yield Unauthenticated();
  }
}
