import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../assistants/sql_helper.dart';
import '../models/local/wasteModel.dart';

class WasteController extends GetxController {
  final RxList<WasteModel> _wasteList = <WasteModel>[].obs;
  var isLoading = false.obs;
  var isReloading = false.obs;
  var currentPage = 1;

  List<WasteModel> get wasteList => _wasteList;

  void fetchWasteList(
      {int limit = 10, int offset = 0, bool isReload = false}) async {
    isReload ? isReloading(true) : isLoading(true);
    try {
      final wasteData = await SQLHelper.getItems(
        table: 'Waste',
        limit: limit,
        offset: offset,
      );
      if (offset == 0) {
        _wasteList.clear();
      }
      for (var waste in wasteData) {
        if (!_wasteList.any((w) => w.id == waste['id'])) {
          _wasteList.add(WasteModel.fromJson(waste));
        }
      }
    } catch (e) {
      print('Erreur lors de la récupération des déchets : $e');
    } finally {
      isReload ? isReloading(false) : isLoading(false);
      currentPage++;
      update();
    }
  }

  Future<void> addWaste(Map<String, dynamic> data) async {
    try {
      data['id'] = const Uuid().v4(); // Génération d'un nouvel ID unique
      await SQLHelper.createItem(data, 'Waste');
      _wasteList.add(WasteModel.fromJson(data));
    } catch (e) {
      print('Erreur lors de l\'ajout du déchet : $e');
    } finally {
      Get.back(); // Retour à l'écran précédent
      update(); // Mise à jour de l'interface utilisateur
    }
  }

  Future<void> updateWaste(String id, WasteModel updatedWaste) async {
    try {
      final index = _wasteList.indexWhere((w) => w.id == id);
      if (index != -1) {
        _wasteList[index] = updatedWaste;
      }
      await SQLHelper.updateItem(id, updatedWaste.toJson(), 'Waste');
    } catch (e) {
      print('Erreur lors de la mise à jour du déchet : $e');
    } finally {
      update();
    }
  }

  Future<void> deleteWaste(String id) async {
    try {
      await SQLHelper.deleteItem(id, 'Waste');
      _wasteList.removeWhere((w) => w.id == id);
    } catch (e) {
      print('Erreur lors de la suppression du déchet : $e');
    } finally {
      update();
    }
  }
}
