import 'package:naturascan/models/local/userModel.dart';

import 'weatherReportModel.dart';

class ShippingModel {
  int? id;
  String? datePlanning;
  int? totalObservers;
  String? description;
  String? shippingStartAt;
  String? shippingEndAt;
  WeatherReportModel? departureWeatherReport;
  WeatherReportModel? arrivalWeatherReport;
  String? departureExtraComment;
  String? arrivalExtraComment;
  String? shippingStatus;
  String? type;
  String? createdAt;
  UserModel? createdBy;

  ShippingModel(
      {this.id,
      this.datePlanning,
      this.totalObservers,
      this.description,
      this.shippingStartAt,
      this.shippingEndAt,
      this.departureWeatherReport,
      this.arrivalWeatherReport,
      this.departureExtraComment,
      this.arrivalExtraComment,
      this.shippingStatus,
      this.type,
      this.createdAt,
      this.createdBy});

  ShippingModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    datePlanning = json['date_planning'];
    totalObservers = json['total_observers'];
    description = json['description'];
    shippingStartAt = json['shipping_start_at'];
    shippingEndAt = json['shipping_end_at'];
    departureWeatherReport = json['departure_weather_report'] != null
        ? WeatherReportModel.fromJson(json['departure_weather_report'])
        : null;
    arrivalWeatherReport = json['arrival_weather_report'] != null
        ? WeatherReportModel.fromJson(json['arrival_weather_report'])
        : null;
    departureExtraComment = json['departure_extra_comment'];
    arrivalExtraComment = json['arrival_extra_comment'];
    shippingStatus = json['shipping_status'];
    type = json['type'];
    createdAt = json['created_at'];
    createdBy = json['created_by'] != null
        ? UserModel.fromJson(json['created_by'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['date_planning'] = datePlanning;
    data['total_observers'] = totalObservers;
    data['description'] = description;
    data['shipping_start_at'] = shippingStartAt;
    data['shipping_end_at'] = shippingEndAt;
    if (departureWeatherReport != null) {
      data['departure_weather_report'] = departureWeatherReport?.toJson();
    }
    if (arrivalWeatherReport != null) {
      data['arrival_weather_report'] = arrivalWeatherReport?.toJson();
    }
    data['departure_extra_comment'] = departureExtraComment;
    data['arrival_extra_comment'] = arrivalExtraComment;
    data['shipping_status'] = shippingStatus;
    data['type'] = type;
    data['created_at'] = createdAt;
    if (createdBy != null) {
      data['created_by'] = createdBy?.toJson();
    }
    return data;
  }
}
