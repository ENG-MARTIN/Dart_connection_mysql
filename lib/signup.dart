import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';

class SignupPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _signup(BuildContext context) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:38567/signup.php'),
        body: {
          'email': _emailController.text,
          'password': _passwordController.text,
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success']) {
          Navigator.pop(context); // Go back to login page on success
        } else {
          _showErrorSnackBar(
              context, 'Signup failed: ${data['message'] ?? 'Unknown error'}');
        }
      } else {
        _showErrorSnackBar(context, 'Error: ${response.statusCode}');
      }
    } catch (e) {
      _showErrorSnackBar(context, 'An error occurred: $e');
      print('Error: $e'); // Log the error for debugging
    }
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sign Up')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _signup(context),
              child: Text('Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}
