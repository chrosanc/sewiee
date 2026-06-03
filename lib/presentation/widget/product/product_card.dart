import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sewiee/app/utils/currency_utils.dart';

// ─── Design tokens ────────────────────────────────────────────────────────
const _kAmber      = Color(0xFFFFB113);
const _kAmberLight = Color(0xFFFFF4E0);
const _kAmberText  = Color(0xFFB87214);
const _kTextMain   = Color(0xFF1A1A1A);
const _kTextMuted  = Color(0xFF888888);
const _kDivider    = Color(0xFFF0F0F0);
const _kBorder     = Color(0xFFE5E5E5);

class ProductCard extends StatelessWidget {
  final String? imageUrl;
  final String? productName;
  final String? storeLocation;
  final int? productPrice;
  final int? stock;
  final String? storeName;
  final String? durationType;
  final String? category;
  final VoidCallback? onTap;

  const ProductCard({
    super.key,
    this.onTap,
    this.imageUrl,
    this.productName,
    this.productPrice,
    this.durationType,
    this.stock,
    this.storeName,
    this.storeLocation,
    this.category,
  });

  static const _defaultImage =
      "https://www.shipbob.com/wp-content/uploads/2022/06/PRODUCT-RANGE.jpg?w=1024";

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _kBorder, width: 0.5),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          // crossAxisAlignment fills the fixed grid cell width
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Image — fills remaining space above the fixed-height body ──
            Expanded(
              child: Image.network(
                imageUrl ?? _defaultImage,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: const Color(0xFFEEEEEE),
                  child: const Center(
                    child: Icon(
                      Icons.image_not_supported_outlined,
                      color: Color(0xFFBBBBBB),
                    ),
                  ),
                ),
              ),
            ),

            // ── Body — fixed height so the grid cell never overflows ───────
            SizedBox(
              height: 98,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(9, 7, 9, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Top: name + price
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          productName ?? 'Product Name',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: _kTextMain,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${CurrencyUtils().toRupiah(productPrice ?? 100000)} / ${durationType ?? 'hari'}',
                          style: GoogleFonts.poppins(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: _kAmber,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),

                    // Bottom: category badge + store row
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 1),
                          decoration: BoxDecoration(
                            color: _kAmberLight,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            category ?? 'Kategori',
                            style: GoogleFonts.poppins(
                              fontSize: 9,
                              color: _kAmberText,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(height: 5),
                        const Divider(height: 1, thickness: 0.5, color: _kDivider),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            Container(
                              width: 16,
                              height: 16,
                              decoration: const BoxDecoration(
                                color: _kAmber,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.storefront_rounded,
                                size: 10,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 5),
                            Expanded(
                              child: Text(
                                storeName ?? 'Store',
                                style: GoogleFonts.poppins(
                                  fontSize: 10,
                                  color: _kTextMuted,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}