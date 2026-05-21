import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:sewiee/app/theme.dart';

class AddressWidget extends StatelessWidget {
  final String? label;
  final String? contactName;
  final String? contactPhoneNumber;
  final String? fullAddress;
  final bool isActive;
  final Function()? onTap;
  final Function()? onAddressChangeButtonTap;
  final Function()? onDelete;

  const AddressWidget({
    super.key,
    required this.isActive,
    this.onTap,
    this.onAddressChangeButtonTap,
    this.label,
    this.contactName,
    this.contactPhoneNumber,
    this.fullAddress,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: GestureDetector(
            onTap: onTap,
            child: Container(
              width: double.infinity,
              decoration: isActive == false
                  ? BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                      border: Border.all(color: Colors.grey.shade400),
                    )
                  : BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: themeData.primaryColor.withAlpha(20),
                      border: Border.all(color: themeData.primaryColor),
                    ),
              child: Padding(
                padding: EdgeInsetsGeometry.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                child: Stack(
                  children: [
                    Align(
                      alignment: AlignmentGeometry.topEnd,

                      child: GestureDetector(
                        onTap: onDelete,
                        child: Icon(
                          Icons.delete_outline,
                          color: Colors.red,
                          size: 25,
                        ),
                      ),
                    ),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          label ?? '',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Gap(10),
                        Text(
                          contactName ?? '',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Gap(5),
                        Text(
                          contactPhoneNumber ?? '',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        Gap(5),
                        Text(
                          fullAddress ?? '',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        Gap(10),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            style: ButtonStyle(
                              backgroundColor: WidgetStatePropertyAll(
                                Colors.white,
                              ),
                              shape: WidgetStatePropertyAll(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadiusGeometry.circular(
                                    12,
                                  ),
                                ),
                              ),
                              side: WidgetStatePropertyAll(
                                BorderSide(color: Colors.grey.shade300),
                              ),
                            ),
                            onPressed: onAddressChangeButtonTap,
                            child: Text(
                              'Ubah Alamat',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
