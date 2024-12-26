import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView>
    with WidgetsBindingObserver {
  bool isEmailSent = false;

  @override
  void initState() {
    super.initState();
    // Automatically check if the email is already verified when opening the page
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkIfEmailAlreadyVerified();
    });
    WidgetsBinding.instance.addObserver(this); // Observe app lifecycle changes
  }

  @override
  void dispose() {
    WidgetsBinding.instance
        .removeObserver(this); // Remove observer when disposed
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      // When the app resumes, check if email is verified
      _checkIfEmailAlreadyVerified();
    }
  }

  Future<void> _checkIfEmailAlreadyVerified() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user
          .reload(); // Refresh the user data to get updated verification status
      if (user.emailVerified) {
        Navigator.of(context).pushReplacementNamed(
            '/home'); // Navigate to the home page if verified
      }
    }
  }

  Future<void> sendEmailVerification() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await user.sendEmailVerification();
        setState(() {
          isEmailSent = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Verification email sent! Check your inbox.')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error sending email: $e')),
        );
      }
    }
  }

  Future<void> checkEmailVerified() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.reload(); // Refresh the user data
      if (user.emailVerified) {
        Navigator.of(context).pushReplacementNamed(
            '/home'); // Navigate to the home page if verified
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Email is not yet verified. Please try again.')),
        );
      }
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
            const Text(
              'A verification email has been sent to your email address. Please verify it.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            if (!isEmailSent)
              ElevatedButton(
                onPressed: sendEmailVerification,
                child: const Text('Send Verification Email'),
              ),
            ElevatedButton(
              onPressed: checkEmailVerified,
              child: const Text('I Have Verified My Email'),
            ),
            const SizedBox(height: 10),
            const Text(
              'Note: Check your spam folder if you do not see the email.',
              style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
