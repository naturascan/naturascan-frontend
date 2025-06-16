// To parse this JSON data, do
//
//     final weatherReport = weatherReportFromJson(jsonString);

import 'dart:convert';

WeatherReport weatherReportFromJson(String str) => WeatherReport.fromJson(json.decode(str));

String weatherReportToJson(WeatherReport data) => json.encode(data.toJson());

class WeatherReport {
    String? id;
    String? seaState;
    String? cloudCover;
    String? visibility;
    String? windForce;
    String? windDirection;
    String? windSpeed;
    

    WeatherReport({
        this.id,
        this.seaState,
        this.cloudCover,
        this.visibility,
        this.windForce,
        this.windDirection,
        this.windSpeed,
    });

    factory WeatherReport.fromJson(Map<String, dynamic> json) => WeatherReport(
        id: json["id"],
        seaState: json["sea_state"],
        cloudCover: json["cloud_cover"],
        visibility: json["visibility"],
        windForce: json["wind_force"],
        windDirection: json["wind_direction"],
        windSpeed: json["wind_speed"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "sea_state": seaState,
        "cloud_cover": cloudCover,
        "visibility": visibility,
        "wind_force": windForce,
        "wind_direction": windDirection,
        "wind_speed": windSpeed,
    };
}
