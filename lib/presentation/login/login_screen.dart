import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sewiee/presentation/login/login_viewmodel.dart';
import 'package:sewiee/presentation/register/register_screen.dart';
import 'package:sewiee/presentation/widget/button_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();



  @override
  Widget build(BuildContext context) {
    final loginViewModel = Provider.of<LoginViewModel>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Center(
              child: Column(

                children: [
                  const SizedBox(height: 100),
                  Column(
                    children: [
                      const SizedBox(height: 25),
                      Text(
                        'Sewiee.',
                        style: GoogleFonts.poppins(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFFFFB113),
                        ),
                      ),
                      const SizedBox(height: 84),
                      Text(
                        'Masuk ke akun Anda',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 25),
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 25),
                    padding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFAFAFA),
                      border: Border.all(color: const Color(0xFF9E9E9E)),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: TextFormField(
                      controller: emailController,
                      onChanged: (value) {
                        loginViewModel.updateEmailFilled(value.isNotEmpty);
                      },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Email atau Nomor Telepon",
                        prefixIcon: const Icon(
                          Icons.email,
                          color: Color(0xFF9E9E9E),
                        ),
                        contentPadding:
                        const EdgeInsets.symmetric(vertical: 18),
                        hintStyle: GoogleFonts.poppins(
                          fontSize: 14,
                          height: 140 / 100,
                          letterSpacing: 0.2,
                          color: const Color(0xFF9E9E9E),
                        ),
                      ),
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 25),
                    padding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFAFAFA),
                      border: Border.all(color: const Color(0xFF9E9E9E)),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: TextFormField(
                      controller: passwordController,
                      obscureText: loginViewModel.obscureText,
                      onChanged: (value) {
                        loginViewModel.updatePasswordFilled(value.isNotEmpty);
                      },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Password",
                        prefixIcon: const Icon(
                          Icons.lock,
                          color: Color(0xFF9E9E9E),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            Icons.remove_red_eye_sharp
                          ),
                          onPressed: () {
                            loginViewModel.togglePasswordVisibility();
                          },
                        ),
                        contentPadding:
                        const EdgeInsets.symmetric(vertical: 18),
                        hintStyle: GoogleFonts.poppins(
                          fontSize: 14,
                          height: 140 / 100,
                          letterSpacing: 0.2,
                          color: const Color(0xFF9E9E9E),
                        ),
                      ),
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  GestureDetector(
                    onTap: () {
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => ForgotpasswordScreen()));
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 27),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'Lupa Password?',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFFFFB113),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: PrimaryButton(
                        label: "Masuk",
                        isEnabled: emailController.text.isNotEmpty && passwordController.text.isNotEmpty,
                        isLoading: loginViewModel.loading,
                        onPressed: () {
                          loginViewModel.login(context, emailController.text.trim(), passwordController.text.trim());
                        }),
                  ),
                  const SizedBox(height: 25),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 25),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: 'Belum memiliki akun? ',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: const Color(0xFF9E9E9E),
                        ),
                        children: [
                          TextSpan(
                            text: 'Daftar disini',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFFFFB113),
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => RegisterScreen(),
                                  ),
                                );
                              },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
