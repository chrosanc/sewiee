import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sewiee/app/theme.dart';
import 'package:sewiee/presentation/register/register_viewmodel.dart';
import 'package:sewiee/presentation/widget/button_widget.dart';
import 'package:sewiee/presentation/widget/text_input_widget.dart';

class RegisterMerchantScreen extends StatefulWidget {
  const RegisterMerchantScreen({super.key});

  @override
  State<RegisterMerchantScreen> createState() => _RegisterMerchantScreenState();
}

class _RegisterMerchantScreenState extends State<RegisterMerchantScreen> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController confirmPasswordController;
  late TextEditingController phoneController;

  @override
  void initState() {
    super.initState();
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
    phoneController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<RegisterViewModel>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: Padding(
        padding: EdgeInsetsGeometry.only(left: 20, right: 20, bottom: 30, top: 10),
        child: PrimaryButton(
          label: 'Lanjut',
          isEnabled: true,
          isLoading: false,
          onPressed: () {},
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Daftar Merchant.',
                      style: GoogleFonts.poppins(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: themeData.colorScheme.primary,
                      ),
                    ),
                    Text(
                      'Silakan daftarkan data diri Anda untuk melanjutkan.',
                      style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey),
                    ),
                    
                    SizedBox(height: 10),

                    Card(
                      color: Colors.white,
                      elevation: 5,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Info Usaha', style: TextStyle(fontSize: 18)),
                            Divider(),
                            SizedBox(height: 10,),

                            TextInputWidget(
                              title: 'Nama Toko',

                            ),
                            SizedBox(height: 20,),
                            SizedBox(height: 20,),
                            TextInputWidget(
                              title: 'Alamat / Lokasi',
                              hintText: 'Alamat lengkap pengembalian barang',
                            ),



                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
