import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:myappfirst/firebase_options.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
        backgroundColor: Colors.blue,
      ),
      body: FutureBuilder(
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return Column(
                children: [
                  TextField(
                    controller: _email,
                    enableSuggestions: false,
                    autocorrect: false,
                    keyboardType: TextInputType.emailAddress,
                    decoration:
                        InputDecoration(hintText: 'Enter your email here'),
                  ),
                  TextField(
                    controller: _password,
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    decoration:
                        InputDecoration(hintText: 'Enter your password here'),
                  ),
                  TextButton(
                    onPressed: () async {
                      final email = _email.text.trim();
                      final password = _password.text.trim();
                      try {
                        final userCredential = await FirebaseAuth.instance
                            .createUserWithEmailAndPassword(
                                email: email, password: password);
                        print('User registered: $userCredential');
                      } on FirebaseAuthException catch (e) {
                        switch (e.code) {
                          case 'weak-password':
                            print('Error: The password is too weak.');
                            break;
                          case 'email-already-in-use':
                            print(
                                'Error: The email is already in use by another account.');
                            break;
                          case 'invalid-email':
                            print('Error: The email address is invalid.');
                            break;
                          default:
                            print(
                                'Error: An unknown error occurred. Code: ${e.code}');
                        }
                      } catch (e) {
                        print('Error: An unexpected error occurred.');
                      }
                    },
                    child: const Text('Register'),
                  ),
                ],
              );

            default:
              return Text('Loading...');
          }
        },
      ),
    );
  }
}
