import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:naturascan/Utils/Utils.dart';
import 'package:uuid/uuid.dart';
import '../assistants/sql_helper.dart';
import '../main.dart';
import '../models/local/roleModel.dart';
import '../models/local/userModel.dart';

class UserController extends GetxController {
  TextEditingController nameController = TextEditingController();
  TextEditingController firstnameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  var isLoading = false.obs;
  var isReloading = false.obs;

  final RxList<UserModel> _userList = <UserModel>[].obs;
  List<UserModel> get userList => _userList;

  // fetchUsers({int limit = 100, int offset = 0, bool isReload = false}, int type) async {
  //   isReload ? isReloading(true) : isLoading(true);
  //   try {
  //     final users = await SQLHelper.getItems(
  //       table: 'user',
  //       limit: limit,
  //       offset: offset,
  //     );
  //     if (offset == 0) {
  //       _userList.clear();
  //     }
  //     for (var user in users) {
  //       if (!_userList.any((u) => u.id == user['id'])) {
  //         _userList.add(UserModel.fromJson(user));
  //       }
  //     }
  //     print("Nous sommes ici ${users.toString()}");
  //     _userList.sort((a, b) => a.name!.compareTo(b.name!));
  //     return _userList;
  //   } catch (e) {
  //     print('Erreur lors de la récupération des utilisateurs : $e');
  //   } finally {
  //     isReload ? isReloading(false) : isLoading(false);
  //     // currentPage++;
  //     // update();
  //   }
  // }

 fetchUsers(int type, {int limit = 100, int offset = 0, bool isReload = false}) async {
    isReload ? isReloading(true) : isLoading(true);
    try {
      final users = await SQLHelper.getItems(
        table: 'user',
        limit: limit,
        offset: offset,
      );
      if (offset == 0) {
        _userList.clear();
      }
      for (var user in users) {
        if (!_userList.any((u) => u.id == user['id'])) {
          UserModel? u = UserModel.fromJson(user);
          if(u.roles != null){
               if(u.roles!.any((element) => element.id == type)){
                      _userList.add(u);
          }
          }
        }
      }
      _userList.sort((a, b) => a.name!.compareTo(b.name!));
      return _userList;
    } catch (e) {
      print('Erreur lors de la récupération des utilisateurs : $e');
    } finally {
      isReload ? isReloading(false) : isLoading(false);
      // currentPage++;
      // update();
    }
  }


  Future<void> addUser2(Map<String, dynamic> user, int type) async {
    try {
  
      user["created_at"] = DateTime.now().toIso8601String();
      int idUser = await SQLHelper.createItem(user, 'user');
        if (idUser == -1) {
          await progress.hide();
          Utils.showToast(
              'Erreur lors de la création de l\'utilisateur. Veuillez réessayer.');
        } else {
          await progress.hide();
          _userList.add(UserModel.fromJson(user));
          Utils.showToast('Participant ajouté avec succès');
          fetchUsers(type, limit: 100, offset: 0);
        }
      print('Utilisateur ajouté avec succès');
    } catch (e) {
      print('Erreur lors de l\'ajout de l\'utilisateur : $e');
    } finally {
      reset();
      Get.back(); // Retour à l'écran précédent
      update(); // Mise à jour de l'interface utilisateur
    }
  }

    Future<void> addUser(Map<String, dynamic> user, int type) async {
    try {
  
      user["created_at"] = DateTime.now().toIso8601String();
      int idUser = await SQLHelper.createItem(user, 'user');
        if (idUser == -1) {
        } else {
          await progress.hide();
          _userList.add(UserModel.fromJson(user));
          fetchUsers(type, limit: 100, offset: 0);
        }
    } catch (e) {
      print('Erreur lors de l\'ajout de l\'utilisateur : $e');
    } finally {
      reset();
      Get.back(); // Retour à l'écran précédent
      update(); // Mise à jour de l'interface utilisateur
    }
  }


  Future<void> updateUser(
      String id, Map<String, dynamic> updatedUser, type) async {
    try {
      final index = _userList.indexWhere((c) => c.id == id);
      if (index != -1) {
        _userList[index] = UserModel.fromJson(updatedUser);
      }
      await SQLHelper.updateItem(
          id.toString(), updatedUser, 'user');
          fetchUsers(type, limit: 100, offset: 0);
          progress.hide();
    } catch (e) {
       progress.hide();
      print('Erreur lors de la mise à jour de user : $e');
    } finally {
      reset();
      Get.back();
      update();
    }
  }
  Future<void> deleteUser(String id, int type) async {
    try {
      await SQLHelper.deleteItem(id.toString(), 'user');
      _userList.removeWhere((user) => user.id == id);
          fetchUsers(type, limit: 100, offset: 0);
      Utils.showToast('Participant supprimé avec succès');
    } catch (e) {
      print('Erreur lors de la suppression de l\'utilisateur : $e');
    } finally {
      Get.back();
      update();
    }
  }

   Future<void> deleteAllUser() async {
    try {
      await SQLHelper.deleteTable('user');
      _userList.clear();
    } catch (e) {
      print('Erreur lors de la suppression de tous les éléments : $e');
    } finally {
      update();
    }
  }

  void reset() {
    nameController.clear();
    firstnameController.clear();
    emailController.clear();
    mobileNumberController.clear();
    addressController.clear();
  }
}
