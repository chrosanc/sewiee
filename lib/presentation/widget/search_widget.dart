import 'package:flutter/material.dart';
import 'package:sewiee/app/theme.dart';

class SearchWidget extends StatelessWidget {
  final TextEditingController? controller;
  final bool enabled;
  final String title;
  final Function()? onTap;
  final Function(String)? onChanged;
  const SearchWidget({super.key, required this.enabled, required this.title, this.onTap, this.controller, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: TextField(
        onChanged: onChanged,
        controller: controller,
        enabled: enabled,
        style: TextStyle(fontSize: 12),
        decoration: InputDecoration(
          hintStyle: TextStyle(fontSize: 12),
          contentPadding: EdgeInsets.symmetric(vertical: 10),
          hintText: title,
          prefixIcon: Icon(Icons.search, size: 20,),
          filled:false,
          border: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(12)),
          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: themeData.primaryColor), borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
