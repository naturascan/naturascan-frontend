import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../assistants/sql_helper.dart';
import '../models/local/shippingModel.dart';

class ShippingController extends GetxController {
  final RxList<ShippingModel> _shippingList = <ShippingModel>[].obs;
  var isLoading = false.obs;
  var isReloading = false.obs;
  var currentPage = 1;

  List<ShippingModel> get shippingList => _shippingList;

  void fetchShippingList(
      {int limit = 10, int offset = 0, bool isReload = false}) async {
    isReload ? isReloading(true) : isLoading(true);
    try {
      final shippingData = await SQLHelper.getItems(
        table: 'Shipping',
        limit: limit,
        offset: offset,
      );
      if (offset == 0) {
        _shippingList.clear();
      }
      for (var shipping in shippingData) {
        if (!_shippingList.any((s) => s.id == shipping['id'])) {
          _shippingList.add(ShippingModel.fromJson(shipping));
        }
      }
    } catch (e) {
      print('Erreur lors de la récupération des expéditions : $e');
    } finally {
      isReload ? isReloading(false) : isLoading(false);
      currentPage++;
      update();
    }
  }

  Future<void> addShipping(Map<String, dynamic> data) async {
    try {
      data['id'] = const Uuid().v4(); // Génération d'un nouvel ID unique
      await SQLHelper.createItem(data, 'Shipping');
      _shippingList.add(ShippingModel.fromJson(data));
    } catch (e) {
      print('Erreur lors de l\'ajout de l\'expédition : $e');
    } finally {
      Get.back(); // Retour à l'écran précédent
      update(); // Mise à jour de l'interface utilisateur
    }
  }

  Future<void> updateShipping(String id, ShippingModel updatedShipping) async {
    try {
      final index = _shippingList.indexWhere((s) => s.id == id);
      if (index != -1) {
        _shippingList[index] = updatedShipping;
      }
      await SQLHelper.updateItem(id, updatedShipping.toJson(), 'Shipping');
    } catch (e) {
      print('Erreur lors de la mise à jour de l\'expédition : $e');
    } finally {
      update();
    }
  }

  Future<void> deleteShipping(String id) async {
    try {
      await SQLHelper.deleteItem(id, 'Shipping');
      _shippingList.removeWhere((s) => s.id == id);
    } catch (e) {
      print('Erreur lors de la suppression de l\'expédition : $e');
    } finally {
      update();
    }
  }
}
