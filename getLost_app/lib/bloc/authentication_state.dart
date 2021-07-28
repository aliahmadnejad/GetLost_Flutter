part of 'authentication_bloc.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();
  @override
  List<Object> get props => [];
}

// class AuthenticationUninitialized extends AuthenticationState {}

// class AuthenticationAuthenticated extends AuthenticationState {}

// class AuthenticationUnauthenticated extends AuthenticationState {}

// class AuthenticationLoading extends AuthenticationState {}

class Uninitialized extends AuthenticationState {}

class Authenticated extends AuthenticationState {
  final String displayName;
  final String userToken;
  final TravelerSignup traveler;

  const Authenticated(
    this.displayName,
    this.userToken,
    this.traveler,
  );

  @override
  List<Object> get props => [displayName, userToken, traveler];
  @override
  String toString() => '''Authenticated  { 
                        displayName: $displayName, 
                        userToken: $userToken, 
                        travelerID: ${traveler.id},
                        firstName: ${traveler.firstName},
                        middleName: ${traveler.middleName},
                        LastName: ${traveler.lastName},
                        country: ${traveler.country},
                        user ID: ${traveler.user.id},
                        username: ${traveler.user.username},
                        email: ${traveler.user.email},
                        phone: ${traveler.phone},
                        emergency_contact_name: ${traveler.emergencyName},
                        emergency_contact_relation: ${traveler.emergencyRelation},
                        emergency_contact_phone: ${traveler.emergencyPhone}
                        emergency_contact_email: ${traveler.emergencyEmail},
                        stripe_id: ${traveler.stripeId},
                      }''';
}

class Unauthenticated extends AuthenticationState {}
