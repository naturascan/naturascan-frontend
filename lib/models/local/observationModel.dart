import 'dart:convert';

import 'package:naturascan/models/local/seaAnimalObservationModel.dart';
import 'package:naturascan/models/local/seaBirdObservation.dart';
import 'package:naturascan/models/local/userModel.dart';
import 'package:naturascan/models/local/wasteObservationModel.dart';

class ObservationModel {
  String? id;
  String? shippingId;
  num? date;
  num? type;
  num? categorieId;
  SeaAnimalObservation? animal;
  SeaBirdObservation? bird;
  SeaWasteObservation? waste;
  UserModel? photograph;
  String? createdAt;

  

  ObservationModel(
      {this.id,
      this.shippingId,
      this.date,
      this.type,
      this.categorieId,
      this.animal,
      this.bird,
      this.waste,
      this.photograph,
      this.createdAt});

  ObservationModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    shippingId = json['shipping_id'];
    date = json['date'];
    type = json['type'];
    categorieId = json['categorie_id'];
    animal = json['animal'] == null ? null : jsonDecode(json['animal']) != null
        ? SeaAnimalObservation.fromJson(jsonDecode(json['animal']))
        : null;
    bird = json['bird'] == null ? null : jsonDecode(json['bird']) != null
        ? SeaBirdObservation.fromJson(jsonDecode(json['bird']))
        : null;
    waste = json['waste'] == null ? null : jsonDecode(json['waste']) != null
        ? SeaWasteObservation.fromJson(jsonDecode(json['waste']))
        : null;
    photograph =  json['photograph'] == null ? null : jsonDecode(json['photograph']) != null
        ? UserModel.fromJson(jsonDecode(json['photograph']))
        : null;
    createdAt = json['created_at'];
  }

  factory ObservationModel.fromJson2(Map<String, dynamic> json) {
    return ObservationModel(
      id: json['id'],
      shippingId: json['shipping_id'],
      date: json['date'], 
      type: json['type'],
      categorieId: json['categorie_id'],
      animal: json['animal'] != null ? SeaAnimalObservation.fromJson2(json['animal']) : null,
      bird: json['bird'] != null ? SeaBirdObservation.fromJson2(json['bird']) : null,
      waste: json['waste'] != null ? SeaWasteObservation.fromJson2(json['waste']) : null,
      photograph: json['photograph'] != null ? UserModel.fromJson2(json['photograph']) : null,
      createdAt: json['created_at']
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['shipping_id'] = shippingId;
    data['date'] = date;
    data['type'] = type;
    data['categorie_id'] = categorieId;
    data['animal'] = jsonEncode(animal?.toJson());
    data['bird'] = jsonEncode(bird?.toJson());
    data['waste'] = jsonEncode(waste?.toJson());
    data['photograph'] = jsonEncode(photograph?.toJson());
    data['created_at'] = createdAt;
    return data;
  }

    Map<String, dynamic> toJson2() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['shipping_id'] = shippingId;
    data['categorie_id'] = categorieId;
    data['date'] = date;
    data['type'] = type;
    data['animal'] = animal?.toJson2();
    data['bird'] = bird?.toJson2();
    data['waste'] = waste?.toJson2();
    data['created_at'] = createdAt;
    return data;
  }
}

class MapPosition {
  String? degMinSec;
  double? degDec;

  MapPosition({this.degMinSec, this.degDec});

  MapPosition.fromJson(Map<String, dynamic> json) {
    degMinSec = json['deg_min_sec'] ?? "";
    degDec = json['deg_dec'] == null ? null :  double.tryParse("${json['deg_dec']}") ?? 0.0;
  }

    factory MapPosition.fromJson2(Map<String, dynamic> json) {
    return MapPosition(
      degMinSec: json['deg_min_sec'] ?? "",
      degDec: json['deg_dec'] == null ? null :  double.tryParse("${json['deg_dec']}") ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['deg_min_sec'] = degMinSec;
    data['deg_dec'] = degDec;
    return data;
  }
}
