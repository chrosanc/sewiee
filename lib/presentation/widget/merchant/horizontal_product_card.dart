import 'package:flutter/material.dart';

class HorizontalProductCard extends StatelessWidget {
  final String? photoUrl;
  final String? category;
  final String? name;
  final String? price;
  final String? durationType;
  final bool active;
  final String? stock;
  const HorizontalProductCard({super.key, this.category, this.name, this.price, this.durationType, this.active = false, this.stock, this.photoUrl});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            photoUrl != null ? Image.network(photoUrl!, height: 50, width: 50, fit: BoxFit.cover,) : Container(
              height: 50,
              width: 50,
              color: Colors.grey,
            ),
            SizedBox(width: 10,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(category ?? 'Kategori', style: TextStyle(color:Colors.grey, fontSize: 10),),
                Text(name ?? 'Nama Produk', style: TextStyle(fontSize: 12),),
                Text('${price ?? 'Rp 100.000'} / ${durationType ?? 'Bulan'}', style: TextStyle(fontSize: 12),),
              ],
            )
          ],
        ),

        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(active ? 'Aktif' : 'Tidak Aktif' , style: TextStyle(color: active ? Colors.green : Colors.red, fontSize: 12),),
            Text('Stok: ${stock ?? '1'}', style: TextStyle(color:Colors.grey, fontSize: 12),),
          ],
        ),

      ],
    );
  }
}
