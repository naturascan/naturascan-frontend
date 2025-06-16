// To parse this JSON data, do
//
//     final me = meFromJson(jsonString);

import 'dart:convert';

Me meFromJson(String str) => Me.fromJson(json.decode(str));

String meToJson(Me data) => json.encode(data.toJson());

class Me {
  int? id;
  String? reference;
  String? name;
  String? firstname;
  String? email;
  String? mobileNumber;
  String? adress;
  List<Role>? roles;

  Me({
    this.id,
    this.reference,
    this.name,
    this.firstname,
    this.email,
    this.mobileNumber,
    this.adress,
    this.roles,
  });

  factory Me.fromJson(Map<String, dynamic> json) => Me(
    id: json["id"],
    reference: json["reference"],
    name: json["name"],
    firstname: json["firstname"],
    email: json["email"],
    mobileNumber: json["mobile_number"],
    adress: json["adress"],
    roles: json["roles"] == null ? [] : List<Role>.from(json["roles"]!.map((x) => Role.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "reference": reference,
    "name": name,
    "firstname": firstname,
    "email": email,
    "mobile_number": mobileNumber,
    "adress": adress,
    "roles": roles == null ? [] : List<dynamic>.from(roles!.map((x) => x.toJson())),
  };
}

class Role {
  int? id;
  String? reference;
  String? name;
  String? description;
  int? enabled;
  int? isSysRole;
  DateTime? createdAt;
  DateTime? updatedAt;
  Pivot? pivot;

  Role({
    this.id,
    this.reference,
    this.name,
    this.description,
    this.enabled,
    this.isSysRole,
    this.createdAt,
    this.updatedAt,
    this.pivot,
  });

  factory Role.fromJson(Map<String, dynamic> json) => Role(
    id: json["id"],
    reference: json["reference"],
    name: json["name"],
    description: json["description"],
    enabled: json["enabled"],
    isSysRole: json["isSysRole"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    pivot: json["pivot"] == null ? null : Pivot.fromJson(json["pivot"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "reference": reference,
    "name": name,
    "description": description,
    "enabled": enabled,
    "isSysRole": isSysRole,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "pivot": pivot?.toJson(),
  };
}

class Pivot {
  int? userId;
  int? roleId;

  Pivot({
    this.userId,
    this.roleId,
  });

  factory Pivot.fromJson(Map<String, dynamic> json) => Pivot(
    userId: json["user_id"],
    roleId: json["role_id"],
  );

  Map<String, dynamic> toJson() => {
    "user_id": userId,
    "role_id": roleId,
  };
}
