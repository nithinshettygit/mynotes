import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:myappfirst/constants/routes.dart';
import 'package:myappfirst/firebase_options.dart';
import 'package:myappfirst/views/login_view.dart';
import 'package:myappfirst/views/register_view.dart';
import 'package:myappfirst/views/verify_email_view.dart';
import 'dart:developer' as devtools show log;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 15, 6, 119),
        ),
        useMaterial3: false,
      ),
      home: const HomePage(),
      routes: {
        loginRoute: (context) => const LoginView(),
        registerRoute: (context) => const RegisterView(),
        '/verify-email/': (context) => const VerifyEmailView(),
        notesRoute: (context) => const NotesView(),
      },
    ),
  );
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = FirebaseAuth.instance.currentUser;
            if (user != null) {
              // Reload user to ensure emailVerified is up-to-date
              return FutureBuilder(
                future: user.reload(), // Refresh user state
                builder: (context, reloadSnapshot) {
                  if (reloadSnapshot.connectionState == ConnectionState.done) {
                    final updatedUser = FirebaseAuth.instance.currentUser;
                    if (updatedUser != null && updatedUser.emailVerified) {
                      // If user is verified, go to NotesView
                      return const NotesView();
                    } else {
                      // If user is not verified, go to VerifyEmailView
                      return const VerifyEmailView();
                    }
                  } else {
                    return const CircularProgressIndicator();
                  }
                },
              );
            } else {
              // If no user is logged in, go to LoginView
              return const LoginView();
            }
          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}

enum MenuAction { logout }

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Main UI'),
        actions: [
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              switch (value) {
                case MenuAction.logout:
                  final shouldLogout = await showLogOutDialog(context);
                  if (shouldLogout) {
                    await FirebaseAuth.instance.signOut();
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      loginRoute,
                      (_) => false,
                    );
                  }
              }
            },
            itemBuilder: (context) {
              return [
                const PopupMenuItem<MenuAction>(
                  value: MenuAction.logout,
                  child: Text('Logout'),
                ),
              ];
            },
          )
        ],
      ),
      body: const Center(
        child: Text('Welcome to the Notes App!'),
      ),
    );
  }
}

Future<bool> showLogOutDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to Sign Out?'),
        actions: [
          TextButton(
            onPressed: () {
              devtools.log('false'); // Log false when cancel is pressed
              Navigator.of(context)
                  .pop(false); // Close the dialog and return false
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              devtools.log('true'); // Log true when logout is pressed
              Navigator.of(context)
                  .pop(true); // Close the dialog and return true
            },
            child: const Text('Logout'),
          ),
        ],
      );
    },
  ).then(
      (value) => value ?? false); // Ensures the correct bool value is returned
}
