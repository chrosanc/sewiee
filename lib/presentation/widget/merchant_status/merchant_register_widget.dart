import 'package:flutter/material.dart';
import 'package:sewiee/app/theme.dart';

class MerchantRegisterWidget extends StatelessWidget {
  final Function() onTap;
  const MerchantRegisterWidget({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Icon(Icons.store, size: 30, color: themeData.primaryColor),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Merchant',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                  ),
                  Text(
                    'Sewakan barang tidak terpakaimu \nsekarang juga!',
                    maxLines: 2,
                    style: TextStyle(fontSize: 10),
                  ),
                ],
              ),

              GestureDetector(
                onTap: onTap,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: themeData.primaryColor
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    child: Text('Daftar', style: TextStyle(color: Colors.white, fontSize: 10),),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
