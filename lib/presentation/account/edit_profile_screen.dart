import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sewiee/app/utils/toast.dart';
import 'package:sewiee/presentation/account/account_viewmodel.dart';
import 'package:sewiee/presentation/widget/button_widget.dart';
import 'package:sewiee/presentation/widget/multiline_text_widget.dart';
import 'package:sewiee/presentation/widget/text_input_widget.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final fullNameController = TextEditingController();
  final usernameController = TextEditingController();
  final bioController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final user = context.read<AccountViewmodel>().userModel;
    fullNameController.text = user?.fullName ?? '';
    usernameController.text = user?.username ?? '';
    bioController.text = user?.bio ?? '';
  }

  bool get isValid =>
      fullNameController.text.trim().isNotEmpty &&
      usernameController.text.trim().isNotEmpty;

  @override
  void dispose() {
    fullNameController.dispose();
    usernameController.dispose();
    bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ubah Profil', style: TextStyle(fontSize: 12)),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: PrimaryButton(
          label: 'Simpan',
          isEnabled: isValid,
          isLoading: false,
          onPressed: () async {
            final success = await context.read<AccountViewmodel>().updateProfile(
                  fullName: fullNameController.text,
                  username: usernameController.text,
                  bio: bioController.text,
                );
            if (!context.mounted) return;
            Toast().showToast(
              context,
              success ? 'Berhasil mengubah profil' : 'Gagal mengubah profil',
            );
            if (success) Navigator.pop(context, true);
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              TextInputWidget(
                controller: fullNameController,
                title: 'Nama Lengkap',
                hintText: 'Nama lengkap',
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 16),
              TextInputWidget(
                controller: usernameController,
                title: 'Username',
                hintText: 'Username',
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 16),
              MultilineTextWidget(
                controller: bioController,
                title: 'Bio',
                hintText: 'Ceritakan sedikit tentang kamu',
                onChanged: (_) => setState(() {}),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
