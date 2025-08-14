import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_expense/src/viewmodels/auth_vm.dart';


class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});
  @override State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final name = TextEditingController();
  final email = TextEditingController();
  final pass = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthVM>();
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          TextField(controller: name, decoration: const InputDecoration(labelText: 'Name')),
          TextField(controller: email, decoration: const InputDecoration(labelText: 'Email')),
          TextField(controller: pass, decoration: const InputDecoration(labelText: 'Password'), obscureText: true),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () async {
              final err = await auth.signup(name.text.trim(), email.text.trim(), pass.text.trim());
              if (err != null) _err(err);
              else Navigator.pushNamedAndRemoveUntil(context, '/dashboard', (_) => false);
            },
            child: const Text('Create account'),
          ),
        ]),
      ),
    );
  }

  void _err(String e) => showDialog(context: context, builder: (_) => AlertDialog(title: const Text('Error'), content: Text(e)));
}
