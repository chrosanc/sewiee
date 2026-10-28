import 'package:flutter/material.dart';
import 'package:sewiee/app/theme.dart';

class PrimaryButton extends StatelessWidget {
  final String label;
  final bool isEnabled;
  final bool isLoading;
  final VoidCallback? onPressed;
  const PrimaryButton({super.key, required this.label, required this.isEnabled, required this.isLoading, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(

        onPressed: isEnabled && !isLoading ? onPressed : null,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: isEnabled ? const Color(0xFFFFB113) : Colors.grey,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: isLoading
            ? const SizedBox(
          height: 24,
          width: 24,
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(Colors.white),
            strokeWidth: 2,
          ),
        )
            : Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}


class SecondaryButton extends StatelessWidget {

  final bool isActive;
  final String label;

  final Function() onPressed;

  const SecondaryButton({
    super.key,
    required this.isActive,
    required this.onPressed, required this.label,
  });

  @override
  Widget build(BuildContext context) {

    final Color buttonColor =
    isActive ? themeData.primaryColor : Colors.red;

    return OutlinedButton(
      onPressed: onPressed,

      style: ButtonStyle(
        side: WidgetStatePropertyAll(
          BorderSide(
            color: buttonColor,
          ),
        ),

        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),

      child: Text(
        label,

        textAlign: TextAlign.center,

        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: buttonColor,
        ),
      ),
    );
  }
}
