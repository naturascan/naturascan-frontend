import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';

import 'Log.dart';

class DioLogger{
  static void onSend(String tag, RequestOptions options){
    print('$tag - Request Path : [${options.method}] ${options.baseUrl}${options.path}');
    print('$tag - Request Headers : [${options.headers}]');
    print('$tag - Request Data : ${options.queryParameters.toString()}');
    print('$tag - Request Data : ${options.data}');
    //log("$tag - Response data"+jsonEncode(options.data));
  }

  static void onSuccess(String tag, Response response){
    print('$tag - Response Path : [${response.requestOptions.method}] ${response.requestOptions.baseUrl}${response.requestOptions.path} Request Data : ${response.requestOptions.data.toString()}');
    print('$tag - Response statusCode : ${response.statusCode}');
    print('$tag - Response data : ${response.data}');
    //log("$tag - Response data"+jsonEncode(response.data));

  }

  static void onError(String tag, DioException error){
    if(null != error.response){
      print('$tag - Error Path : [${error.response?.requestOptions.method}] ${error.response?.requestOptions.baseUrl}${error.response?.requestOptions.path} Request Data : ${error.response?.requestOptions.data.toString()}');
      print('$tag - Error statusCode : ${error.response?.statusCode}');
      print('$tag - Error data : ${null != error.response?.data ? error.response?.data.toString() : ''}');
    }
    print('$tag - Error Message : ${error.message}');

  }
}