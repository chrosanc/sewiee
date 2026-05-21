import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sewiee/app/utils/currency_utils.dart';

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

  @override
  Widget build(BuildContext context) {
    final defaultProductImage =
        "https://www.shipbob.com/wp-content/uploads/2022/06/PRODUCT-RANGE.jpg?w=1024";

    return SizedBox(
      height: 200, // 🔥 penting, biar Expanded punya batas
      child: GestureDetector(
        onTap: onTap,
        child: Card(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              /// 🔥 IMAGE
              SizedBox(
                width: double.infinity,
                height: 120, // 🔥 fix tinggi image
                child: Image.network(
                  imageUrl ?? defaultProductImage,
                  fit: BoxFit.cover,
                ),
              ),

              /// 🔽 CONTENT
              Expanded( // ✅ ini kunci
                child: Padding(
                  padding: const EdgeInsets.all(6),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// ATAS
                      Text(
                        productName ?? "Product Name",
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),

                      Text(
                        '${CurrencyUtils().currencyFormat(productPrice ?? 100000)} / $durationType',
                        style: GoogleFonts.poppins(
                          fontSize: 10,
                          color: Colors.orange,
                        ),
                      ),

                      Text(
                        '${category ?? 'Kategori'}',
                        style: GoogleFonts.poppins(
                          fontSize: 10,
                          color: Colors.grey,
                        ),
                      ),

                      // Text(
                      //   '${stock ?? 0} Tersedia',
                      //   style: GoogleFonts.poppins(
                      //     fontSize: 10,
                      //     color: Colors.grey,
                      //   ),
                      // ),

                      const Spacer(), // 🔥 dorong ke bawah

                      /// BAWAH
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              storeName ?? 'Store',
                              style: GoogleFonts.poppins(fontSize: 10),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 4),
                          // Text(
                          //   storeLocation?.replaceAll('Kecamatan', '') ?? 'Lokasi',
                          //   style: GoogleFonts.poppins(fontSize: 10),
                          //   overflow: TextOverflow.ellipsis,
                          // ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}