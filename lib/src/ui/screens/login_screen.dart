import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_expense/src/constants/app_strings.dart';
import 'package:smart_expense/src/viewmodels/auth_vm.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final email = TextEditingController();
  final pass = TextEditingController();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthVM>();

    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.login)),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              TextField(controller: email, decoration: const InputDecoration(labelText: AppStrings.email)),
              const SizedBox(height: 12),
              TextField(controller: pass, obscureText: true, decoration: const InputDecoration(labelText: AppStrings.password)),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: loading ? null : () async {
                  setState(()=>loading=true);
                  final err = await auth.login(email.text.trim(), pass.text.trim());
                  setState(()=>loading=false);
                  if (err != null) _showErr(err);
                  else Navigator.pushReplacementNamed(context, '/dashboard');
                },
                child: Text(loading ? 'Signing in...' : 'Sign In'),
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                icon: const Icon(Icons.login),
                label: const Text(AppStrings.googleSignIn),
                onPressed: () async {
                  final err = await auth.google();
                  if (err != null) _showErr(err);
                  else Navigator.pushReplacementNamed(context, '/dashboard');
                },
              ),
              TextButton(
                onPressed: () => Navigator.pushNamed(context, '/signup'),
                child: const Text('Create an account'),
              ),
            ]),
          ),
        ),
      ),
    );
  }

  void _showErr(String e) {
    showDialog(context: context, builder: (_) => AlertDialog(title: const Text('Error'), content: Text(e)));
  }
}
