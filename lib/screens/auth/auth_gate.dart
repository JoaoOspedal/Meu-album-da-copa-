import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../bootstrap_gate.dart';
import 'login_screen.dart';

/// Routes the user based on the authentication state:
///  - while restoring a session: a loading splash;
///  - signed out: the [LoginScreen];
///  - signed in: the [BootstrapGate] that loads the album data.
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final status = context.watch<AuthProvider>().status;

    switch (status) {
      case AuthStatus.unknown:
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      case AuthStatus.unauthenticated:
        return const LoginScreen();
      case AuthStatus.authenticated:
        return const BootstrapGate();
    }
  }
}
