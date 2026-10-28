import 'package:sewiee/data/model/expedition_model.dart';
import 'package:sewiee/data/services/expedition_service.dart';

class ExpeditionRepository {
  final ExpeditionService service = ExpeditionService();

  Future<List<ExpeditionModel>> getAllExpeditions() async {
    try{
      return await service.getAllExpedition();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<ExpeditionModel>> getExpeditionsById(List<String> ids) async {
    try {
      return await service.getCourierById(ids);
    } catch (e) {
      rethrow;
    }
  }

  Future<String?> getVillageCode(String postalCode, String villageName) async {
    try{
      return await service.getVillageCode(postalCode, villageName);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<ShippingCostModel>> getShippingCost(String destinationVillageCode , String originVillageCode, int weight) async {
    try{
      return await service.getShippingCost(destinationVillageCode, originVillageCode, weight);
    } catch (e){
      rethrow;
    }
  }
}