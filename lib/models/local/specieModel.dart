class SpecieModel {
  int? id;
  String? commonName;
  String? scientificName;
  String? description;
  int? categoryId;

  SpecieModel(
      {this.id,
      this.commonName,
      this.scientificName,
      this.description,
      this.categoryId});

  SpecieModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    commonName = json['common_name'];
    scientificName = json['scientific_name'];
    description = json['description'];
    categoryId = json['category_id'];
  }

factory SpecieModel.fromJson2(Map<String, dynamic> json) => SpecieModel(
  id: json['id'],
  commonName: json['common_name'],
  scientificName: json['scientific_name'],
  description: json['description'],
  categoryId: json['category_id'],
);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['common_name'] = commonName;
    data['scientific_name'] = scientificName;
    data['description'] = description;
    data['category_id'] = categoryId;
    return data;
  }
}


class Category {
  String? id;
  String? name;

  Category(
      {this.id,
      this.name
      });

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}
