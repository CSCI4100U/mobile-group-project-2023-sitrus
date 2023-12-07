import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:student_helper_project/pages/accommodations_letter_email_page.dart';
import 'package:student_helper_project/pages/app_state.dart';
import 'package:student_helper_project/pages/help.dart';
import 'package:student_helper_project/pages/home_page.dart';
import 'package:student_helper_project/pages/new_home_page.dart';
import 'package:student_helper_project/pages/onboarding.dart';
import 'package:student_helper_project/pages/settings_page.dart';
import 'package:student_helper_project/theme.dart';
import 'models/ThemeProvider.dart';
import 'pages/friend_list/friend_login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeFirebase();

  runApp(ChangeNotifierProvider(
    create: (context) => ApplicationState(),
    builder: ((context, child) => const MyApp()),
  ));
}

final _router = GoRouter(
  routes: [
    GoRoute(
      // path: '/',
      // builder: (context, state) =>  NewHomePage(),
      path: '/',
      builder: (context, state) {
        // Check if user is logged in and decide initial route
        if (FirebaseAuth.instance.currentUser != null) {
          return OnboardingScreen();
        } else {
          return OnboardingScreen();
        }
      },
      routes: [
        GoRoute(
          path: 'sign-in',
          builder: (context, state) {
            return SignInScreen(
              actions: [
                ForgotPasswordAction(((context, email) {
                  final uri = Uri(
                    path: '/sign-in/forgot-password',
                    queryParameters: <String, String?>{
                      'email': email,
                    },
                  );
                  context.push(uri.toString());
                })),
                AuthStateChangeAction(((context, state) {
                  final user = switch (state) {
                    SignedIn state => state.user,
                    UserCreated state => state.credential.user,
                    _ => null
                  };
                  if (user == null) {
                    return;
                  }
                  if (state is UserCreated) {
                    user.updateDisplayName(user.email!.split('@')[0]);
                  }
                  if (!user.emailVerified) {
                    user.sendEmailVerification();
                    const snackBar = SnackBar(
                        content: Text(
                            'Please check your email to verify your email address'));
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                  context.pushReplacement('/');
                })),
              ],
            );
          },
          routes: [
            GoRoute(
              path: 'forgot-password',
              builder: (context, state) {
                final arguments = state.uri.queryParameters;
                return ForgotPasswordScreen(
                  email: arguments['email'],
                  headerMaxExtent: 200,
                );
              },
            ),
          ],
        ),
        GoRoute(
          path: 'profile',
          builder: (context, state) {
            return ProfileScreen(
              providers: const [],
              actions: [
                SignedOutAction((context) {
                  context.pushReplacement('/');
                }),
              ],
            );
          },
        ),
      ],
    ),
  ],
);

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<bool?>(
//       future: ThemeProvider.loadThemeFromPreferences(),
//       builder: (context, snapshot) {
//         ThemeData initialTheme =
//         snapshot.data ?? false ? darkMode : lightMode;
//
//         return MaterialApp.router(
//           debugShowCheckedModeBanner: false,
//           title: 'Sitrus Student Aid',
//           theme: lightMode,
//           darkTheme: darkMode,
//           themeMode: ThemeMode.system, // Set your default theme mode here
//           routerConfig: _router,
//         );
//       },
//     );
//   }
// }
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool?>(
      future: ThemeProvider.loadThemeFromPreferences(),
      builder: (context, snapshot) {


        return StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, authSnapshot) {
            if (authSnapshot.connectionState == ConnectionState.active) {
              User? user = authSnapshot.data;
              return MaterialApp.router(
                debugShowCheckedModeBanner: false,
                title: 'Sitrus Student Aid',
                theme: lightMode,
                darkTheme: darkMode,
                themeMode: ThemeMode.system,
                routeInformationParser: _router.routeInformationParser,
                routerDelegate: _router.routerDelegate,
                routeInformationProvider: _router.routeInformationProvider,
              );
            }
            // Show loading indicator while waiting for auth state
            return MaterialApp(
              home: Scaffold(
                body: Center(child: CircularProgressIndicator()),
              ),
            );
          },
        );
      },
    );
  }
}
