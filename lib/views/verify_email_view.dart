import 'package:flutter/material.dart';
import 'package:myappfirst/views/services/auth/auth_service.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  bool isEmailSent = false;

  @override
  void initState() {
    super.initState();
    _checkIfEmailAlreadyVerified();
  }

  Future<void> _checkIfEmailAlreadyVerified() async {
    final authService = AuthService.firebase();
    final user = authService.currentUser;
    if (user != null && user.isEmailVerified) {
      Navigator.of(context).pushReplacementNamed('/home');
    }
  }

  Future<void> sendEmailVerification() async {
    final authService = AuthService.firebase();
    final user = authService.currentUser;
    if (user != null) {
      try {
        await authService.sendEmailVerification();
        setState(() {
          isEmailSent = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Verification email sent!')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Future<void> logOut() async {
    final authService = AuthService.firebase();
    try {
      await authService.logOut();
      Navigator.of(context).pushReplacementNamed('/login');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verify Email')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Please verify your email before continuing.',
              style: TextStyle(fontSize: 16),
            ),
            if (isEmailSent)
              const Text(
                'Check your inbox for the verification email.',
                style: TextStyle(fontSize: 14),
              ),
            TextButton(
              onPressed: sendEmailVerification,
              child: const Text('Send verification email'),
            ),
            TextButton(
              onPressed: logOut,
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
