import 'dart:convert';

import 'package:naturascan/models/cloudCover.dart';
import 'package:naturascan/models/seaState.dart';
import 'package:naturascan/models/visibiliteMer.dart';
import 'package:naturascan/models/windDirection.dart';
import 'package:naturascan/models/windSpeed.dart';

class WeatherReportModel {
  String? id;
  SeaState? seaState;
  CloudCover? cloudCover;
  VisibiliteMer? visibility;
  WindSpeedBeaufort? windForce;
  WindDirection? windDirection;
  WindSpeedBeaufort? windSpeed;

  WeatherReportModel(
      {this.id,
      this.seaState,
      this.cloudCover,
      this.visibility,
      this.windForce,
      this.windDirection,
      this.windSpeed});

  WeatherReportModel.fromJson(Map<String, dynamic> json) {
    try{
      id = "${json['id']}";
    print("object 1");
    seaState = json['sea_state'] == null ? null : SeaState.fromJson(jsonDecode(json['sea_state']));
        print("object 2");
    cloudCover =  json['cloud_cover'] == null ? null : CloudCover.fromJson(jsonDecode(json['cloud_cover']));
            print("object 3");

    visibility = json['visibility'] == null ? null : VisibiliteMer.fromJson(jsonDecode(json['visibility']));
    windForce = json['wind_force'] == null ? null : WindSpeedBeaufort.fromJson(jsonDecode(json['wind_force']));
    windDirection =  json['wind_direction'] == null ? null : WindDirection.fromJson(jsonDecode(json['wind_direction']));
    windSpeed = json['wind_speed'] == null ? null : WindSpeedBeaufort.fromJson(jsonDecode(json['wind_speed']));
                                print("autre 5");

    }catch(e){
      
    }
  }

  factory WeatherReportModel.fromJson2(Map<String, dynamic> json) => WeatherReportModel(
        id: json['id'],
        seaState: json['sea_state'] == null ? null : SeaState.fromJson2(json['sea_state']),
        cloudCover: json['cloud_cover'] == null ? null : CloudCover.fromJson2(json['cloud_cover']),
        visibility: json['visibility'] == null ? null : VisibiliteMer.fromJson2(json['visibility']),
        windForce: json['wind_force'] == null ? null : WindSpeedBeaufort.fromJson2(json['wind_force']),
        windDirection: json['wind_direction'] == null ? null : WindDirection.fromJson2(json['wind_direction']),
        windSpeed: json['wind_speed'] == null ? null : WindSpeedBeaufort.fromJson2(json['wind_speed']),
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['sea_state'] = seaState == null ? null : jsonEncode(seaState?.toJson());
    data['cloud_cover'] = cloudCover == null ? null : jsonEncode(cloudCover?.toJson());
    data['visibility'] = visibility == null ? null : jsonEncode(visibility?.toJson());
    data['wind_force'] = windForce == null ? null : jsonEncode(windForce?.toJson());
    data['wind_direction'] = windDirection == null ? null : jsonEncode(windDirection?.toJson());
    data['wind_speed'] = windSpeed == null ? null : jsonEncode(windSpeed?.toJson());
    return data;
  }

    Map<String, dynamic> toJson2() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['sea_state'] = seaState?.toJson();
    data['cloud_cover'] = cloudCover?.toJson();
    data['visibility'] = visibility?.toJson();
    data['wind_force'] = windForce?.toJson();
    data['wind_direction'] = windDirection?.toJson();
    data['wind_speed'] = windSpeed?.toJson();
    return data;
  }
}
