import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sewiee/data/model/address_model.dart';
import 'package:sewiee/data/services/address_service.dart';

class AddressRepository {
  final AddressService service = AddressService();

  Future<void> createAddress (String userId, AddressModel address) async {
    try{
      await service.createUserAddress(userId, address);
    } catch(e) {
      rethrow;
    }
  }

  Future<List<AddressModel?>> getUserAddresses(String userId) async {
    try{
      final result = await service.getUserAddresses(userId);
      return result;
    } catch(e) {
      rethrow;
    }
  }

  Future<void> updateUserAddress(String userId, AddressModel addressModel) async {
    try {
      final result = await service.updateUserAddress(userId, addressModel);
      return result;
    } catch (e){
      rethrow;
    }
  }

  Future<void> deleteUserAddress(String userId, String addressId) async{
    try {
      final result = await service.deleteUserAddress(userId, addressId);
      return result;
    } catch(e){
      rethrow;
    }
  }

}