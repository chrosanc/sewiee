import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sewiee/data/model/address_model.dart';

class AddressService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> createUserAddress(String userId, AddressModel address) async {
    await firestore
        .collection('users')
        .doc(userId)
        .collection('addresses')
        .doc(address.id)
        .set(address.toMap());
  }

  Future<List<AddressModel?>> getUserAddresses(String userId) async {
    final result = await firestore
        .collection('users')
        .doc(userId)
        .collection('addresses')
        .get();
    return result.docs.map((doc) => AddressModel.fromMap(doc.data())).toList();
  }

  Future<void> updateUserAddress(
    String userId,
    AddressModel addressModel,
  ) async {
    await firestore
        .collection('users')
        .doc(userId)
        .collection('addresses')
        .doc(addressModel.id)
        .update(addressModel.toMap());
  }

  Future<void> deleteUserAddress(String userId, String addressId ) async{
    await firestore.collection('users').doc(userId).collection('addresses').doc(addressId).delete();

  }
}
