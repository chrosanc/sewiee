import 'package:flutter/material.dart';
import 'package:sewiee/app/theme.dart';
import 'package:sewiee/presentation/products/detail_product/product_detail_screen.dart';

class OrderDetailScreen extends StatefulWidget {
  const OrderDetailScreen({super.key});

  @override
  State<OrderDetailScreen> createState() => _OrderDetailState();
}

class _OrderDetailState extends State<OrderDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Detail Pesanan')),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Status Pesanan', style: TextStyle(fontSize: 18)),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Kode Pesanan', style: TextStyle(fontSize: 12)),
                      Text(
                        'INV/12222/122/12222',
                        style: TextStyle(
                          fontSize: 12,
                          color: themeData.primaryColor,
                        ),
                      ),
                    ],
                  ),

                  detailText('Tanggal Pembayaran', '05 April 2026, 17:05 WIB'),
                ],
              ),
            ),

            Divider(thickness: 4),

            Padding(
              padding: EdgeInsetsGeometry.symmetric(
                horizontal: 10,
                vertical: 10,
              ),
              child: GestureDetector(
                onTap: () {
                  // Navigator.push(context, MaterialPageRoute(builder: (context) => ProductDetailScreen()));
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Detail Produk', style: TextStyle(fontSize: 18)),
                    SizedBox(height: 20,),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(height: 50, width: 50, color: Colors.grey),
                        SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Products',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Rp 1000000',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            Divider(thickness: 4,),

            Padding(
              padding: EdgeInsetsGeometry.symmetric(
                horizontal: 10,
                vertical: 10,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Info Pengiriman', style: TextStyle(fontSize: 18)),
                  SizedBox(height: 20,),
                  detailText('Alamat', 'Jl Rayaj Beji Karangsalam')
                ],
              ),
            ),

            Divider(thickness: 4,),

            Padding(
              padding: EdgeInsetsGeometry.symmetric(
                horizontal: 10,
                vertical: 10,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Info Pengembalian', style: TextStyle(fontSize: 18)),
                  SizedBox(height: 20,),
                  detailText('Alamat', 'Jl Rayaj Beji Karangsalam')
                ],
              ),
            ),

            Divider(thickness: 4,),

            Padding(
              padding: EdgeInsetsGeometry.symmetric(
                horizontal: 10,
                vertical: 10,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Rincian Pembayaran', style: TextStyle(fontSize: 18)),
                  SizedBox(height: 20,),
                  detailText('Metode Pembayaran', 'BCA'),
                  detailText('Harga Barang', 'Rp25.000'),
                  detailText('Ongkos Kirim', 'Rp25.000')
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }

  Row detailText(String title, String description) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: TextStyle(fontSize: 12)),
        Text(description, style: TextStyle(fontSize: 12)),
      ],
    );
  }
}
