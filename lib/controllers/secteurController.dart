// import 'package:get/get.dart';
// import 'package:naturascan/models/local/secteur.dart';
// import '../assistants/sql_helper.dart';

// class SecteurController extends GetxController {
//   final RxList<Secteur> _secteurList =
//       <Secteur>[].obs;
//   var isLoading = false.obs;
//   var isReloading = false.obs;
//   var currentPage = 1;
//  Rx<Secteur> selectedSecteur = secteurLists.first.obs;
//  Rx<SousSecteur> selectedSousSecteur = secteurLists.first.sousSecteurs!.first.obs;
//  Rx<Plage> selectedPlage = secteurLists.first.sousSecteurs!.first.plage!.first.obs;

//   List<Secteur> get secteurList => _secteurList;

//   Future<void> fetchSecteur(
//       {int limit = 10, int offset = 0, bool isReload = false}) async {
//     isReload ? isReloading(true) : isLoading(true);
//     try {
//       final categories = await SQLHelper.getItems(
//         table: 'Secteur',
//         limit: limit,
//         offset: offset,
//       );
//       if (offset == 0) {
//         _secteurList.clear();
//       }
//       for (var category in categories) {
//         if (!_secteurList.any((c) => c.id == category['id'])) {
//           _secteurList.add(Secteur.fromJson(category));
//         }
//       }
//        print("cat cat cat cat ${_secteurList.length}");
//       selectedSecteur.value = _secteurList.first;
//       if(selectedSecteur.value.plage != null && selectedSecteur.value.plage!.isNotEmpty){
//         selectedPlage = Plage().obs;
//       selectedPlage.value = selectedSecteur.value.plage!.first;
//       }
//     } catch (e) {
//       print('Erreur lors de la récupération des secteurs  : $e');
//     } finally {
//       isReload ? isReloading(false) : isLoading(false);
//       currentPage++;
//       update();
//     }
//   }

//   Future<void> addSecteur(Map<String, dynamic> data) async {
//     try {
//       await SQLHelper.createItem2(data, 'Secteur');
//       _secteurList.add(Secteur.fromJson(data));
//     } catch (e) {
//       print('Erreur lors de l\'ajout de la secteurs : $e');
//     } finally {
//       Get.back(); // Retour à l'écran précédent
//       update(); // Mise à jour de l'interface utilisateur
//     }
//   }

//   Future<void> updateSecteur(
//       String id, Secteur updatedSecteur) async {
//     try {
//       final index = _secteurList.indexWhere((c) => c.id == id);
//       if (index != -1) {
//         _secteurList[index] = updatedSecteur;
//       }
//       await SQLHelper.updateItem(
//           id, updatedSecteur.toJson(), 'Secteur');
//     } catch (e) {
//       print('Erreur lors de la mise à jour de la catégorie d\'espèces : $e');
//     } finally {
//       update();
//     }
//   }

//   Future<void> deleteSecteur(String id) async {
//     try {
//       await SQLHelper.deleteItem(id, 'Secteur');
//       _secteurList.removeWhere((c) => c.id == id);
//     } catch (e) {
//       print('Erreur lors de la suppression de la catégorie d\'espèces : $e');
//     } finally {
//       update();
//     }
//   }

//     Future<void> deleteAllSecteur() async {
//     try {
//       await SQLHelper.deleteTable('Secteur');
//       _secteurList.clear();
//     } catch (e) {
//       print('Erreur lors de la suppression de la catégorie d\'espèces : $e');
//     } finally {
//       update();
//     }
//   }
  
// }
