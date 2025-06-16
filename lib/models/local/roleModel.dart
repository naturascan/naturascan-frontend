class RoleModel {
  int? id;
  String? name;
  String? description;
  bool? enabled;
  bool? isSysRole;

  RoleModel(
      {this.id, this.name, this.description, this.enabled, this.isSysRole});

  RoleModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    enabled = json['enabled'];
    isSysRole = json['isSysRole'];
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "enabled": enabled,
    "isSysRole": isSysRole,
  };

}
