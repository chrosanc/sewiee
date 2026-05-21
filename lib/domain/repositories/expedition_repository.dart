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
}