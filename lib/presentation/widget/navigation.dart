import 'package:flutter/material.dart';

// ─── Design tokens ────────────────────────────────────────────────────────
const _kPrimary  = Color(0xFFFFB113);
const _kBg       = Colors.white;
const _kInactive = Color(0xFF6B7280);

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  static const _items = [
    _NavData(label: 'Beranda', icon: Icons.home_rounded,         iconOff: Icons.home_outlined),
    _NavData(label: 'Eksplor', icon: Icons.explore_rounded,      iconOff: Icons.explore_outlined),
    _NavData(label: 'Sewakan', icon: Icons.add_box_rounded,      iconOff: Icons.add_box_outlined),
    _NavData(label: 'Pesanan', icon: Icons.receipt_long_rounded,  iconOff: Icons.receipt_long_outlined),
    _NavData(label: 'Akun',    icon: Icons.person_rounded,       iconOff: Icons.person_outline_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _kBg,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(30),
            blurRadius: 24,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 10, 8, 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // ── Left items ───────────────────────────────────────────
              ...[0, 1, 2 ,3 ,4].map((i) => _NavItem(
                index: i,
                data: _items[i],
                isSelected: currentIndex == i,
                onTap: onTap,
              )),

              // // ── Centre Sewakan (index 2) ──────────────────────────────
              // _SewakButton(onTap: () => onTap(2)),
              //
              // // ── Right items (list index 2,3 → tab index 3,4) ─────────
              // ...[2, 3].map((i) => _NavItem(
              //   index: i + 1,
              //   data: _items[i],
              //   isSelected: currentIndex == i + 1,
              //   onTap: onTap,
              // )),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Regular tab item ─────────────────────────────────────────────────────
class _NavItem extends StatelessWidget {
  final int index;
  final _NavData data;
  final bool isSelected;
  final Function(int) onTap;

  const _NavItem({
    required this.index,
    required this.data,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 58,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? data.icon : data.iconOff,
              size: 22,
              color: isSelected ? _kPrimary : _kInactive,
            ),
            const SizedBox(height: 4),
            Text(
              data.label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                color: isSelected ? _kPrimary : _kInactive,
              ),
            ),
            const SizedBox(height: 5),
            AnimatedContainer(
              duration: const Duration(milliseconds: 260),
              curve: Curves.easeOutCubic,
              height: 2.5,
              width: isSelected ? 20.0 : 0.0,
              decoration: BoxDecoration(
                color: _kPrimary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Centre Sewakan button ─────────────────────────────────────────────────
class _SewakButton extends StatelessWidget {
  final VoidCallback onTap;
  const _SewakButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 58,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.add_box_rounded,
              size: 22,
              color: _kPrimary,
            ),
            const SizedBox(height: 4),
            const Text(
              'Sewakan',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: _kPrimary,
              ),
            ),
            const SizedBox(height: 5),
            Container(
              height: 2.5,
              width: 20,
              decoration: BoxDecoration(
                color: _kPrimary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Data model ───────────────────────────────────────────────────────────
class _NavData {
  final String label;
  final IconData icon;
  final IconData iconOff;
  const _NavData({
    required this.label,
    required this.icon,
    required this.iconOff,
  });
}