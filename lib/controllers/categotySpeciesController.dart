import 'package:get/get.dart';
import 'package:naturascan/models/local/specieModel.dart';
import 'package:uuid/uuid.dart';
import '../assistants/sql_helper.dart';
import '../models/local/categorySpecies.dart';

class CategorySpeciesController extends GetxController {
  final RxList<CategorySpeciesModel> _categorySpeciesList =
      <CategorySpeciesModel>[].obs;
  var isLoading = false.obs;
  var isReloading = false.obs;
  var currentPage = 1;
 Rx<CategorySpeciesModel> selectedCateory = categories.first.obs;
 Rx<SpecieModel> selectedSpecie = categories.first.especes!.first.obs;

  List<CategorySpeciesModel> get categorySpeciesList => _categorySpeciesList;

  Future<void> fetchCategorySpecies(
      {int limit = 100, int offset = 0, bool isReload = false}) async {
    isReload ? isReloading(true) : isLoading(true);
    try {
      final categories = await SQLHelper.getItems(
        table: 'CategorySpecies',
        limit: limit,
        offset: offset,
      );
      if (offset == 0) {
        _categorySpeciesList.clear();
      }
      for (var category in categories) {
        if (!_categorySpeciesList.any((c) => c.id == category['id'])) {
          _categorySpeciesList.add(CategorySpeciesModel.fromJson(category));
        }
      }
       print("cat cat cat cat ${_categorySpeciesList.length}");
      selectedCateory.value = _categorySpeciesList.first;
      if(selectedCateory.value.especes != null && selectedCateory.value.especes!.isNotEmpty){
        selectedSpecie = SpecieModel().obs;
      selectedSpecie.value = selectedCateory.value.especes!.first;
      }
    } catch (e) {
      print('Erreur lors de la récupération des catégories d\'espèces : $e');
    } finally {
      isReload ? isReloading(false) : isLoading(false);
      currentPage++;
      update();
    }
  }

  Future<void> addCategorySpecies(Map<String, dynamic> data) async {
    try {
      await SQLHelper.createItem2(data, 'CategorySpecies');
      _categorySpeciesList.add(CategorySpeciesModel.fromJson(data));
    } catch (e) {
      print('Erreur lors de l\'ajout de la catégorie d\'espèces : $e');
    } finally {
      Get.back(); // Retour à l'écran précédent
      update(); // Mise à jour de l'interface utilisateur
    }
  }

  Future<void> updateCategorySpecies(
      String id, CategorySpeciesModel updatedCategorySpecies) async {
    try {
      final index = _categorySpeciesList.indexWhere((c) => c.id == id);
      if (index != -1) {
        _categorySpeciesList[index] = updatedCategorySpecies;
      }
      await SQLHelper.updateItem(
          id, updatedCategorySpecies.toJson(), 'CategorySpecies');
    } catch (e) {
      print('Erreur lors de la mise à jour de la catégorie d\'espèces : $e');
    } finally {
      update();
    }
  }

  Future<void> deleteCategorySpecies(String id) async {
    try {
      await SQLHelper.deleteItem(id, 'CategorySpecies');
      _categorySpeciesList.removeWhere((c) => c.id == id);
    } catch (e) {
      print('Erreur lors de la suppression de la catégorie d\'espèces : $e');
    } finally {
      update();
    }
  }

    Future<void> deleteAllCategorySpecies() async {
    try {
      await SQLHelper.deleteTable('CategorySpecies');
      _categorySpeciesList.clear();
    } catch (e) {
      print('Erreur lors de la suppression de la catégorie d\'espèces : $e');
    } finally {
      update();
    }
  }
  
}
