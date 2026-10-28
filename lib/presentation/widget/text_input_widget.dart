import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sewiee/app/theme.dart';

class TextInputWidget extends StatelessWidget {
  final String? title;
  final TextEditingController? controller;
  final Function(String)? onChanged;
  final String? hintText;
  final TextInputType? keyboardType;
  final bool? isButton;
  final int? maxLines;
  final Function()? onTap;

  const TextInputWidget({
    super.key,
    this.controller,
    this.onChanged,
    this.hintText,
    this.title,
    this.keyboardType,
    this.isButton = false, this.onTap, this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        title != null ? Text(title!, style: TextStyle(fontSize: 12),) : SizedBox(),
        const SizedBox(height: 5),
        GestureDetector(
          onTap: isButton! ? onTap : () {},
          child: TextFormField(
            maxLines: maxLines ?? 1,
            minLines: 1,
            enabled: !isButton!,
            controller: controller,
            keyboardType: keyboardType,
            onChanged: onChanged,
            decoration: InputDecoration(
              suffixIcon: isButton! ? Icon(Icons.keyboard_arrow_right_outlined) : SizedBox(),
              border: InputBorder.none,
              hintText: hintText,
              hintStyle: TextStyle(color: Colors.grey, fontSize: 12),
              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: maxLines != null ? 10 : 0),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: themeData.primaryColor, width: 1.5),
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
        ),
      ],
    );
  }
}
