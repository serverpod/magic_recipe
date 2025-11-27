import 'package:flutter/material.dart';
import 'package:magic_recipe_flutter/extensions/extensions.dart';
import 'package:magic_recipe_flutter/main.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SignInWidget(
        client: client,
        onAuthenticated: () => onAuthenticated(context),
        onError: (error) => onError(context, error),
      ),
    );
  }

  void onAuthenticated(BuildContext context) {
    context.showSnackBar(
      message: 'User authenticated.',
      backgroundColor: Colors.green,
    );
  }

  void onError(BuildContext context, Object error) {
    context.showSnackBar(
      message: 'Authentication failed: $error',
      backgroundColor: Colors.red,
    );
  }
}

