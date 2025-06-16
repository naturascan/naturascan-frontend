class PointDePassage {
  int? id;
  String? name;
  String? latitudeDegMinSec;
  double? latitudeDegDec;
  String? longitudeDegMinSec;
  double? longitudeDegDec;
  String? description;
  int? zoneId;

  PointDePassage(
      {this.id,
      this.name,
      this.latitudeDegDec,
      this.latitudeDegMinSec,
      this.longitudeDegDec,
      this.longitudeDegMinSec,
      this.description,
      this.zoneId});

  PointDePassage.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'] ?? "";
    latitudeDegMinSec = json['latitude_deg_min_sec'].toString();
    latitudeDegDec = json['latitude_deg_dec'];
    longitudeDegMinSec = json['longitude_deg_min_sec'].toString();
    longitudeDegDec = json['longitude_deg_dec'];
    description = json['description'] ?? "";
    zoneId = json['zone_id'];
  }

   factory PointDePassage.fromJson2(Map<String, dynamic> json) {
  return PointDePassage(
    id: json['id'],
    name: json['name'] ?? "",
    latitudeDegMinSec: json['latitude_deg_min_sec'].toString(),
    latitudeDegDec: json['latitude_deg_dec'],
    longitudeDegMinSec: json['longitude_deg_min_sec'].toString(),
    longitudeDegDec: json['longitude_deg_dec'],
    description: json['description'] ?? "",
    zoneId: json['zone_id'],
  );
}


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['latitude_deg_min_sec'] = latitudeDegMinSec;
    data['latitude_deg_dec'] = latitudeDegDec;
    data['longitude_deg_min_sec'] = latitudeDegMinSec;
    data['longitude_deg_dec'] = latitudeDegDec;
    data['description'] = description;
    data['zone_id'] = zoneId;
    return data;
  }
}

final List<PointDePassage> pointsDePassage1 = 
[
  PointDePassage.fromJson({
    "id": 1,
    "name": "Point 01",
    "latitude_deg_min_sec": "43°30'14\"N",
    "longitude_deg_min_sec": "07°19'34\"E",
    "description": "Z1-Pt01 -11-P",
    "zone_id": 1
  }),
  PointDePassage.fromJson({
    "id": 2,
    "name": "Point 02",
    "latitude_deg_min_sec": "43°27'07\"N",
    "longitude_deg_min_sec": "07°16'56\"E",
    "description": "Z1-Pt02 -1O-O",
    "zone_id": 1
  }),
  PointDePassage.fromJson({
    "id": 3,
    "name": "Point 03",
    "latitude_deg_min_sec": "43°30'51\"N",
    "longitude_deg_min_sec": "07°17'48\"E",
    "description": "Z1-Pt03 -9-N",
    "zone_id": 1
  }),
  PointDePassage.fromJson({
    "id": 4,
    "name": "Point 04",
    "latitude_deg_min_sec": "43°28'18\"N",
    "longitude_deg_min_sec": "07°14'47\"E",
    "description": "Z1-Pt04 -8-K",
    "zone_id": 1
  }),
 PointDePassage.fromJson({
    "id": 5,
    "name": "Point 05",
    "latitude_deg_min_sec": "43°31'47\"N",
    "longitude_deg_min_sec": "07°15'05\"E",
    "description": "Z1-Pt05 -7-L",
    "zone_id": 1
  }),
  PointDePassage.fromJson({
    "id": 6,
    "name": "Point 06",
    "latitude_deg_min_sec": "43°29'51\"N",
    "longitude_deg_min_sec": "07°12'06\"E",
    "description": "Z1-Pt06-6-I",
    "zone_id": 1
  }),
    PointDePassage.fromJson({
    "id": 7,
    "name": "Point 07",
    "latitude_deg_min_sec": "43°32'36\"N",
    "longitude_deg_min_sec": "07°12'51\"E",
    "description": "Z1-Pt07 -5-H",
    "zone_id": 1
  }),
  PointDePassage.fromJson({
    "id": 8,
    "name": "Point 08",
    "latitude_deg_min_sec": "43°30'47\"N",
    "longitude_deg_min_sec": "07°10'27\"E",
    "description": "Z1-Pt08 -4-E",
    "zone_id": 1
  }),
    PointDePassage.fromJson({
    "id": 9,
    "name": "Point 09",
    "latitude_deg_min_sec": "43°33'20\"N",
    "longitude_deg_min_sec": "07°10'45\"E",
    "description": "Z1-Pt09 -3-D",
    "zone_id": 1
  }),
    PointDePassage.fromJson({
    "id": 10,
    "name": "Point 10",
    "latitude_deg_min_sec": "43°31'49\"N",
    "longitude_deg_min_sec": "07°08'39\"E",
    "description": "Z1-Pt10 -2-A",
    "zone_id": 1
  }),
    PointDePassage.fromJson({
    "id": 11,
    "name": "Point 11",
    "latitude_deg_min_sec": "43°38'31\"N",
    "longitude_deg_min_sec": "07°08'53\"E",
    "description": "Z1-Pt11 -1-B",
    "zone_id": 1
  }),
];

