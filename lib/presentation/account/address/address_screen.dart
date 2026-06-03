import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:sewiee/app/theme.dart';
import 'package:sewiee/data/model/address_model.dart';
import 'package:sewiee/presentation/account/address/address_viewmodel.dart';
import 'package:sewiee/presentation/account/address/create_address_screen.dart';
import 'package:sewiee/presentation/account/address/edit_address_screen.dart';
import 'package:sewiee/presentation/widget/address/address_widget.dart';
import 'package:sewiee/presentation/widget/button_widget.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({super.key});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  bool isActive = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() async{
      await context.read<AddressViewmodel>().getCurrentUser();
      await Provider.of<AddressViewmodel>(context, listen: false).getUserAddresses();
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<AddressViewmodel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Pilih Alamat', style: TextStyle(fontSize: 12)),
        actionsPadding: EdgeInsetsGeometry.symmetric(horizontal: 20),
        actions: [
          GestureDetector(
            onTap: () async {
              vm.clearAddress();
              final AddressModel? result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => CreateAddressScreen()),
              );
              if (result != null && context.mounted) {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EditAddressScreen(addressModel: result),
                  ),
                );
              }

              await vm.getUserAddresses();
              setState(() {});
            },
            child: Text(
              'Tambah Alamat',
              style: TextStyle(fontSize: 12, color: themeData.primaryColor),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsetsGeometry.symmetric(horizontal: 20, vertical: 20),
        child: PrimaryButton(
          label: 'Pilih Alamat',
          isEnabled: true,
          isLoading: false,
          onPressed: () {
            Navigator.of(context).pop(vm.addresses[vm.selectedAddress!]);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              ListView.builder(
                itemCount: vm.addresses.length,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final address = vm.addresses[index];
                  return AddressWidget(
                    label: address!.label,
                    contactPhoneNumber: address.contactPhoneNumber,
                    contactName: address.contactName,
                    fullAddress: address.fullAddress,
        
                    isActive: vm.selectedAddress == index,
                    onDelete: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            backgroundColor: Colors.white,
                            title: Text(
                              'Hapus alamat ${address.label}?',
                              style: TextStyle(fontSize: 12),
                            ),
                            content: Text(
                              'Apakah anda yakin untuk menghapus alamat ini?',
                              style: TextStyle(fontSize: 12),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () async {
                                  await vm.deleteUserAddress(
                                    context,
                                    address.id!,
                                  );
                                  vm.getUserAddresses();
                                },
                                child: Text(
                                  'Hapus',
                                  style: TextStyle(fontSize: 12),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  'Batal',
                                  style: TextStyle(fontSize: 12),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    onTap: () {
                      vm.setSelectedAddress(index);
                    },
                    onAddressChangeButtonTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => EditAddressScreen(
                            addressModel: address,
                            addressId: address.id,
                          ),
                        ),
                      );
        
                      await vm.getUserAddresses();
        
                      if (context.mounted) {
                        setState(() {});
                      }
                    },
                  );
                },
              ),
              Gap(20),
        
            ],
          ),
        ),
      ),
    );
  }
}
