import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/arcticons.dart';
import 'package:iconify_flutter/icons/fa6_solid.dart';
import 'package:iconify_flutter/icons/ion.dart';
import 'package:iconify_flutter/icons/lucide.dart';
import 'package:iconify_flutter/icons/mingcute.dart';
import 'package:iconify_flutter/icons/zondicons.dart';
import 'package:sewiee/app/theme.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.white,
      useLegacyColorScheme: false,
      selectedLabelStyle: GoogleFonts.poppins(
          color: const Color(0xFFFFB113),
          fontSize: 14,
          fontWeight: FontWeight.w600
      ),
      selectedItemColor: const Color(0xFFFFB113),
      unselectedLabelStyle: GoogleFonts.poppins(
          color: const Color.fromARGB(255, 128, 128, 128),
          fontSize: 14,
          fontWeight: FontWeight.w600
      ),
      unselectedItemColor: const Color(0xFFD8D8D8),
      currentIndex: currentIndex,
      onTap: onTap,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home, color: _getColor(0) ),
          label: 'Beranda',
        ),
        BottomNavigationBarItem(
          icon: Iconify(Ion.compass, color: _getColor(1),),
          label: 'Eksplor',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add, color: _getColor(2)),
          label: 'Sewakan',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.trolley, color: _getColor(3)) ,
          label: 'Pesanan',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person , color: _getColor(4)),
          label: 'Akun',
        ),
      ],
    );
  }

  Color _getColor(int index) {
    return currentIndex == index
        ? const Color(0xFFFFB113)
        : Colors.grey;
  }
}

