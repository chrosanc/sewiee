import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sewiee/app/theme.dart';

class LoadingDialog {
  static void show(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withAlpha(80),
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          content: Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Container(
                color: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 30),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    LoadingAnimationWidget.discreteCircle(
                      thirdRingColor: Colors.green,
                      color: themeData.primaryColor,
                      size: 30,
                    ),
                    Gap(20),
                    Text('Memuat...', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: themeData.primaryColor),)
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  static void hide(BuildContext context) {
    Navigator.pop(context);
  }
}