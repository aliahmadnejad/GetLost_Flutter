// import 'dart:io';
import 'package:flutter/material.dart';

import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:getLost_app/guest_home/bloc/guest_home_bloc.dart';
import 'package:getLost_app/home/bloc/home_page_bloc.dart';
import 'package:getLost_app/repository/user_repository.dart';
// import 'package:alice/alice.dart';
import 'package:getLost_app/bloc/authentication_bloc.dart';
import 'package:getLost_app/splash/splash.dart';
import 'package:getLost_app/login/login_screen.dart';
import 'package:getLost_app/home/home.dart';
// import 'package:getLost_app/common/common.dart';
import 'package:getLost_app/simple_bloc_delegate.dart';
import 'package:getLost_app/traveler_portal/portal_page.dart';
// import 'package:flutter_flipperkit/flutter_flipperkit.dart';
import 'package:logger/logger.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:country_code_picker/country_localizations.dart';
import 'package:provider/provider.dart';

var logger = Logger(
  printer: PrettyPrinter(),
);

var loggerNoStack = Logger(
  printer: PrettyPrinter(methodCount: 0),
);
void main() {
  // FlipperClient flipperClient = FlipperClient.getDefault();

  // flipperClient.addPlugin(new FlipperNetworkPlugin(
  //     // If you use http library, you must set it to false and use https://pub.dev/packages/flipperkit_http_interceptor
  //     // useHttpOverrides: false,
  //     // Optional, for filtering request
  //     filter: (HttpClientRequest request) {
  //   String url = '${request.uri}';
  //   if (url.startsWith('https://via.placeholder.com') ||
  //       url.startsWith('https://gravatar.com')) {
  //     return false;
  //   }
  //   return true;
  // }));
  // flipperClient.addPlugin(new FlipperReduxInspectorPlugin());
  // flipperClient.addPlugin(new FlipperSharedPreferencesPlugin());
  // flipperClient.start();

  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = SimpleBlocDelegate();
  final UserRepository userRepository = UserRepository();

  runApp(MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              AuthenticationBloc(userRepository: userRepository)
                ..add(AppStarted()),
        ),
      ],
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => ApplicationBloc()),
          ChangeNotifierProvider(create: (context) => GuestApplicationBloc()),
        ],
        child: MyApp(userRepository: userRepository),
      )));

  // runApp(
  //   BlocProvider(
  //     create: (context) =>
  //         AuthenticationBloc(userRepository: userRepository)..add(AppStarted()),
  //     child: MyApp(userRepository: userRepository),
  //   ),
  // );
  demo();
}

void demo() {
  logger.d('Log message with 2 methods');

  loggerNoStack.i('Info message');

  loggerNoStack.w('Just a warning!');

  logger.e('Error! Something bad happened', 'Test Error');

  loggerNoStack.v({'key': 5, 'value': 'something'});

  Logger(printer: SimplePrinter(colors: true)).v('boom');
}

class MyApp extends StatelessWidget {
  final UserRepository _userRepository;
  // Alice alice = Alice(showNotification: true);

  MyApp({Key key, UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return MaterialApp(
      // theme: ThemeData(primaryColorBrightness: Brightness.light,),
      supportedLocales: [
        Locale('en'),
        Locale('it'),
        Locale('fr'),
        Locale('es'),
        Locale('de'),
        Locale('pt'),
        Locale('ko'),
        Locale('zh'),
      ],
      localizationsDelegates: [
        CountryLocalizations.delegate,
      ],
      // navigatorKey: alice.getNavigatorKey(),
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          print("the state is $state");
          if (state is Uninitialized) {
            return SplashPage();
          }
          if (state is Unauthenticated) {
            // return LoginScreen(
            //   userRepository: _userRepository,
            // );
            return TravelerPortal(
              userRepository: _userRepository,
            );
          }
          if (state is Authenticated) {
            // print("The State ID is:  ${_userRepository.}")
            return HomePage(
                name: state.displayName,
                token: state.userToken,
                travelerInformation: state.traveler);
          }
          return Container();
        },
      ),
      // ),
    );
  }
}

// void main() {
//   Bloc.observer = SimpleBlocDelegate();
//   final userRepository = UserRepository();

//   runApp(BlocProvider<AuthenticationBloc>(
//     create: (context) {
//       return AuthenticationBloc(userRepository: userRepository)
//         ..add(AppStarted());
//     },
//     child: MyApp(userRepository: userRepository),
//   ));
// }

// class MyApp extends StatelessWidget {
//   final UserRepository userRepository;

//   MyApp({Key key, @required this.userRepository}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       theme: ThemeData(
//         primarySwatch: Colors.red,
//         brightness: Brightness.dark,
//       ),
//       home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
//         builder: (context, state) {
//           print("the state is $state");
//           if (state is AuthenticationUninitialized) {
//             return SplashPage();
//           }
//           if (state is AuthenticationAuthenticated) {
//             return HomePage();
//           }
//           if (state is AuthenticationUnauthenticated) {
//             return LoginPage(
//               userRepository: userRepository,
//             );
//           }
//           if (state is AuthenticationLoading) {
//             return LoadingIndicator();
//           }
//           return Container();
//         },
//       ),
//     );
//   }
// }
