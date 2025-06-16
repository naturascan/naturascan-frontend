class PolicyModel {
  int? id;
  String? name;
  String? description;
  bool? enabled;

  PolicyModel({this.id, this.name, this.description, this.enabled});

  PolicyModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    enabled = json['enabled'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['enabled'] = enabled;
    return data;
  }
}
