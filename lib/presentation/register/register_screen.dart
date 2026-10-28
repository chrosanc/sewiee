import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sewiee/app/theme.dart';
import 'package:sewiee/presentation/register/register_viewmodel.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // =========================
  // CONTROLLERS
  // =========================
  late TextEditingController usernameController;
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController confirmPasswordController;
  late TextEditingController phoneController;

  @override
  void initState() {
    super.initState();
    usernameController = TextEditingController();
    nameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
    phoneController = TextEditingController();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final model = context.watch<RegisterViewModel>();

    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: _button(model),

      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 20),
            _header(),
            SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInputField(
                      title: "Nama Lengkap",
                      controller: nameController,
                      hintText: "Nama Lengkap",
                      onChanged: (value) {
                        model.updateFullNameFilled(value.isNotEmpty, nameController);
                      },
                    ),

                    _buildInputField(
                      title: "Nama Pengguna",
                      controller: usernameController,
                      hintText: "Nama Pengguna",
                      onChanged: (value) {
                        model.updateUsernameFilled(value.isNotEmpty, usernameController);
                      },
                    ),

                    _buildInputField(
                      title: "Email",
                      controller: emailController,
                      hintText: "Email",
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (value) {
                        model.updateEmailFilled(value.isNotEmpty, emailController);
                      },
                    ),

                    _buildInputField(
                      title: "Nomor Handphone",
                      controller: phoneController,
                      hintText: "Nomor Handphone",
                      keyboardType: TextInputType.phone,
                      prefixText: "+62 ",
                      onChanged: (value) {
                        model.updatePhoneFilled(value.isNotEmpty, phoneController);
                      },
                    ),

                    _buildInputField(
                      title: "Password",
                      controller: passwordController,
                      hintText: "Password",
                      obscureText: model.isPasswordObscured,
                      suffixIcon: IconButton(
                        onPressed: model.togglePasswordVisibility,
                        icon: Icon(
                          model.isPasswordObscured
                              ? Icons.lock_outline
                              : Icons.lock_open,
                        ),
                      ),
                      onChanged: (value) {
                        model.updatePasswordFilled(value.isNotEmpty, passwordController);
                      },
                    ),

                    _buildInputField(
                      title: "Konfirmasi Password",
                      controller: confirmPasswordController,
                      hintText: "Konfirmasi Password",
                      obscureText: model.isConfirmPasswordObscured,
                      suffixIcon: IconButton(
                        onPressed: model.toggleConfirmPasswordVisibility,
                        icon: Icon(
                          model.isConfirmPasswordObscured
                              ? Icons.lock_outline
                              : Icons.lock_open,
                        ),
                      ),
                      onChanged: (value) {
                        model.updateConfirmPasswordFilled(value.isNotEmpty, confirmPasswordController);
                      },
                    ),

                    // =========================
                    // ERROR PASSWORD
                    // =========================
                    if (confirmPasswordController.text.isNotEmpty &&
                        confirmPasswordController.text !=
                            passwordController.text)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 8,
                        ),

                        child: Row(
                          children: [
                            const Icon(
                              Icons.info_outline,
                              color: Colors.red,
                              size: 18,
                            ),

                            const SizedBox(width: 6),

                            Text(
                              "Konfirmasi password tidak sama",
                              style: GoogleFonts.poppins(
                                color: Colors.red,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),

                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =========================
  // HEADER
  // =========================

  Widget _header() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Daftar.',
            style: GoogleFonts.poppins(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: themeData.colorScheme.primary,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            'Silakan daftarkan akun anda untuk melanjutkan',
            style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  // =========================
  // INPUT FIELD
  // =========================

  Widget _buildInputField({
    required String title,
    required TextEditingController controller,
    required String hintText,

    TextInputType keyboardType = TextInputType.text,

    bool obscureText = false,

    Widget? suffixIcon,

    String? prefixText,

    Function(String)? onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(left: 25, right: 25, bottom: 18),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: const Color(0xFF9E9E9E),
            ),
          ),

          const SizedBox(height: 5),

          TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            obscureText: obscureText,
            onChanged: onChanged,

            style: GoogleFonts.poppins(fontSize: 14),

            decoration: InputDecoration(
              hintText: hintText,
              prefixText: prefixText,
              suffixIcon: suffixIcon,

              hintStyle: const TextStyle(color: Colors.grey),

              filled: true,
              fillColor: Colors.white,

              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 18,
              ),

              // =========================
              // NORMAL BORDER
              // =========================
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),

              // =========================
              // FOCUSED BORDER
              // =========================
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(
                  color: themeData.primaryColor,
                  width: 1.5,
                ),
              ),

              // =========================
              // ERROR BORDER
              // =========================
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: Colors.red),
              ),

              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: Colors.red, width: 1.5),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =========================
  // BUTTON
  // =========================

  Widget _button(RegisterViewModel model) {
    final isEnabled = model.isFormValid();

    return Container(
      width: double.infinity,

      margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),

      child: ElevatedButton(
        onPressed: isEnabled
            ? () {
                model.registerPhoneNumber(context);
              }
            : null,

        style: ElevatedButton.styleFrom(
          elevation: 0,

          backgroundColor: isEnabled ? const Color(0xFFFFB113) : Colors.grey,

          padding: const EdgeInsets.symmetric(vertical: 18),

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),

        child: model.isLoading
            ? const SizedBox(
                height: 24,
                width: 24,

                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation(Colors.white),
                ),
              )
            : Text(
                'Daftar',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }
}
