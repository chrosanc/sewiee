import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:sewiee/app/theme.dart';

// ─── Design tokens ────────────────────────────────────────────────────────
const _kDark       = Color(0xFF1C1E26);
const _kAmber      = Color(0xFFFFB113);
const _kAmberLight = Color(0xFFFFF4E0);
const _kAmberText  = Color(0xFFB87214);
const _kBorder     = Color(0xFFE5E5E5);
const _kDivider    = Color(0xFFF0F0F0);
const _kSurface    = Color(0xFFF7F7F5);
const _kTextMain   = Color(0xFF1A1A1A);
const _kTextMuted  = Color(0xFF9CA3AF);

class MerchantVerifiedWidget extends StatelessWidget {
  final Function() onTap;
  final String? storeName;
  final String? totalProduct;
  final String? activeOrder;
  final String? storeRating;

  const MerchantVerifiedWidget({
    super.key,
    required this.onTap,
    this.storeName,
    this.totalProduct,
    this.activeOrder,
    this.storeRating,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _kBorder, width: 0.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header row: store name + kelola button ──────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Toko kamu',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: _kTextMuted,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    storeName ?? 'Nama Toko',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: _kTextMain,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),


            ],
          ),

          const SizedBox(height: 12),
          const Divider(height: 1, thickness: 1 ,color: _kDivider),
          const SizedBox(height: 12),


          // ── Stats row ───────────────────────────────────────────────
          Row(
            children: [
              _StatTile(
                // icon: Icons.inventory_2_rounded,
                label: 'Total Produk',
                value: totalProduct ?? '0',
              ),
              _StatDivider(),
              _StatTile(
                // icon: Icons.shopping_bag_rounded,
                label: 'Order Aktif',
                value: activeOrder ?? '0',
              ),
              _StatDivider(),
              _StatTile(
                // icon: Icons.star_rounded,
                label: 'Rating Toko',
                value: storeRating ?? 'N/A',
              ),
            ],
          ),

          Gap(10),

          // Kelola Toko button
          GestureDetector(
            onTap: onTap,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: themeData.primaryColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          'Kelola Toko',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 4),
                        Icon(
                          Icons.arrow_forward_rounded,
                          size: 12,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Single stat tile ─────────────────────────────────────────────────────
class _StatTile extends StatelessWidget {
  // final IconData icon;
  final String label;
  final String value;

  const _StatTile({
    // required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: _kAmberLight,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon(icon, size: 18, color: _kAmber),
            // const SizedBox(height: 5),


            Text(
              value,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: _kTextMain,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w600,
                color: _kAmberText,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Thin gap between stat tiles ──────────────────────────────────────────
class _StatDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) => const SizedBox(width: 8);
}