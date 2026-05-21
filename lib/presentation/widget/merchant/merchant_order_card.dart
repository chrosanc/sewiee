import 'package:flutter/material.dart';

class MerchantOrderCard extends StatelessWidget {
  const MerchantOrderCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(height: 50, width: 50, color: Colors.grey),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '14 Mei - 14 Juni',
                  style: TextStyle(color: Colors.grey, fontSize: 10),
                ),
                Text('Nama Produk', style: TextStyle(fontSize: 12)),
                Text('Rp 100.000', style: TextStyle(fontSize: 12)),
              ],
            ),
          ],
        ),

        Container(
          width: 80,
          decoration: BoxDecoration(
            color: Color(0xFFFFF3D6),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Text(
              'Menunggu Konfirmasi',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Color(0xFFD98E04),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
