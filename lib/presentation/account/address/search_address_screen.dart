import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_sdk_flutter/google_places_sdk_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sewiee/app/theme.dart';
import 'package:sewiee/presentation/account/address/address_viewmodel.dart';

class SearchAddressScreen extends StatefulWidget {
  const SearchAddressScreen({super.key});

  @override
  State<SearchAddressScreen> createState() => _SearchAddressScreenState();
}

class _SearchAddressScreenState extends State<SearchAddressScreen> {
  final controller = PlacesAutocompleteController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<AddressViewmodel>(context, listen: false).getMapsApi();
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<AddressViewmodel>(context);
    final client = PlacesClient(apiKey: vm.placesAPI!);
    return Scaffold(
      appBar: AppBar(
        title: Text('Cari Alamat', style: TextStyle(fontSize: 12)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsetsGeometry.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              children: [
                PlacesAutocompleteField(
                  fetchPlaceDetailsOnSelection: true,
                  showPoweredByGoogle: false,
                  client: client,
                  controller: controller,
                  regionCode: 'id',
                  languageCode: 'id',
                  onSelection: (value) {
                    if (value.place != null) {
                      final latLng = LatLng(
                        value.place!.location!.latitude,
                        value.place!.location!.longitude,
                      );

                      Navigator.pop(context, latLng);
                    }
                  },
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    hintStyle: TextStyle(fontSize: 12),
                    contentPadding: EdgeInsets.symmetric(vertical: 10),
                    hintText: 'Cari Alamat kamu',
                    prefixIcon: Icon(Icons.search, size: 20),
                    filled: false,
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: themeData.primaryColor),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),

                // SearchWidget(
                //   enabled: true,
                //   title: 'Cari Alamat',
                //   onChanged: (value) {
                //     vm.searchAddress(value);
                //   },
                // ),
                // Gap(10),
                //
                // ListView.builder(
                //   shrinkWrap: true,
                //   itemCount: vm.predictions.length,
                //   itemBuilder: (context, index) {
                //     final prediction = vm.predictions[index];
                //     return ListTile(
                //       title: Text(
                //         prediction.primaryText,
                //         style: TextStyle(fontSize: 12),
                //       ),
                //       subtitle: Text(
                //         prediction.fullText,
                //         style: TextStyle(fontSize: 12),
                //       ),
                //       onTap: (){
                //
                //       },
                //     );
                //   },
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
