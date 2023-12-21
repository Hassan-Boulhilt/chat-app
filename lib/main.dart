import 'package:chat_app/screens/chat_screen.dart';
import 'package:chat_app/screens/login_screen.dart';
import 'package:chat_app/screens/registration_screen.dart';
import 'package:chat_app/screens/welcome_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MainApp());
}

/// The `GoRouter` is creating an instance of the `GoRouter` class, which is responsible for
/// managing the routing within the application. It defines the routes that the application can navigate
/// to and handles the navigation logic. In this code, the `_router` is configured with a list of
/// routes, each associated with a specific path and a builder function that returns the corresponding
/// widget for that route.
final GoRouter _router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const WelcomeScreen();
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'register',
          builder: (BuildContext context, GoRouterState state) {
            return const RegistrationScreen();
          },
        ),
        GoRoute(
          path: 'login',
          builder: (BuildContext context, GoRouterState state) =>
              const LoginScreen(),
        ),
        GoRoute(
          path: 'chat',
          builder: (BuildContext context, GoRouterState state) =>
              const ChatScreen(),
        )
      ],
    ),
  ],
);

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      /// The `_router` variable is an instance of the `GoRouter` class, which is
      /// responsible for managing the routing within the application. It defines the
      /// routes that the application can navigate to and handles the navigation logic. In
      /// this code, `_router` is configured with a list of routes, each associated with a
      /// specific path and a builder function that returns the corresponding widget for
      /// that route.
      /// The `_router` variable is an instance of the `GoRouter` class, which is
      /// responsible for managing the routing within the application. It defines the
      /// routes that the application can navigate to and handles the navigation logic. In
      /// this code, `_router` is configured with a list of routes, each associated with a
      /// specific path and a builder function that returns the corresponding widget for
      /// that route.
      routerConfig: _router,
    );
  }
}
