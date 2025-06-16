import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:naturascan/Utils/Dialog/networkDialog.dart';
import 'package:naturascan/Utils/DioLogger.dart';
import 'package:naturascan/Utils/PrefManager.dart';
import 'package:naturascan/Utils/Utils.dart';
import 'package:naturascan/Utils/constants.dart';
import 'package:dio/dio.dart';
import 'package:get/route_manager.dart';
import 'package:naturascan/controllers/refreshTokenController.dart';
import 'package:naturascan/main.dart';
import 'package:naturascan/models/local/categorySpecies.dart';
import 'package:naturascan/models/local/sortieModel.dart';
import 'package:naturascan/models/local/specieModel.dart';
import 'package:naturascan/models/local/userModel.dart';
import 'package:naturascan/models/local/zone.dart';

class ApiProvider{
  static const String TAG = 'APIProvider';
  static const login = "login";
  static const logout = "logout";
  static const deleteVr = "delete-account";
  static const register = "register";
  static const refreshToken = "refreshToken";
  static const me = "me";
  static const forgotPassword = "forgotPassword";
  static const updatePassword = "updatePassword";
  static const oldestShipping = "shippings/oldest";
  static const latestShipping = "shippings/latest";
  static const getDetailsShipping = "shippings";
  static const createShipping = "shippings";
  static const listCategories = "categories";
  static const listObservers = "observers";
  static const listZone = "zones";
  static const listSortie = "sorties";
  static const listEspeces = "especes";
  static const sync = "sync";
  static const exports = "exports";
  static const exportsExcel = "export-excel";


  Dio _dio = Dio();

  @protected
  Dio get dio => _dio;

  ApiProvider(String message) {
    BaseOptions dioOptions = BaseOptions(
      baseUrl: Constants.baseUrl,
      connectTimeout: const Duration(seconds: 60000),
      receiveTimeout: const Duration(seconds: 60000),
    );

    _dio = Dio(dioOptions);
    _dio.interceptors
        .add(InterceptorsWrapper(onRequest: (RequestOptions options, RequestInterceptorHandler handler) async {
      options.headers = {
        'Content-Type': 'application/json',
        'accept': 'application/json',
        'Authorization': 'Bearer ${await PrefManager.getString(Constants.accessTokenAuth)}'
      };
      DioLogger.onSend(TAG, options);
      return handler.next(options);
    },
      onResponse: (Response response, ResponseInterceptorHandler handler) {
        DioLogger.onSuccess(TAG, response);
        return handler.next(response);
      },
      onError: (DioException error, ErrorInterceptorHandler handler) async {
        DioLogger.onError(TAG, error);
              if(error.type == DioExceptionType.connectionError){
                if(message != "a" && message != "re"){
                Get.dialog(
                  barrierDismissible: false,
                  NetworkDialog(message: message,));
                }else{
                }
              }else{
                if(message == 're'){
                  print("re");
                  Utils().localLogout();
                }
                      if (error.response?.statusCode == 401) {          
        RequestOptions options = error.response!.requestOptions;
        try {
           String? response = await ApiProvider("re").refreshTok();
      if(response != null && response != ""){
      await  PrefManager.putString(Constants.accessTokenAuth, response);
      }
            options.headers = {
        'Content-Type': 'application/json',
        'accept': 'application/json',
        'Authorization': 'Bearer ${await PrefManager.getString(Constants.accessTokenAuth)}'
      };
          // return _dio.request(options.path, options: options);
          return DioLogger.onSend(TAG, options);
        } on HttpException {
          rethrow;
        }
      } else {
     
      }
              }
                return handler.next(error);
        
      },
    ));
  }

  ApiProvider.auth() {
    BaseOptions dioOptions = BaseOptions(
      baseUrl: Constants.baseUrl,
      connectTimeout: const Duration(seconds: 60000),
      receiveTimeout: const Duration(seconds: 60000),
    );

    _dio = Dio(dioOptions);
    _dio.interceptors
        .add(InterceptorsWrapper(onRequest: (RequestOptions options, RequestInterceptorHandler handler) async {
      options.headers = {
        'Content-Type': 'application/json',
        'accept': 'application/json'
      };
      DioLogger.onSend(TAG, options);
      print('la reposes ets ici');
      return handler.next(options);
    },
      onResponse: (Response response, ResponseInterceptorHandler handler) {
        DioLogger.onSuccess(TAG, response);
        return handler.next(response);
      },
      onError: (DioException error, ErrorInterceptorHandler handler) {
        DioLogger.onError(TAG, error);

        return handler.next(error);
      },
    ));
  }

