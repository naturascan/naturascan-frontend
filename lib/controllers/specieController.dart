import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../assistants/sql_helper.dart';
import '../models/local/specieModel.dart';

class SpecieController extends GetxController {
  final RxList<SpecieModel> _specieList = <SpecieModel>[].obs;
  var isLoading = false.obs;
  var isReloading = false.obs;
  var currentPage = 1;

  List<SpecieModel> get specieList => _specieList;

  void fetchSpecies(
      {int limit = 10, int offset = 0, bool isReload = false}) async {
    isReload ? isReloading(true) : isLoading(true);
    try {
      final species = await SQLHelper.getItems(
        table: 'Species',
        limit: limit,
        offset: offset,
      );
      if (offset == 0) {
        _specieList.clear();
      }
      for (var specie in species) {
        if (!_specieList.any((s) => s.id == specie['id'])) {
          _specieList.add(SpecieModel.fromJson(specie));
        }
      }
    } catch (e) {
      print('Erreur lors de la récupération des espèces : $e');
    } finally {
      isReload ? isReloading(false) : isLoading(false);
      currentPage++;
      update();
    }
  }

  Future<void> addSpecie(Map<String, dynamic> data) async {
    try {
      data['id'] = const Uuid().v4(); // Génération d'un nouvel ID unique
      await SQLHelper.createItem(data, 'Species');
      _specieList.add(SpecieModel.fromJson(data));
    } catch (e) {
      print('Erreur lors de l\'ajout de l\'espèce : $e');
    } finally {
      Get.back(); // Retour à l'écran précédent
      update(); // Mise à jour de l'interface utilisateur
    }
  }

  Future<void> updateSpecie(String id, SpecieModel updatedSpecie) async {
    try {
      final index = _specieList.indexWhere((s) => s.id == id);
      if (index != -1) {
        _specieList[index] = updatedSpecie;
      }
      await SQLHelper.updateItem(id, updatedSpecie.toJson(), 'Species');
    } catch (e) {
      print('Erreur lors de la mise à jour de l\'espèce : $e');
    } finally {
      update();
    }
  }

  Future<void> deleteSpecie(String id) async {
    try {
      await SQLHelper.deleteItem(id, 'Species');
      _specieList.removeWhere((s) => s.id == id);
    } catch (e) {
      print('Erreur lors de la suppression de l\'espèce : $e');
    } finally {
      update();
    }
  }
  
  Future<void> deleteAllSpecies() async {
    try {
      await SQLHelper.deleteTable('Species');
      _specieList.clear();
    } catch (e) {
      print('Erreur lors de la suppression de l\'espèce : $e');
    } finally {
      update();
    }
  }
}
