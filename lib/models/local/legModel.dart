class LegModel {
  int? id;
  String? name;
  String? description;
  int? shippingId;
  String? arrivalAt;
  String? departureAt;
  double? longitude;
  double? latitude;

  LegModel(
      {this.id,
      this.name,
      this.description,
      this.shippingId,
      this.arrivalAt,
      this.departureAt,
      this.longitude,
      this.latitude});

  LegModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    shippingId = json['shipping_id'];
    arrivalAt = json['arrival_at'];
    departureAt = json['departure_at'];
    longitude = json['longitude'];
    latitude = json['latitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['shipping_id'] = shippingId;
    data['arrival_at'] = arrivalAt;
    data['departure_at'] = departureAt;
    data['longitude'] = longitude;
    data['latitude'] = latitude;
    return data;
  }
}
