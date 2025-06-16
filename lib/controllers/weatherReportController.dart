import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../assistants/sql_helper.dart';
import '../models/local/weatherReportModel.dart';

class WeatherReportController extends GetxController {
  final RxList<WeatherReportModel> _weatherReportList = <WeatherReportModel>[].obs;
  var isLoading = false.obs;
  var isReloading = false.obs;
  var currentPage = 1;

  List<WeatherReportModel> get weatherReportList => _weatherReportList;

  void fetchWeatherReports(
      {int limit = 10, int offset = 0, bool isReload = false}) async {
    isReload ? isReloading(true) : isLoading(true);
    try {
      final weatherReportsData = await SQLHelper.getItems(
        table: 'WeatherReport',
        limit: limit,
        offset: offset,
      );
      if (offset == 0) {
        _weatherReportList.clear();
      }
      for (var report in weatherReportsData) {
        if (!_weatherReportList.any((r) => r.id == report['id'])) {
          _weatherReportList.add(WeatherReportModel.fromJson(report));
        }
      }
    } catch (e) {
      print('Erreur lors de la récupération des rapports météorologiques : $e');
    } finally {
      isReload ? isReloading(false) : isLoading(false);
      currentPage++;
      update();
    }
  }

  Future<void> addWeatherReport(Map<String, dynamic> data) async {
    try {
      data['id'] = const Uuid().v4(); // Génération d'un nouvel ID unique
      await SQLHelper.createItem(data, 'WeatherReport');
      _weatherReportList.add(WeatherReportModel.fromJson(data));
    } catch (e) {
      print('Erreur lors de l\'ajout du rapport météorologique : $e');
    } finally {
      Get.back(); // Retour à l'écran précédent
      update(); // Mise à jour de l'interface utilisateur
    }
  }

  Future<void> updateWeatherReport(String id, WeatherReportModel updatedReport) async {
    try {
      final index = _weatherReportList.indexWhere((r) => r.id == id);
      if (index != -1) {
        _weatherReportList[index] = updatedReport;
      }
      await SQLHelper.updateItem(id, updatedReport.toJson(), 'WeatherReport');
    } catch (e) {
      print('Erreur lors de la mise à jour du rapport météorologique : $e');
    } finally {
      update();
    }
  }

  Future<void> deleteWeatherReport(String id) async {
    try {
      await SQLHelper.deleteItem(id, 'WeatherReport');
      _weatherReportList.removeWhere((r) => r.id == id);
    } catch (e) {
      print('Erreur lors de la suppression du rapport météorologique : $e');
    } finally {
      update();
    }
  }
}
