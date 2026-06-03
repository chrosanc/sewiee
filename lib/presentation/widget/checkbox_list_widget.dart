import 'package:flutter/material.dart';

class CheckboxListWidget extends StatelessWidget {
  final bool value;
  final Function(bool?)? onChanged;
  final String title;
  final String? subtitle;
  final ListTileControlAffinity? controlAffinity;
  final EdgeInsetsGeometry? contentPadding;

  const CheckboxListWidget({
    super.key,
    required this.value,
    required this.onChanged,
    required this.title,
    this.controlAffinity,
    this.contentPadding, this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CheckboxListTile(
          // shape: RoundedRectangleBorder(
          //   borderRadius: BorderRadius.circular(12),
          // ),
          // tileColor: value
          //     ? themeData.primaryColor.withAlpha(20)
          //     : Colors.transparent,
          checkboxShape: CircleBorder(),
          value: value,
          onChanged: onChanged,
          subtitle: subtitle != null ? Text(subtitle!, style: TextStyle(fontSize: 12, color: Colors.grey),) : null,
          title: Text(title, style: TextStyle(fontSize: 12)),
          controlAffinity: controlAffinity,
          contentPadding: contentPadding,
          // checkboxShape: RoundedRectangleBorder(
          //   side: BorderSide(
          //     color: Colors.grey,
          //   ),
          //   borderRadius: BorderRadius.circular(50)
          // )
        ),
      ],
    );
  }
}
