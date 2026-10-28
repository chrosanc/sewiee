import 'package:flutter/material.dart';

class AddPhotosWidget extends StatelessWidget {
  final Function()? onTap;
  const AddPhotosWidget({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          border: Border.all(color: Colors.grey.shade300),
          color: Colors.grey.shade200
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_a_photo_outlined),
            SizedBox(height: 10,),
            Text('Tambah Foto Produk', style: TextStyle( fontSize: 12),)
          ],
        ),
      ),
    );
  }
}
