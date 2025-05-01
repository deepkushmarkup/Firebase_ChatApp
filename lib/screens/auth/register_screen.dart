import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:developer';

import '../../api/apis.dart';
import '../../helper/dialogs.dart';
import '../home_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;

  Future<void> _handleEmailPasswordRegister() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    // Field validations
    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      Dialogs.showSnackbar(context, 'All fields are required!');
      return;
    }

    if (password != confirmPassword) {
      Dialogs.showSnackbar(context, 'Passwords do not match!');
      return;
    }

    setState(() => _isLoading = true);
    Dialogs.showLoading(context);

    try {
      // Firebase registration
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      Navigator.pop(context); // Remove loading
      log('\nRegistered User: ${userCredential.user}');

      // Store user in Firestore / Database
      await APIs.createUser();

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      }
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context); // Remove loading
      String msg = 'Registration failed';
      if (e.code == 'email-already-in-use') {
        msg = 'Email already in use.';
      } else if (e.code == 'weak-password') {
        msg = 'Weak password (minimum 6 characters).';
      }
      Dialogs.showSnackbar(context, msg);
    } catch (e) {
      Navigator.pop(context);
      log('Register error: $e');
      Dialogs.showSnackbar(context, 'Something went wrong!');
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 30),

            // Email field
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),

            // Password field
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                prefixIcon: Icon(Icons.lock),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            // Confirm Password field
            TextField(
              controller: _confirmPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Confirm Password',
                prefixIcon: Icon(Icons.lock_outline),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 30),

            // Register button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _handleEmailPasswordRegister,
                child: const Text('Register'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
