import 'dart:convert';

import 'package:naturascan/models/crossingPoint.dart';

class ZoneModel {
  int? id;
  String? name;
  int? nbrePoint;
  List<PointDePassage>? points;

  ZoneModel({
    this.id,
    this.name,
    this.nbrePoint,
    this.points
  });

  ZoneModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    nbrePoint = json['nbre_points'];
     if(json["points"] == null){
      points = null;
    }else{
          try {
      var resp =
          List<Map<String, dynamic>>.from(jsonDecode(json["points"]));
      if (resp.isNotEmpty) {
        points = resp.map((x) => PointDePassage.fromJson(x)).toList();
      } else {
        points = <PointDePassage>[];
      }
    } catch (e) {
      points = <PointDePassage>[];
      if (json["points"] != null) {
        json["points"].forEach((v) {
          points!.add(PointDePassage.fromJson(jsonDecode(v)));
        });
      }
    }
    }
  }

    factory ZoneModel.fromJson2(Map<String, dynamic> json) {
    return ZoneModel(
      id: json['id'],
      name: json['name'],
      nbrePoint: json['nbre_points'],
      points:  json["points"] != null
          ? (json["points"] as List).map((v) => PointDePassage.fromJson2(v)).toList()
          : null,
      );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['nbre_points'] = nbrePoint;
    data['points'] =  points == null
        ? null
        : jsonEncode(List<dynamic>.from(points!.map((x) => x.toJson())));
    return data;
  }

    Map<String, dynamic> toJson2() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['nbre_points'] = nbrePoint;
    data['points'] =  points == null
        ? null
        : List<dynamic>.from(points!.map((x) => x.toJson()));
    return data;
  }
}



final List<ZoneModel> listZone = [
  ZoneModel(
    id: 1,
    name: "Grand Large",
    nbrePoint: 11,
    points: pointsDePassage1
    ),
    ZoneModel(
      id: 2,
      name: "Îles de Lérins",
      nbrePoint: 10,
      points: pointsDePassage2
    )
];
