import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/arcticons.dart';
import 'package:iconify_flutter/icons/zondicons.dart';
import 'package:sewiee/app/theme.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Checkout', style: TextStyle(fontSize: 14))),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsetsGeometry.symmetric(horizontal: 20,vertical: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Alamat pengiriman kamu',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          SizedBox(height: 5,),


                          Row(
                            children: [
                              Iconify(
                                Zondicons.location,
                                color: themeData.primaryColor,
                                size: 15,
                              ),
                              SizedBox(width: 5,),
                              Text(
                                'Rumah',
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                              ),
                              SizedBox(width: 5,),
                              Text(
                                '|',
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                              ),
                              SizedBox(width: 5,),
                              Text(
                                'Full Name',
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                              ),

                            ],
                          ),


                          SizedBox(height: 5,),
                          Text(
                            'Karangsalam Kidul, Kec. Kedungbanteng, Kabupaten Banyumas',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 12, color: Colors.grey, ),
                            maxLines: 1,

                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Icon(Icons.keyboard_arrow_right_rounded, size: 20,),
                    )
                  ],
                ),
              ),

              Divider(thickness: 5, color: Colors.grey.shade200,),

              Padding(
                padding: EdgeInsetsGeometry.symmetric(vertical: 10, horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [

                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
