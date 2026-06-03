import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/fa6_solid.dart';
import 'package:provider/provider.dart';
import 'package:sewiee/app/theme.dart';
import 'package:sewiee/app/utils/toast.dart';
import 'package:sewiee/data/model/address_model.dart';
import 'package:sewiee/presentation/account/address/create_address_screen.dart';
import 'package:sewiee/presentation/widget/button_widget.dart';
import 'package:sewiee/presentation/widget/multiline_text_widget.dart';
import 'package:sewiee/presentation/widget/text_input_widget.dart';

import 'address_viewmodel.dart';

class EditAddressScreen extends StatefulWidget {
  final AddressModel? addressModel;
  final String? addressId;

  const EditAddressScreen({super.key, this.addressModel, this.addressId});

  @override
  State<EditAddressScreen> createState() => _EditAddressScreenState();
}

class _EditAddressScreenState extends State<EditAddressScreen> {
  // CONTROLLER
  final TextEditingController contactNameController = TextEditingController();
  final TextEditingController contactPhoneNumberController =
      TextEditingController();
  final TextEditingController labelController = TextEditingController();
  final TextEditingController regencyController = TextEditingController();
  final TextEditingController districtController = TextEditingController();
  final TextEditingController fullAddressController = TextEditingController();
  final TextEditingController courierMessageController =
      TextEditingController();

  //VARIABLE
  GoogleMapController? _mapController;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final vm = context.read<AddressViewmodel>();

