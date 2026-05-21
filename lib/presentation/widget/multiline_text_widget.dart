import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sewiee/app/theme.dart';

class MultilineTextWidget extends StatelessWidget {
  final TextEditingController? controller;
  final Function(String)? onChanged;
  final String? hintText;
  final String title;
  final bool opsional;

  const MultilineTextWidget({
    super.key,
    this.controller,
    this.onChanged,
    this.hintText,
    required this.title,
    this.opsional = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(title, style: TextStyle(fontSize: 12),),
            SizedBox(width: 6),
            if (opsional) ...[
              Text(
                "(Opsional)",
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ]
          ],
        ),
        const SizedBox(height: 5),
        TextFormField(
          controller: controller,
          onChanged: onChanged,
          keyboardType: TextInputType.multiline,
          minLines: 3,
          maxLines: 5,
          // 🔥 lebih panjang dari input biasa
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hintText ?? "Tulis deskripsi produk kamu...",
            hintStyle: const TextStyle(color: Colors.grey, fontSize: 12),
            contentPadding: const EdgeInsets.all(16),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: themeData.primaryColor,
                width: 1.5,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red),
            ),

            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red, width: 1.5),
            ),
          ),
          style: GoogleFonts.poppins(fontSize: 12),
        ),
      ],
    );
  }
}