final List<PointDePassage> pointsDePassage2 = [
 PointDePassage.fromJson({
    "id": 1,
    "name": "Point 01",
    "latitude_deg_min_sec": "43°32'05\"N",
    "longitude_deg_min_sec": "07°07'10\"E",
    "description": "Z2-Pt01 - 01",
    "zone_id": 2
  }),
PointDePassage.fromJson({
    "id": 2,
    "name": "Point 02",
    "latitude_deg_min_sec": "43°32'04\"N",
    "longitude_deg_min_sec": "07°05'00\"E",
    "description": "Z2-Pt02 - 02",
    "zone_id": 2
  }),
PointDePassage.fromJson({
    "id": 3,
    "name": "Point 03",
    "latitude_deg_min_sec": "43°30'42\"N",
    "longitude_deg_min_sec": "07°04'54\"E",
    "description": "Z2-Pt03 - 03",
    "zone_id": 2
  }),
PointDePassage.fromJson({
    "id": 4,
    "name": "Point 04",
    "latitude_deg_min_sec": "43°29'54\"N",
    "longitude_deg_min_sec": "07°04'00\"E",
    "description": "Z2-Pt04 - 04",
    "zone_id": 2
  }),
PointDePassage.fromJson({
    "id": 5,
    "name": "Point 05",
    "latitude_deg_min_sec": "43°30'00\"N",
    "longitude_deg_min_sec": "07°02'12\"E",
    "description": "Z2-Pt05 - 05",
    "zone_id": 2
  }),
PointDePassage.fromJson({
    "id": 6,
    "name": "Point 06",
    "latitude_deg_min_sec": "43°30'54\"N",
    "longitude_deg_min_sec": "07°01'48\"E",
    "description": "Z2-Pt06 - 06",
    "zone_id": 2
  }),
PointDePassage.fromJson({
    "id": 7,
    "name": "Point 07",
    "latitude_deg_min_sec": "43°31'42\"N",
    "longitude_deg_min_sec": "07°01'54\"E",
    "description": "Z2-Pt07 - 07",
    "zone_id": 2
  }),
PointDePassage.fromJson({
    "id": 8,
    "name": "Point 08",
    "latitude_deg_min_sec": "43°32'48\"N",
    "longitude_deg_min_sec": "07°04'42\"E",
    "description": "Z2-Pt08 - 08",
    "zone_id": 2
  }),
PointDePassage.fromJson({
    "id": 9,
    "name": "Point 09",
    "latitude_deg_min_sec": "43°33'24\"N",
    "longitude_deg_min_sec": "07°05'48\"E",
    "description": "Z2-Pt09 - 09",
    "zone_id": 2
  }),
PointDePassage.fromJson({
    "id": 10,
    "name": "Point 10",
    "latitude_deg_min_sec": "43°32'24\"N",
    "longitude_deg_min_sec": "07°06'30\"E",
    "description": "Z2-Pt10 - 10",
    "zone_id": 2
  }),
];
