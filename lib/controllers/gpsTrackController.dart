import 'dart:developer';

import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../assistants/sql_helper.dart';
import '../models/local/gpsTrackModel.dart';

class GpsTrackController extends GetxController {
  final RxList<GpsTrackModel> _gpsTrackList = <GpsTrackModel>[].obs;
  var isLoading = false.obs;
  var isReloading = false.obs;
  var currentPage = 1;

  List<GpsTrackModel> get gpsTrackList => _gpsTrackList;

  void fetchGpsTracks(
      {int limit = 100000000, int offset = 0, bool isReload = false}) async {
    isReload ? isReloading(true) : isLoading(true);
    try {
      final gpsTracks = await SQLHelper.getItems(
        table: 'GpsTrack',
        limit: limit,
        offset: offset,
      );
      if (offset == 0) {
        _gpsTrackList.clear();
      }
      for (var gpsTrack in gpsTracks) {
        if (!_gpsTrackList.any((g) => g.id == gpsTrack['id'])) {
          _gpsTrackList.add(GpsTrackModel.fromJson(gpsTrack));
        }
      }
    } catch (e) {
      print('Erreur lors de la récupération des pistes GPS : $e');
    } finally {
      isReload ? isReloading(false) : isLoading(false);
      currentPage++;
      update();
    }
  }

  Future fetchGPSbyShippingId({
    // required int limit,
    // required int offset,
    required String shippingId,
    bool isReload = false,
  }) async {
    // isReload ? isReloading(true) : isLoading(true);
    try {
      await Future.delayed(const Duration(seconds: 4), () => null);
      final gpsList = await SQLHelper.getGpsTrackByShippingId(
        // limit: limit,
        // offset: offset,
        shippingId: shippingId,
      );
      _gpsTrackList.value = gpsList;
      //log("gps result ===$gpsList");
      return _gpsTrackList;
    } catch (e) {
      print('Erreur lors de la récupération des gps : $e');
    } finally {
      // isReload ? isReloading(false) : isLoading(false);
      currentPage++;
      update();
    }
  }

  Future<void> addGpsTrack(Map<String, dynamic> data) async {
//     {
//   "id": "1",
//   "longitude": "48.8584",
//   "latitude": "2.2945",
//   "device": "GPS_device_1",
//   "shipping_id": "SHIPPING123",
//   "inObservation": 1,
//   "created_at": "2024-03-15T08:00:00Z",
//   "updated_at": "2024-03-15T08:30:00Z"
// }

    try {
      data['id'] = const Uuid().v4(); // Génération d'un nouvel ID unique
      data['created_at'] = DateTime.now().toIso8601String();
      await SQLHelper.createItem(data, 'GpsTrack');
      // _gpsTrackList.add(GpsTrackModel.fromJson(data));
    } catch (e) {
      print('Erreur lors de l\'ajout de la piste GPS : $e');
    } finally {
      // Get.back(); // Retour à l'écran précédent
      update(); // Mise à jour de l'interface utilisateur
    }
  }

    Future<void> addSynGpsTrack(Map<String, dynamic> data) async {
    try {
      await SQLHelper.createItem2(data, 'GpsTrack');
    } catch (e) {
      print('Erreur lors de l\'ajout de la piste GPS : $e');
    } finally {
      update(); // Mise à jour de l'interface utilisateur
    }
  }

  Future<void> updateGpsTrack(String id, GpsTrackModel updatedGpsTrack) async {
    try {
      final index = _gpsTrackList.indexWhere((g) => g.id == id);
      if (index != -1) {
        _gpsTrackList[index] = updatedGpsTrack;
      }
      await SQLHelper.updateItem(id, updatedGpsTrack.toJson(), 'GpsTrack');
    } catch (e) {
      print('Erreur lors de la mise à jour de la piste GPS : $e');
    } finally {
      update();
    }
  }

  Future<void> deleteGpsTrack(String id) async {
    try {
      await SQLHelper.deleteItem(id, 'GpsTrack');
      _gpsTrackList.removeWhere((g) => g.id == id);
    } catch (e) {
      print('Erreur lors de la suppression de la piste GPS : $e');
    } finally {
      update();
    }
  }

    Future<void> deleteAllGpsTracks() async {
    try {
      await SQLHelper.deleteTable('GpsTrack');
      _gpsTrackList.clear();
    } catch (e) {
      print('Erreur lors de la suppression de tous les sorties: $e');
    } finally {
      update();
    }
  }
  
}
