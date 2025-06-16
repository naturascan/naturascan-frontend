class GpsTrackModel {
  String? id;
  double? longitude;
  double? latitude;
  String? device;
  String? shippingId;
  bool? inObservation;
  String? createdAt;

  GpsTrackModel(
      {this.id,
      this.longitude,
      this.latitude,
      this.device,
      this.shippingId,
      this.inObservation,
      this.createdAt
      });

  GpsTrackModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    longitude = json['longitude'] == null ? null : double.parse("${json['longitude']}");
    latitude = json['latitude'] == null ? null :  double.parse("${json['latitude']}");
    device = json['device'];
    shippingId = json['shipping_id'];
    inObservation = json['inObservation'] == 1 ? true : false;
    createdAt = json['created_at'];
  }

    factory GpsTrackModel.fromJson2(Map<String, dynamic> json) {
    return GpsTrackModel(
      id: json['id'],
      longitude: json['longitude'] == null ? null : double.tryParse("${json['longitude']}") ?? 0,
      latitude:  json['latitude'] == null ? null :  double.tryParse("${json['latitude']}") ?? 0,
      device: json['device'],
      shippingId: json['shipping_id'],
      inObservation: json['inObservation'] == 1 ? true : false,
      createdAt: json['created_at'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['longitude'] = longitude;
    data['latitude'] = latitude;
    data['device'] = device;
    data['shipping_id'] = shippingId;
    data['inObservation'] = inObservation == true ? 1 : 0;
    data['created_at'] = createdAt;
    return data;
  }
}