      if (widget.addressModel != null) {
        vm.setAddress(widget.addressModel!);

        updateAddressForm(widget.addressModel!);
      }
    });
  }

  void updateAddressForm(AddressModel address) {
    final vm = context.read<AddressViewmodel>();

    if (contactNameController.text.isEmpty) {
      contactNameController.text = vm.userModel?.fullName ?? '';
    }

    if (contactPhoneNumberController.text.isEmpty) {
      contactPhoneNumberController.text = vm.userModel?.phoneNumber ?? '';
    }

    labelController.text = address.label ?? '';
    regencyController.text = address.regency ?? '';
    districtController.text = address.district ?? '';
    fullAddressController.text = address.fullAddress ?? '';
    courierMessageController.text = address.courierMessage ?? '';

    setState(() {});
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  bool get isFormValid {
    return contactNameController.text.trim().isNotEmpty &&
        contactPhoneNumberController.text.trim().isNotEmpty &&
        labelController.text.trim().isNotEmpty &&
        regencyController.text.trim().isNotEmpty &&
        districtController.text.trim().isNotEmpty &&
        fullAddressController.text.trim().isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<AddressViewmodel>(context);

    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      bottomNavigationBar: Container(
        color: Colors.white,
        child: Padding(
          padding: EdgeInsetsGeometry.all(20),
          child: PrimaryButton(
            label: 'Simpan',
            isEnabled: isFormValid,
            isLoading: false,
            onPressed: () async {
              final isEdit = widget.addressId != null;
              final result = isEdit
                  ? await vm.updateExistingAddress(
                contactName: contactNameController.text.trim(),
                contactPhoneNumber: contactPhoneNumberController.text.trim(),
                label: labelController.text.trim(),
                courierMessage: courierMessageController.text.trim(),
              )
                  : await vm.createAddressToFirestore(
                contactName: contactNameController.text.trim(),
                contactPhoneNumber: contactPhoneNumberController.text.trim(),
                label: labelController.text.trim(),
                courierMessage: courierMessageController.text.trim(),
              );

              if (!context.mounted) return;

              if (result) {
                Toast().showToast(
                  context,
                  isEdit
                      ? 'Berhasil mengubah alamat'
                      : 'Berhasil menambahkan alamat',
                );

                Navigator.pop(context, true);
              } else {
                Toast().showToast(
                  context,
                  isEdit
                      ? 'Gagal mengubah alamat'
                      : 'Gagal menambahkan alamat',
                );
              }
            },
          ),
        ),
      ),
      appBar: AppBar(
        actionsPadding: EdgeInsetsGeometry.symmetric(horizontal: 20),
        title: Text('Ubah Alamat', style: TextStyle(fontSize: 12)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// =========================
                /// MAPS CARD
                /// =========================
                Card(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 20,
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Iconify(Fa6Solid.location_dot, size: 20),
                                Gap(20),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      vm.addressModel?.street ?? 'Alamat',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                    SizedBox(
                                      width: 250,
                                      child: Text(
                                        '${vm.addressModel?.village}, ${vm.addressModel?.district}, ${vm.addressModel?.regency}',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            GestureDetector(
                              onTap: () async {
                                final AddressModel? result =
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => CreateAddressScreen(
                                          addressModel: vm.addressModel,
                                        ),
                                      ),
                                    );

                                if (result != null) {
                                  vm.setAddress(result);
                                  await _mapController?.animateCamera(
                                    CameraUpdate.newCameraPosition(
                                      CameraPosition(
                                        target: LatLng(
                                          result.latitude!,
                                          result.longitude!,
                                        ),
                                        zoom: 15,
                                      ),
                                    ),
                                  );
                                  setState(() {
                                    updateAddressForm(result);
                                  });
                                }
                              },
                              child: Text(
                                'Ubah >',
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                          ],
                        ),

                        Gap(10),

                        // MAPS LOCATION
                        SizedBox(
                          height: 150,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey.shade300,
                                  width: 0,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  GoogleMap(
                                    onMapCreated:
                                        (GoogleMapController controller) async {
                                          _mapController = controller;

                                          if (vm.selectedLatLng != null) {
                                            await controller.animateCamera(
                                              CameraUpdate.newCameraPosition(
                                                CameraPosition(
                                                  target: vm.selectedLatLng!,
                                                  zoom: 15,
                                                ),
                                              ),
                                            );
                                          }
                                        },
                                    webCameraControlEnabled: false,
                                    rotateGesturesEnabled: false,
                                    zoomGesturesEnabled: false,
                                    scrollGesturesEnabled: false,
                                    tiltGesturesEnabled: false,
                                    initialCameraPosition: CameraPosition(
                                      target: LatLng(
                                        widget.addressModel!.latitude!,
                                        widget.addressModel!.longitude!,
                                      ),
                                      zoom: 15,
                                    ),
                                    zoomControlsEnabled: false,
                                  ),
                                  Icon(
                                    Icons.location_pin,
                                    color: themeData.primaryColor,
                                    size: 40,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                Gap(10),

                /// =========================
                /// CONTACT CARD
                /// =========================
                Card(
                  color: Colors.white,
                  child: Padding(
                    padding: EdgeInsetsGeometry.symmetric(
                      horizontal: 20,
                      vertical: 20,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextInputWidget(
                          onChanged: (_) => setState(() {}),
                          controller: contactNameController,
                          title: 'Nama',
                          hintText: 'Tulis Nama Penerima / Pengirim',
                        ),
                        Gap(10),
                        TextInputWidget(
                          keyboardType: TextInputType.number,
                          onChanged: (_) => setState(() {}),
                          controller: contactPhoneNumberController,
                          title: 'Nomor Handphone',
                          hintText: '08xxxxxxxxxxxx',
                        ),
                      ],
                    ),
                  ),
                ),

                Gap(10),

                /// =========================
                /// ADDRESS CARD
                /// =========================
                Card(
                  color: Colors.white,
                  child: Padding(
                    padding: EdgeInsetsGeometry.symmetric(
                      horizontal: 20,
                      vertical: 20,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextInputWidget(
                          onChanged: (_) => setState(() {}),
                          controller: labelController,
                          title: 'Label',
                          hintText: 'Rumah, Apartemen, Kantor, dll',
                        ),
                        Gap(10),
                        TextInputWidget(
                          onChanged: (_) => setState(() {}),
                          controller: regencyController,
                          title: 'Kabupaten / Kota',
                          hintText: '',
                        ),
                        Gap(10),
                        TextInputWidget(
                          onChanged: (_) => setState(() {}),
                          controller: districtController,
                          title: 'Kecamatan',
                          hintText: '',
                        ),
                        Gap(10),
                        MultilineTextWidget(
                          onChanged: (_) => setState(() {}),
                          controller: fullAddressController,
                          title: 'Alamat Lengkap',
                          hintText: 'Lengkapi alamat sesuai titik lokasi',
                        ),
                        Gap(10),
                        TextInputWidget(
                          onChanged: (_) => setState(() {}),
                          controller: courierMessageController,
                          title: 'Pesan untuk Kurir (opsional)',
                          hintText: 'Disebelah toko , depan masjid, dll.',
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
