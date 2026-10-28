import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/fa6_solid.dart';
import 'package:provider/provider.dart';
import 'package:sewiee/app/theme.dart';
import 'package:sewiee/app/utils/toast.dart';
import 'package:sewiee/data/model/address_model.dart';
import 'package:sewiee/presentation/account/address/address_viewmodel.dart';
import 'package:sewiee/presentation/account/address/search_address_screen.dart';
import 'package:sewiee/presentation/widget/button_widget.dart';
import 'package:sewiee/presentation/widget/search_widget.dart';

class CreateAddressScreen extends StatefulWidget {
  final AddressModel? addressModel;

  const CreateAddressScreen({super.key, this.addressModel});

  @override
  State<CreateAddressScreen> createState() => _CreateAddressScreenState();
}

class _CreateAddressScreenState extends State<CreateAddressScreen> {
  GoogleMapController? _mapController;
  CameraPosition? _currentCameraPosition;

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<AddressViewmodel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Pilih Lokasi Alamat', style: TextStyle(fontSize: 12)),
      ),
      body: SafeArea(
        child: Stack(
          alignment: Alignment.center,
          children: [
            /// =========================
            /// MAPS WIDGET
            /// =========================
            GoogleMap(
              onMapCreated: (GoogleMapController controller) async {
                _mapController = controller;
                if (widget.addressModel != null) {
                  final currentLocation = LatLng(
                    widget.addressModel!.latitude!,
                    widget.addressModel!.longitude!,
                  );

                  await controller.animateCamera(
                    CameraUpdate.newCameraPosition(
                      CameraPosition(
                        target: currentLocation,
                        zoom:15,
                      )
                    )
                  );
                }
              },
              initialCameraPosition: vm.initialCameraPosition,
              onCameraMove: (CameraPosition cameraPosition) async {
                setState(() {
                  _currentCameraPosition = cameraPosition;
                });
              },
              onCameraIdle: () async {
                final target = _currentCameraPosition?.target;
                if (target == null) return;
                await vm.updateSelectedLocation(target);
              },
            ),

            Icon(Icons.location_pin, color: themeData.primaryColor, size: 50),

            /// =========================
            /// LOCATION CARD
            /// =========================
            Align(
              alignment: AlignmentGeometry.bottomCenter,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Align(
                    alignment: AlignmentGeometry.bottomEnd,
                    child: Padding(
                      padding: EdgeInsetsGeometry.symmetric(horizontal: 10),
                      child: GestureDetector(
                        onTap: () async {
                          final currentLocation = await vm.getCurrentLocation();
                          if (currentLocation != null) {
                            await vm.updateSelectedLocation(currentLocation);
                            await _mapController?.animateCamera(
                              CameraUpdate.newCameraPosition(
                                CameraPosition(
                                  target: currentLocation,
                                  zoom: 15,
                                ),
                              ),
                            );
                          } else {
                            Toast().showToast(
                              context,
                              'Tolong aktifkan lokasi',
                            );
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: themeData.primaryColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.gps_fixed,
                                  size: 15,
                                  color: Colors.white,
                                ),
                                Gap(10),
                                Text(
                                  'Gunakan lokasi saat ini',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Gap(10),
                  Container(
                    color: Colors.white,
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SearchWidget(
                            onTap: () async {
                              final LatLng result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => SearchAddressScreen(),
                                ),
                              );

                              await vm.updateSelectedLocation(result);

                              await _mapController?.animateCamera(
                                CameraUpdate.newCameraPosition(
                                  CameraPosition(target: result, zoom: 15),
                                ),
                              );
                                                        },
                            enabled: false,
                            title: 'Cari Lokasi',
                          ),
                          Gap(20),
                          Row(
                            children: [
                              Iconify(Fa6Solid.location_dot, size: 20),
                              Gap(10),
                              Text(
                                vm.addressModel?.street ?? 'Sebentar ya...',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            '${vm.addressModel?.district}, ${vm.addressModel?.regency}, ${vm.addressModel?.village}',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          Gap(20),
                          PrimaryButton(
                            label: 'Pilih Lokasi',
                            isEnabled: true,
                            isLoading: false,
                            onPressed: () async {
                              Navigator.pop(
                                context,
                                vm.addressModel
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
