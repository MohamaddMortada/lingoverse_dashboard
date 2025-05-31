import 'package:flutter/material.dart';
import 'dashboard_page.dart';

class PasswordPage extends StatefulWidget {
  const PasswordPage({super.key});

  @override
  State<PasswordPage> createState() => _PasswordPageState();
}

class _PasswordPageState extends State<PasswordPage> {
  final _passwordController = TextEditingController();
  final _correctPassword = 'admin123'; 
  String? _error;

  void _validatePassword() {
    if (_passwordController.text == _correctPassword) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const DashboardPage()),
      );
    } else {
      setState(() {
        _error = 'Incorrect password';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF00131F),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Enter Admin Password",
                style: TextStyle(fontSize: 22, color: Colors.white),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                obscureText: true,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Password",
                  hintStyle: const TextStyle(color: Colors.white54),
                  filled: true,
                  fillColor: Colors.white10,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  errorText: _error,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _validatePassword,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFf25C0FF),
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                ),
                child: const Text("Access Dashboard"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
