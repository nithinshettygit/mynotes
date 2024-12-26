import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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

    // Check if email is verified upon opening the view
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && user.emailVerified) {
      // If email is already verified, navigate away or show appropriate UI
      // You can navigate to another page or show a message
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacementNamed('/home'); // Example route
      });
    }
  }

  Future<void> sendEmailVerification() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.sendEmailVerification();
      setState(() {
        isEmailSent = true;
      });

      // Show a snackbar to inform the user
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Verification email sent!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Email'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Please verify your email address'),
            const SizedBox(height: 20),
            if (isEmailSent)
              const Text('A verification email has been sent to your inbox.'),
            TextButton(
              onPressed: sendEmailVerification,
              child: const Text('Send Email Verification'),
            ),
          ],
        ),
      ),
    );
  }
}
