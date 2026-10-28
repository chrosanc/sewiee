import 'package:flutter/material.dart';
import 'package:sewiee/app/theme.dart';

class ChipWidget extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Function(bool)? onSelected;

  const ChipWidget({
    super.key,
    required this.label,
    required this.onSelected,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      selected: isSelected,
      onSelected: onSelected,

      showCheckmark: true,

      backgroundColor: Colors.grey.shade200,
      selectedColor: themeData.primaryColor.withAlpha(20),

      surfaceTintColor: Colors.transparent,

      elevation: 0,
      pressElevation: 0,

      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 10,
      ),

      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,


      label: AnimatedDefaultTextStyle(
        duration: const Duration(milliseconds: 200),
        style: TextStyle(
          fontSize: 12,
          color: isSelected
              ? themeData.primaryColor
              : Colors.black,
        ),
        child: Text(label),
      ),

      side: BorderSide(
        color: isSelected
            ? themeData.primaryColor.withAlpha(60)
            : Colors.transparent,
      ),

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50),
      ),
    );
  }
}