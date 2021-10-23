import 'package:anime_app/models/fact.dart';

class Data2 {
  bool success=true;
  String img='';
  int totalFacts=0;
  List<Fact> fact=[];

  Data2({
    required this.success,
    required this.img,
    required this.totalFacts,
    required this.fact
    });

  Data2.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    img = json['img'];
    totalFacts = json['total_facts'];
    if (json['data'] != null) {
      fact = [];
      json['data'].forEach((v) {
        fact.add(new Fact.fromJson(v));
      });
     }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['img'] = this.img;
    data['total_facts'] = this.totalFacts;
    data['data'] = this.fact.map((v) => v.toJson()).toList();

    return data;
  }
}