  Future<String?> connexion(Map<String, dynamic> params) async {
    Response response;
    try {
      response = await _dio.post(login, data: jsonEncode(params));
      return response.data['access_token'];
    } catch (error, stacktrace) {
      DioException erreur = error as DioException;
           Utils.showToast("Votre connexion a échouée. ${erreur.response?.data["message"] ?? "Problème de connexion"}. Veuillez réssayer");
    }
    return null;
  }

  
  Future<String?> refreshTok() async {
    Response response;
    try {
      response = await _dio.post(refreshToken);
      print('je syis venue ici 0 1  ${response.data["access_token"]} ');
      return response.data['access_token'];
    } catch (error, stacktrace) {
         DioException erreur = error as DioException;
          if(erreur.response?.statusCode == 401){
            Utils().localLogout();
          }
    }
    return null;
  }

  Future<String?> inscription(Map<String, dynamic> params) async {
    Response response;
    try {
      response = await _dio.post(register, data: jsonEncode(params));
         return response.data['access_token'];
    } catch (error, stacktrace) {
      DioException erreur = error as DioException;
        Utils.showToast("La création de votre compte a echoué. ${erreur.response?.data["message"] ?? "Problème de connexion"}. Veuillez réssayer");
    }
    return null;
  }

  Future<String?> getOldestSippings() async {
    Response response;
    try {
      response = await _dio.get(oldestShipping);
      print('la reposes ets  ${response.data} ');
      return response.data['access_token'];
    } catch (error, stacktrace) {
      print('la reposes ets ggg');
    }
    return null;
  }

 Future<String?> getLatestSippings() async {
    Response response;
    try {
      response = await _dio.get(latestShipping);
      print('la reposes ets  ${response.data} ');
      return response.data['access_token'];
    } catch (error, stacktrace) {
      print('la reposes ets ggg');
    }
    return null;
  }

   Future<String?> getDetailsExpedition(Map<String, dynamic> params) async {
    Response response;
    try {
      response = await _dio.get(getDetailsShipping, queryParameters:params);
      print('la reposes ets  ${response.data} '); 
      return response.data['access_token'];
    } catch (error, stacktrace) {
      print('la reposes ets ggg');
    }
    return null;
  }

  Future<UserModel?> userInfos() async {
    Response response;
    try {
      response = await _dio.get(me);
      return UserModel.fromJson2(response.data['data']);
    } catch (error, stacktrace) {
      print('la reposes ets ggg');
        String dt = await PrefManager.getString(Constants.me);
    if (dt.isNotEmpty) {
      UserModel userModel = UserModel.fromJson(jsonDecode(dt));
      print('meeeeeeeeeeeeeee ${userModel.totalExport}');
      return userModel;
    }else{
      return null;
    }
    }
  }

    Future<int?> askCode(Map<String, dynamic> data) async {
    Response response;
    try {
      response = await _dio.post(forgotPassword, data: jsonEncode(data));
      Utils.showToast(response.data["message"]);
      return response.data["code"];
    } catch (error, stacktrace) {
      print('la reposes ets ggg');
    }
    return null;
  }
  
      Future<int?> newPassWord(Map<String, dynamic> data) async {
    Response response;
    try {
      response = await _dio.post(updatePassword, data: jsonEncode(data));
      Utils.showToast(response.data["message"]);
      return response.data["code"];
    } catch (error, stacktrace) {
         DioException erreur = error as DioException;
        Utils.showToast("La rénitialisaion de votre mot de passe a echoué. ${erreur.response?.data["message"] ?? "Problème de connexion"}. Veuillez réssayer");
   
    }
    return null;
  }
  

  Future<String?> createNewShippings(Map<String, dynamic> params) async {
  
    Response response;
    try {
      response = await _dio.post(createShipping, data: jsonEncode(params));
      print('la creation esr faite   ${response.data} ');
      return response.data['access_token'];
    } catch (error, stacktrace) {
      print('la reposes ets ggg');
    }
    return null;
  }
 

  Future<String?> editInfosShippings(Map<String, dynamic> params, Map<String, dynamic> body) async {
  
    Response response;
    try {
      response = await _dio.put(createShipping, data: jsonEncode(body), queryParameters:params);
      print('la modififcation est faite   ${response.data} ');
      return response.data['access_token'];
    } catch (error, stacktrace) {
      print('la reposes ets ggg');
    }
    return null;
  }

