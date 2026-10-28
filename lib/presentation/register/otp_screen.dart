import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:provider/provider.dart';
import 'package:sewiee/app/theme.dart';
import 'package:sewiee/presentation/register/register_viewmodel.dart';
import 'package:sewiee/presentation/widget/button_widget.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  String _otpCode = "";

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<RegisterViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Verifikasi OTP"), centerTitle: true),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            Icon(
              Icons.lock_outline_rounded,
              size: 80,
              color: themeData.primaryColor,
            ),

            const SizedBox(height: 24),

            const Text(
              "Verifikasi Nomor Anda",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 12),

            Text(
              "Kode OTP sudah dikirim ke Whatsapp\n+62${viewModel
                  .userPhoneNumber ?? '-'}",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),

            const SizedBox(height: 32),

            OtpTextField(
              numberOfFields: 6,
              showFieldAsBox: true,
              borderRadius: BorderRadius.circular(12),
              fieldWidth: 45,
              contentPadding: const EdgeInsets.symmetric(vertical: 14),
              focusedBorderColor: themeData.primaryColor,
              enabledBorderColor: Colors.grey.shade300,
              cursorColor: themeData.primaryColor,

              textStyle: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),

              onCodeChanged: (String value) {
                setState(() {
                  _otpCode = value;
                });
              },

              onSubmit: (String verificationCode) {
                setState(() {
                  _otpCode = verificationCode;
                });
              },
            ),

            const SizedBox(height: 32),

            PrimaryButton(
              label: "Verify OTP",
              isEnabled: _otpCode.length == 6,
              isLoading: viewModel.isLoading,
              onPressed: () async {
                await viewModel.verifyOtpAndRegisterUser(
                    context, _otpCode);
              },
            ),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Tidak ada kode? '),
                GestureDetector(
                  onTap: viewModel.canResendOtp ? () async {
                    await viewModel.resendOtp(context);
                  } : null,
                  child: Text(viewModel.canResendOtp ? 'Kirim Ulang' : 'Kirim Ulang (${viewModel.resendCooldown})', style: TextStyle(color: viewModel.canResendOtp ? themeData.primaryColor : Colors.grey),),
                ),

              ],
            )
          ],
        ),
      ),
    );
  }
}
