import 'dart:convert';
import 'dart:developer';

import 'roleModel.dart';

class UserModel {
  String? id;
  String? name;
  String? firstname;
  String? email;
  String? mobileNumber;
  String? adress;
  List<RoleModel>? roles;
  String? access;
  int? totalExport;
  String? pseudo;
  String? createdAt;

  UserModel(
      {this.id,
      this.name,
      this.firstname,
      this.email,
      this.mobileNumber,
      this.adress,
      this.roles,
      this.access,
      this.pseudo,
      this.totalExport,
      this.createdAt});

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    firstname = json['firstname'];
    email = json['email'];
    mobileNumber = json['mobile_number'];
    adress = json['adress'];
    access = json['access'];
    pseudo = json['pseudo'];
    totalExport = json['total_export'];
    log("${json["roles"].runtimeType}ccccc");
    try {
      var rol = List<Map<String, dynamic>>.from(json["roles"]);
      log(rol.runtimeType.toString());
      if (rol.isNotEmpty) {
        roles = rol.map((x) {
          log(x.toString());
          log(x.runtimeType.toString());
          return RoleModel.fromJson(x);
        }).toList();
      } else {
        roles = <RoleModel>[];
      }
    } catch (e) {
      roles = json["roles"] == null
          ? null
          : List<RoleModel>.from(
              jsonDecode(json["roles"])!.map((x) => RoleModel.fromJson(x)));
    }
    // roles = json["roles"] == null
    //     ? null
    //     : List<RoleModel>.from(
    //         jsonDecode(json["roles"])!.map((x) => RoleModel.fromJson(x)));

    log("${json["roles"].runtimeType}ccccc");
    createdAt = json['created_at'];
  }

  factory UserModel.fromJson2(Map<String, dynamic> json) {
    final roles = json["roles"] != null
        ? (json["roles"] as List).map((x) => RoleModel.fromJson(x)).toList()
        : null;

    return UserModel(
      id: json['id'].toString(),
      name: json['name'],
      firstname: json['firstname'],
      email: json['email'],
      mobileNumber: json['mobile_number'],
      adress: json['adress'],
      access: json['access'],
      pseudo: json['pseudo'],
      totalExport: json['total_export'],
      roles: roles,
      createdAt: json['created_at'],
    );
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
   try{
     data['id'] = id;
    data['name'] = name;
    data['firstname'] = firstname;
    data['email'] = email;
    data['mobile_number'] = mobileNumber;
    data['adress'] = adress;
    data['access'] = access;
    data['pseudo'] = pseudo;
    data['total_export'] = totalExport;
    if (roles != null) {
      data['roles'] = jsonEncode(roles!.map((v) => v.toJson()).toList());
    }
    data['created_at'] = createdAt;
    return data;
   }catch(e){
    print("le pb json1 usrr ^$e");

    return data;
   }
  }

    Map<String, dynamic> toJson2() {
      final Map<String, dynamic> data = <String, dynamic>{};
  try{
    data['id'] = id;
    data['name'] = name;
    data['firstname'] = firstname;
    data['email'] = email;
    data['mobile_number'] = mobileNumber;
    data['adress'] = adress;
    data['access'] = access;
    data['pseudo'] = pseudo;
    data['total_export'] = totalExport;
    if (roles != null) {
      data['roles'] = roles!.map((v) => v.toJson()).toList();
    }
    data['created_at'] = createdAt;
    return data;

  }catch(e){
    print("le pb json2 usrr ^$e");

    return data;
  }
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
