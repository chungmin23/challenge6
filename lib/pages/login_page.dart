import 'package:flutter/material.dart';
import '../main.dart';
import '../services/auth_service.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('로그인'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                final user = await _authService.signInWithGoogle();
                if (user != null && context.mounted) {
                  // 로그인 성공 시 홈 페이지로 이동
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MyHomePage(
                        title: 'Flutter Demo Home Page',
                      ),
                    ),
                  );
                }
              },
              child: const Padding(
                padding: EdgeInsets.all(12.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.login),
                    SizedBox(width: 8),
                    Text('Google로 로그인'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
