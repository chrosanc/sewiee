import 'package:sewiee/data/model/category_model.dart';

class ExpeditionModel {
  String id;
  String courierName;

  ExpeditionModel({required this.id, required this.courierName});

  factory ExpeditionModel.fromFirestore(Map<String, dynamic> data) {
    return ExpeditionModel(
      id: data['courier_code'] ?? '',
      courierName: data['courier_name'] ?? ''
    );
  }
}