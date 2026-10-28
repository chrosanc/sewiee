import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sewiee/app/utils/toast.dart';
import 'package:sewiee/data/model/address_model.dart';
import 'package:sewiee/data/model/user_model.dart';
import 'package:sewiee/domain/repositories/address_repository.dart';
import 'package:sewiee/domain/repositories/user_repository.dart';
import 'package:sewiee/main.dart';
import 'package:sewiee/presentation/widget/loading/loading_manager.dart';
import 'package:uuid/uuid.dart';

class AddressViewmodel extends ChangeNotifier {
  /// =========================
  /// GENERAL VARIABLE
  /// =========================
  final LoadingManager _loadingManager = serviceLocator<LoadingManager>();
  void _showLoadingDialog() => _loadingManager.showLoading();
  void _hideLoadingDialog() => _loadingManager.hideLoading();

  /// =========================
  /// USER VARIABLE
  /// =========================
  UserModel? userModel;
  UserRepository userRepository = UserRepository();

  /// =========================
  /// PLACES VARIABLE
  /// =========================
  String? placesAPI = dotenv.get("GOOGLE_MAPS_API_KEY");

  /// =========================
  /// ADDRESS VARIABLE
  /// =========================
  AddressModel? addressModel;
  List<AddressModel?> addresses = [];
  AddressRepository addressRepository = AddressRepository();
  int? selectedAddress = 0;

  /// =========================
  /// MAPS VARIABLE
  /// =========================

  LatLng? selectedLatLng;

  final Set<Marker> initialMarkers = {
    Marker(
      markerId: MarkerId('initialMarker'),
      position: LatLng(-6.1753083, 106.8271106),
    ),
  };

  final CameraPosition initialCameraPosition = CameraPosition(
    target: LatLng(-6.1753083, 106.8271106),
    zoom: 15,
  );

  /// =========================
  /// SETTERSSS
  /// =========================

  void setSelectedAddress(int? index) {
    selectedAddress = index;
    notifyListeners();
  }

  void setCurrentUser(UserModel? user) {
    userModel = user;
    notifyListeners();
  }

  /// =========================
  /// USER FUNCTIONS
  /// =========================

  Future<void> getCurrentUser() async {
    _showLoadingDialog();
    try {
      userModel = await userRepository.getCurrentUser();
    } catch (e) {
      rethrow;
    } finally {
      _hideLoadingDialog();
    }
  }

  /// =========================
  /// MAPS FUNCTIONS
  /// =========================

  void getMapsApi() {
    placesAPI = dotenv.get("GOOGLE_MAPS_API_KEY");
    notifyListeners();
  }

  Future<LatLng?> getCurrentLocation() async {
    _showLoadingDialog();

    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      return null;
    }

    permission = await Geolocator.checkPermission();
    try {
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return null;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        return null;
      }
      Position position = await Geolocator.getCurrentPosition();
      return LatLng(position.latitude, position.longitude);
    } catch (e) {
      rethrow;
    } finally {
      _hideLoadingDialog();
    }
  }

  Future<void> updateSelectedLocation(LatLng latLng) async {
    selectedLatLng = latLng;
    await getAddressFromLatLng(latLng.latitude, latLng.longitude);
    notifyListeners();
  }

  /// =========================
  /// ADDRESS FUNCTIONS
  /// =========================
  Future<void> getUserAddresses() async {
    _showLoadingDialog();

    try {
      addresses = await addressRepository.getUserAddresses(userModel!.uid);
      notifyListeners();
    } catch (e) {
      rethrow;
    } finally {
      _hideLoadingDialog();
    }
  }

  void setAddress(AddressModel address) {
    addressModel = address;

    selectedLatLng = LatLng(address.latitude!, address.longitude!);

    notifyListeners();
  }

  Future<void> getAddressFromLatLng(double latitude, double longitude) async {
    _showLoadingDialog();

    try {
      final placemarks = await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isEmpty) return;
      final place = placemarks.first;
      final String? street = place.street?.isNotEmpty == true
          ? place.street
          : place.thoroughfare?.isNotEmpty == true
          ? place.thoroughfare
          : place.name;

      final String? province = place.administrativeArea;
      final String? regency = place.subAdministrativeArea;
      final String? district = place.locality;
      final String? village = place.subLocality;
      final String? placePostCode = place.postalCode;

      final List<String> addressParts = [
        street ?? '',
        village ?? '',
        district ?? '',
        regency ?? '',
        province ?? '',
        placePostCode ?? '',
      ];

      final String fullAddress = addressParts
          .where((e) => e.isNotEmpty)
          .join(', ');

      if (addressModel?.id != null) {
        addressModel = addressModel!.copyWith(
          latitude: latitude,
          longitude: longitude,
          street: street ?? addressModel?.street,
          province: province ?? addressModel?.province,
          regency: regency ?? addressModel?.regency,
          district: district ?? addressModel?.district,
          village: village ?? addressModel?.village,
          postCode: placePostCode ?? addressModel?.postCode,
          fullAddress: fullAddress,
        );
      } else {
        addressModel = AddressModel(
          latitude: latitude,
          longitude: longitude,
          street: street,
          province: province,
          regency: regency,
          district: district,
          village: village,
          postCode: placePostCode,
          fullAddress: fullAddress,
        );
      }
      notifyListeners();
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      _hideLoadingDialog();
    }
  }

  Future<bool> createAddressToFirestore({
    required String contactName,
    required String contactPhoneNumber,
    String? courierMessage,
    required String label,
  }) async {
    if (addressModel == null || userModel == null) {
      return false;
    }

    final String addressId = Uuid().v4();

    _showLoadingDialog();

    try {
      addressModel = addressModel!.copyWith(
        id: addressId,
        contactName: contactName,
        contactPhoneNumber: contactPhoneNumber,
        courierMessage: courierMessage,
        label: label,
      );

      await addressRepository.createAddress(userModel!.uid, addressModel!);
      clearAddress();

      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    } finally {
      _hideLoadingDialog();
    }
  }

  Future<bool> updateExistingAddress({
    required String contactName,
    required String contactPhoneNumber,
    String? courierMessage,
    required String label,
  }) async {
    if (addressModel == null || userModel == null) {
      return false;
    }

    _showLoadingDialog();

    try {
      addressModel = addressModel!.copyWith(
        contactName: contactName,
        contactPhoneNumber: contactPhoneNumber,
        courierMessage: courierMessage ?? '',
        label: label,
      );
      await addressRepository.updateUserAddress(userModel!.uid, addressModel!);

      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    } finally {
      _hideLoadingDialog();
    }
  }

  Future<void> deleteUserAddress(BuildContext context, String addressId) async {
    _showLoadingDialog();
    try {
      await addressRepository.deleteUserAddress(userModel!.uid, addressId);
      Navigator.pop(context);
      Toast().showToast(context, 'Berhasil Menghapus Alamat');
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      _hideLoadingDialog();
    }
  }

  /// =========================
  /// RESET
  /// =========================

  void clearAddress() {
    addressModel = null;
    selectedLatLng = null;

    notifyListeners();
  }
}
