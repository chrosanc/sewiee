import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sewiee/data/model/expedition_model.dart';

class ExpeditionService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final String collection = 'courier';

  Future<List<ExpeditionModel>> getAllExpedition() async {

      final result = await firestore.collection(collection).get();
      return result.docs
          .map((doc) => ExpeditionModel.fromFirestore(doc.data()))
          .toList();
  }
}
