import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DropdownWidget<T> extends StatelessWidget {
  final List<T> items;
  final T? selectedValue;
  final String? title;
  final void Function(T?) onChanged;
  final String Function(T) itemLabel;
  final String? hintText;

  const DropdownWidget({
    super.key,
    required this.selectedValue,
    required this.onChanged,
    required this.items,
    required this.itemLabel,
    this.title,
    this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
          Text(
            title ?? '',
            style: GoogleFonts.poppins(
              fontSize: 12,
            ),
          ),
        const SizedBox(height: 6),
        DropdownButtonFormField<T>(
          initialValue: selectedValue,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down_rounded),
          items: items.map((item) {
            return DropdownMenuItem<T>(
              value: item,
              child: Text(
                itemLabel(item),
                overflow: TextOverflow.ellipsis,
              ),
            );
          }).toList(),
          onChanged: onChanged,
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: Colors.black,
          ),
          decoration: InputDecoration(
            hintText: hintText ?? 'Pilih',
            hintStyle: GoogleFonts.poppins(
              fontSize: 12,
              color: Colors.grey,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            filled: true,
            fillColor: Colors.white,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Colors.grey.shade300,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Color(0xFFffb113),
              ),
            ),
          ),
        ),
      ],
    );
  }
}