    Future<List<CategorySpeciesModel>?> getCategory() async {
    Response response;
    try {
      response = await _dio.get(listCategories);
      if(response.data['data'] != null){
      return  List<Map<String, dynamic>>.from(response.data['data']).map((x) => CategorySpeciesModel.fromJson2(x)).toList();
      }else{
        return [];
      }
    } catch (error, stacktrace) {
          print('acaateorie $error');

      print('la reposes ets ggg');
    }
    return null;
  }

  Future<List<UserModel>?> getUsers() async {
    Response response;
    try {
      response = await _dio.get(listObservers);
      return List<Map<String, dynamic>>.from(response.data).map((x) => UserModel.fromJson2(x)).toList();
    } catch (error, stacktrace) {
      print('la reposes ets ggg $error');
    }
    return null;
  }

  
  Future<List<ZoneModel>?> getZones() async {
    Response response;
    try {
      response = await _dio.get(listZone);
      if(response.data['data'] != null){
      return List<Map<String, dynamic>>.from(response.data['data']).map((x) => ZoneModel.fromJson2(x)).toList();
      }else{
        return null;
      }
    } catch (error, stacktrace) {
      print('la reposes ets ggg zone $error');
    }
    return null;
  }

    Future<List<SortieModel>?> getSorties() async {
    Response response;
    try {
      response = await _dio.get(exports);
      List<Map<String, dynamic>> lists = [];
      if(response.data['data'] != null){
          response.data["data"].forEach((element){
        lists.add(jsonDecode(element["data"]));
      });
      return List<Map<String, dynamic>>.from(lists).map((x) => SortieModel.fromJson2(x)).toList();               
      }else{
        return null;
      }
    } catch (error, stacktrace) {
      print('la reposes ets  list sortie $error');
    }
    return null;
  }

    Future<String?> sendSortie(Map<String, dynamic> data) async {
    Response response;
    try {
      response = await _dio.post(exports, data: json.encode(data));
      if(response.statusCode == 200){
        Utils.showToast(response.data["message"]);
        return 'success';
      }
      else{
        return 'failed';
      }
    // ignore: empty_catches
    } catch (error) {
       DioException erreur = error as DioException;
      if (erreur.type == DioExceptionType.connectionError) {
                return "network";
      }
   
        
    }
    return null;
  }


    Future<List<SpecieModel>?> getEspece() async {
    Response response;
    try {
      response = await _dio.get(listEspeces);
      return List<Map<String, dynamic>>.from(response.data['data']).map((x) => SpecieModel.fromJson(x)).toList();
    } catch (error, stacktrace) {
      print('la reposes ets ggg');
    }
    return null;
  }

    Future<int?> sendExcel() async {
    Response response;
    try {
      response = await _dio.get(exportsExcel);
       progress.hide();
    Utils.showToast(response.data["message"]);
      return response.data["code"];
    } catch (error, stacktrace) {
       progress.hide();
         DioException erreur = error as DioException;
        Utils.showToast("L'envoi du fichier excel a echoué. ${erreur.response?.data["message"] ?? "Problème de connexion"}. Veuillez réssayer");
   
    }
    return null;
  }

  Future<int?> deconnexion() async {
    Response response;
    try {
      response = await _dio.post(logout);
       progress.hide();
    Utils.showToast(response.data["message"]);
                    print('conexxxionn ${response.statusCode}');
      return response.statusCode;
    } catch (error, stacktrace) {
       progress.hide();
         DioException erreur = error as DioException;
      Utils.showToast("La déconnexion a échouée. ${erreur.response?.data["message"] ?? "Problème de connexion"}. Veuillez réssayer");
    }
    return null;
  }

   Future<int?> delete() async {
    Response response;
    try {
      response = await _dio.delete(deleteVr);
       progress.hide();
    Utils.showToast(response.data["message"]);
      return response.statusCode;
    } catch (error, stacktrace) {
      print('errreerrr compte $error');
       progress.hide();
         DioException erreur = error as DioException;
      Utils.showToast("La suppression du compte a échouée. ${erreur.response?.data["message"] ?? "Problème de connexion"}. Veuillez réssayer");
    }
    return null;
  }

  
  Future<int?> deleteAccount() async {
    Response response;
    try {
      response = await _dio.post(logout);
       progress.hide();
    Utils.showToast(response.data["message"]);
                    print('conexxxionn ${response.statusCode}');
      return response.statusCode;
    } catch (error, stacktrace) {
       progress.hide();
         DioException erreur = error as DioException;
      Utils.showToast("La déconnexion a échouée. ${erreur.response?.data["message"] ?? "Problème de connexion"}. Veuillez réssayer");
    }
    return null;
  }
}
