import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../assistants/sql_helper.dart';
import '../models/local/legModel.dart';

class LegController extends GetxController {
  final RxList<LegModel> _legList = <LegModel>[].obs;
  var isLoading = false.obs;
  var isReloading = false.obs;
  var currentPage = 1;

  List<LegModel> get legList => _legList;

  void fetchLegs(
      {int limit = 10, int offset = 0, bool isReload = false}) async {
    isReload ? isReloading(true) : isLoading(true);
    try {
      final legs = await SQLHelper.getItems(
        table: 'Leg',
        limit: limit,
        offset: offset,
      );
      if (offset == 0) {
        _legList.clear();
      }
      for (var leg in legs) {
        if (!_legList.any((l) => l.id == leg['id'])) {
          _legList.add(LegModel.fromJson(leg));
        }
      }
    } catch (e) {
      print('Erreur lors de la récupération des trajets : $e');
    } finally {
      isReload ? isReloading(false) : isLoading(false);
      currentPage++;
      update();
    }
  }

  Future<void> addLeg(Map<String, dynamic> data) async {
    try {
      data['id'] = const Uuid().v4(); // Génération d'un nouvel ID unique
      await SQLHelper.createItem(data, 'Leg');
      _legList.add(LegModel.fromJson(data));
    } catch (e) {
      print('Erreur lors de l\'ajout du trajet : $e');
    } finally {
      Get.back(); // Retour à l'écran précédent
      update(); // Mise à jour de l'interface utilisateur
    }
  }

  Future<void> updateLeg(String id, LegModel updatedLeg) async {
    try {
      final index = _legList.indexWhere((l) => l.id == id);
      if (index != -1) {
        _legList[index] = updatedLeg;
      }
      await SQLHelper.updateItem(id, updatedLeg.toJson(), 'Leg');
    } catch (e) {
      print('Erreur lors de la mise à jour du trajet : $e');
    } finally {
      update();
    }
  }

  Future<void> deleteLeg(String id) async {
    try {
      await SQLHelper.deleteItem(id, 'Leg');
      _legList.removeWhere((l) => l.id == id);
    } catch (e) {
      print('Erreur lors de la suppression du trajet : $e');
    } finally {
      update();
    }
  }
}
