import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sewiee/data/model/expedition_model.dart';
import 'package:http/http.dart' as http;


class ExpeditionService {
  final String apiKey = dotenv.get('ONGKIR_API_KEY');
  final String shippingCostUrl = 'https://use.api.co.id/expedition/shipping-cost';
  final String villageCodeUrl = 'https://use.api.co.id/regional/indonesia/villages';
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final String collection = 'courier';

  Future<List<ExpeditionModel>> getAllExpedition() async {

      final result = await firestore.collection(collection).get();
      return result.docs
          .map((doc) => ExpeditionModel.fromFirestore(doc.data()))
          .toList();
  }

  Future<List<ExpeditionModel>> getCourierById(List<String> ids) async {
    final result = await firestore.collection(collection).where('courier_code', whereIn: ids).get();
    return result.docs.map((e) => ExpeditionModel.fromFirestore(e.data())).toList();
  }

  //Ambil kode desa
  Future<String?> getVillageCode(
      String postalCode,
      String villageName,
      ) async {

      final uri = Uri.parse(
        villageCodeUrl,
      ).replace(
        queryParameters: {
          "name": villageName,
          "postal_code": postalCode,
          "page": "1",
        },
      );

      final response = await http.get(
        uri,
        headers: {
          "x-api-co-id": apiKey,
        },
      );

      if (response.statusCode != 200) {
        throw Exception(
          'Gagal mengambil kode desa',
        );
      }
      final json =
      jsonDecode(response.body);
      final data = json['data'];
      return data.first['code'];

  }

  Future<List<ShippingCostModel>>
  getShippingCost(
      String destinationVillageCode,
      String originVillageCode,
      int weight,
      ) async {

    try {

      final uri = Uri.parse(
        shippingCostUrl,
      ).replace(
        queryParameters: {
          'origin_village_code':
          originVillageCode,

          'destination_village_code':
          destinationVillageCode,

          'weight':
          weight.toString(),
        },
      );

      final response = await http.get(
        uri,
        headers: {
          "x-api-co-id": apiKey,
        },
      );

      debugPrint(response.body);

      if (response.statusCode != 200) {
        throw Exception(
          'Gagal mengambil ongkir',
        );
      }

      final json =
      jsonDecode(response.body);

      final Map<String, dynamic> data =
          json['data'] ?? {};


      final List couriers = data['couriers'] ?? [];

      return couriers
          .map(
            (e) =>
            ShippingCostModel
                .fromJson(e),
      )
          .toList();

    } catch (e) {

      debugPrint(e.toString());

      return [];
    }
  }



}
