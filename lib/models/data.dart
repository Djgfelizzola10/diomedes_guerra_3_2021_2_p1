import 'package:anime_app/models/anime.dart';

class Data {
  bool success =true;
  List<Anime> animes=[];

  Data({
    required this.success,
    required this.animes
    });

  Data.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      animes = [];
      json['data'].forEach((a) {
        animes.add(new Anime.fromJson(a));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['data'] = this.animes.map((v) => v.toJson()).toList();
    
    return data;
  }
} 