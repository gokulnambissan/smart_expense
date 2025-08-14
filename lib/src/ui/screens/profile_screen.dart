import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:smart_expense/src/services/storage_service.dart';
import 'package:smart_expense/src/viewmodels/auth_vm.dart';
import 'package:smart_expense/src/viewmodels/profile_vm.dart';


class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthVM>();
    final vm = context.watch<ProfileVM>();
    final uid = auth.user!.uid;
    final p = vm.profile;

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: p == null ? const Center(child: CircularProgressIndicator()) : Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(children: [
          CircleAvatar(radius: 40, backgroundImage: p.photoUrl != null ? NetworkImage(p.photoUrl!) : null, child: p.photoUrl == null ? const Icon(Icons.person) : null),
          const SizedBox(height: 8),
          Text(p.email, style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          TextFormField(
            initialValue: p.name,
            decoration: const InputDecoration(labelText: 'Name'),
            onFieldSubmitted: (v) => context.read<ProfileVM>().updateName(uid, v.trim()),
          ),
          const SizedBox(height: 12),
          Row(children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.image),
              label: const Text('Change Photo'),
              onPressed: () async {
                final img = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 80);
                if (img == null) return;
                final url = await StorageService().uploadReceipt(uid, File(img.path));
                await context.read<ProfileVM>().updatePhoto(uid, url);
              },
            ),
          ]),
          const SizedBox(height: 16),
          TextFormField(
            initialValue: p.monthlyBudget.toStringAsFixed(0),
            decoration: const InputDecoration(labelText: 'Monthly Budget (₹)'),
            keyboardType: TextInputType.number,
            onFieldSubmitted: (v) {
              final b = double.tryParse(v) ?? 0;
              context.read<ProfileVM>().updateBudget(uid, b);
            },
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () async {
              await context.read<AuthVM>().logout();
              if (context.mounted) Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
            },
            child: const Text('Logout'),
          ),
        ]),
      ),
    );
  }
}
