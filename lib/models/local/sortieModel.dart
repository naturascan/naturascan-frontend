import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:naturascan/Utils/Utils.dart';
import 'package:naturascan/models/local/naturascanModel.dart';
import 'package:naturascan/models/local/obstraceModel.dart';

class SortieModel {
  String? id;
  String? type;
  num? date;
  String? photo;
  // Uint8List? photo;
  NaturascanModel? naturascan;
  ObstraceModel? obstrace;
  bool? finished; 
  bool? synchronised;
  String? createdAt;

  SortieModel(
      {this.id,
      this.date,
      this.type,
      this.photo,
      this.naturascan,
      this.obstrace,
      this.finished,
      this.synchronised,
      this.createdAt});

  SortieModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    date = json['date'];
    type = json['type'];
    photo = json['photo'];
    naturascan = json['naturascan'] == null
        ? null
        : NaturascanModel.fromJson(jsonDecode(json['naturascan']));
    obstrace = json['obstrace'] == null
        ? null
        : ObstraceModel.fromJson(jsonDecode(json['obstrace']));
                   finished = json['finished'] == 0 ? false : true;
    synchronised = json['synchronised'] == 0 ? false : true;
    // print('jssonnn ${json['photo']}');
    createdAt = json['created_at'];
  }

  factory SortieModel.fromJson2(Map<String, dynamic> json) {
        print('jssonnn ${json['photo']}');
    SortieModel? sortie =  SortieModel(
    id : json['id'],
    type : json['type'],
    date : json['date'],
    photo: json['photo'],
    naturascan: json['naturascan'] == null
        ? null
        : NaturascanModel.fromJson2(json['naturascan']),
    obstrace: json['obstrace'] == null
        ? null
        : ObstraceModel.fromJson2(json['obstrace']),
    finished: true,
    synchronised: true,
    createdAt: json['created_at']
    );
    return sortie;
  }
  Future<Map<String, dynamic>> toJson() async{
                print("pjjjjjjjjjjjjj 1${photo}");

    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['type'] = type;
    data['date'] = date;
    data['type'] = type;
        String? path;
        if(photo != null){
 try {
     String normalPh = Utils().deCompressJson(photo!);
    Uint8List ph = base64Decode(normalPh);
     path = await Utils().storeImage(ph);
         data['photo'] = path;

    } catch (e) {
     // ph = base64Decode(json['photo']);
    }
    }
    // data['photo'] = photo == null ? null :  Utils().compressString(base64Encode(photo!));
    data['naturascan'] = naturascan == null ?  null : jsonEncode(naturascan?.toJson());
    data['obstrace'] = obstrace  == null ?  null :  jsonEncode(obstrace?.toJson());
    data['finished'] = finished == true ? 1 : 0 ;
    data['synchronised'] = synchronised == true ? 1 : 0;
    data['created_at'] = createdAt;
    return data;
  }
    Map<String, dynamic> toJson2() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['type'] = type;
    data['date'] = date;
    data['type'] = type;
    log('messagephoto $photo');
    if(photo != null){
       try{
     final imageFile = File(photo!).readAsBytesSync();
      data['photo'] = Utils().compressString(base64Encode(imageFile));
    } catch(e){
      data['photo'] = photo;
      print("messagephoto errorphoto $e");

    }
    }
    // data['photo'] = photo == null ? null :  Utils().compressString(base64Encode(photo!));
    data['naturascan'] = naturascan?.toJson2();
    data['obstrace'] = obstrace?.toJson2();
    data['finished'] = 1 ;
    data['synchronised'] = 1;
    data['created_at'] = createdAt;
    return data;
  }
}
