import 'package:flutter/material.dart';
import 'package:sewiee/app/screen_theme/order_detail_theme.dart';
import 'package:sewiee/domain/enum/order_status.dart';

import '../../../app/utils/helpers/order_utils.dart';

// ── Section card shell ────────────────────────────────────────────────────────

class SectionCard extends StatelessWidget {
  final Color iconBg;
  final Color iconColor;
  final IconData iconData;
  final String title;
  final Widget child;

  const SectionCard({
    super.key,
    required this.iconBg,
    required this.iconColor,
    required this.iconData,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: OrderDetailTheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: OrderDetailTheme.border, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 11, 14, 10),
            child: Row(
              children: [
                Container(
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                    color: iconBg,
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: Icon(iconData, size: 14, color: iconColor),
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: OrderDetailTheme.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 0.5, color: OrderDetailTheme.divider),
          child,
        ],
      ),
    );
  }
}

// ── Info row ──────────────────────────────────────────────────────────────────

class InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final bool last;

  const InfoRow({
    super.key,
    required this.label,
    required this.value,
    this.last = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: OrderDetailTheme.textMuted,
                ),
              ),
              Flexible(
                child: Text(
                  value,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: OrderDetailTheme.textPrimary,
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
        ),
        if (!last)
          const Divider(
            height: 0.5,
            color: OrderDetailTheme.divider,
            indent: 14,
            endIndent: 14,
          ),
      ],
    );
  }
}

// ── Status badge ──────────────────────────────────────────────────────────────

class StatusBadge extends StatelessWidget {
  final BadgeConfig config;

  const StatusBadge({super.key, required this.config});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: config.bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: config.dot, shape: BoxShape.circle),
          ),
          const SizedBox(width: 5),
          Text(
            config.label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: config.text,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Action button ─────────────────────────────────────────────────────────────

class ActionButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final Color bg;
  final Color textColor;
  final Color borderColor;

  const ActionButton({
    super.key,
    required this.label,
    required this.onTap,
    required this.bg,
    required this.textColor,
    required this.borderColor,
  });

  factory ActionButton.primary({
    required String label,
    required VoidCallback onTap,
  }) {
    return ActionButton(
      label: label,
      onTap: onTap,
      bg: OrderDetailTheme.textPrimary,
      textColor: Colors.white,
      borderColor: OrderDetailTheme.textPrimary,
    );
  }

  factory ActionButton.danger({
    required String label,
    required VoidCallback onTap,
  }) {
    return ActionButton(
      label: label,
      onTap: onTap,
      bg: const Color(0xFFFCEBEB),
      textColor: const Color(0xFFA32D2D),
      borderColor: const Color(0xFFF09595),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 46,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: borderColor, width: 0.5),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
      ),
    );
  }
}

// ── Dialog button ─────────────────────────────────────────────────────────────

class DialogButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final Color bg;
  final Color textColor;
  final Color borderColor;
  final bool showCheck;

  const DialogButton({
    super.key,
    required this.label,
    required this.onTap,
    required this.bg,
    required this.textColor,
    required this.borderColor,
    required this.showCheck,
  });

  factory DialogButton.primary({
    required String label,
    required VoidCallback onTap,
  }) {
    return DialogButton(
      label: label,
      onTap: onTap,
      bg: OrderDetailTheme.textPrimary,
      textColor: Colors.white,
      borderColor: OrderDetailTheme.textPrimary,
      showCheck: true,
    );
  }

  factory DialogButton.secondary({
    required String label,
    required VoidCallback onTap,
  }) {
    return DialogButton(
      label: label,
      onTap: onTap,
      bg: const Color(0xFFF8F7F4),
      textColor: const Color(0xFF5F5E5A),
      borderColor: OrderDetailTheme.border,
      showCheck: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 44,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: borderColor, width: 0.5),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showCheck) ...[
              const Icon(Icons.check, size: 15, color: Colors.white),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Image fallbacks ───────────────────────────────────────────────────────────

class ProductImageFallback extends StatelessWidget {
  const ProductImageFallback({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        color: OrderDetailTheme.iconBg,
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Icon(
        Icons.checkroom_outlined,
        size: 26,
        color: OrderDetailTheme.textDisabled,
      ),
    );
  }
}

class SmallImageFallback extends StatelessWidget {
  const SmallImageFallback({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: OrderDetailTheme.iconBg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: const Icon(
        Icons.checkroom_outlined,
        size: 16,
        color: OrderDetailTheme.textDisabled,
      ),
    );
  }
}

// ── Method icon & text ────────────────────────────────────────────────────────

class MethodIcon extends StatelessWidget {
  final Color color;
  final Color iconColor;
  final IconData icon;

  const MethodIcon({
    super.key,
    required this.color,
    required this.iconColor,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(9),
      ),
      child: Icon(icon, size: 17, color: iconColor),
    );
  }
}

class MethodText extends StatelessWidget {
  final String title;
  final String subtitle;

  const MethodText({super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: OrderDetailTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 1),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 10,
              color: OrderDetailTheme.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}

class SelectionIndicator extends StatelessWidget {
  final bool selected;

  const SelectionIndicator({super.key, required this.selected});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: selected ? const Color(0xFF185FA5) : Colors.transparent,
        border: Border.all(
          color: selected ? const Color(0xFF185FA5) : const Color(0xFFD3D1C7),
          width: 1.5,
        ),
      ),
      child: selected
          ? const Icon(Icons.check, size: 12, color: Colors.white)
          : null,
    );
  }
}