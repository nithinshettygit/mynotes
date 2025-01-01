import 'package:flutter/material.dart';
import 'package:myappfirst/constants/routes.dart';
import 'package:myappfirst/enum/menu_action.dart';
import 'dart:developer' as devtools show log;

import 'package:myappfirst/views/services/auth/auth_service.dart';

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
                    await AuthService.firebase().logOut();
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
              var devtools;
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
