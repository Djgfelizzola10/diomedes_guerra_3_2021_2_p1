import 'dart:convert';

import 'package:anime_app/helpers/constans.dart';
import 'package:anime_app/models/anime.dart';
import 'package:anime_app/models/data.dart';
import 'package:anime_app/models/data2.dart';
import 'package:anime_app/models/response.dart';
import 'package:http/http.dart' as http;

class ApiHelper {

static Future<Response> getAnimes() async{
    var url=Uri.parse('${Constans.apiUrl}/api/v1');
    var response=await http.get(
      url,
    );

    var body = response.body;
    if(response.statusCode >= 400){
      return Response(isSuccess: false, message: body);
    }

    var decodedJson = jsonDecode(body);
    return Response(isSuccess: true, result: Data.fromJson(decodedJson));
  } 

  static Future<Response> getFact(String name) async{
    var url=Uri.parse('${Constans.apiUrl}/api/v1/$name');
    var response=await http.get(
      url,
    );

    var body = response.body;
    if(response.statusCode >= 400){
      return Response(isSuccess: false, message: body);
    }

    var decodedJson = jsonDecode(body);
    return Response(isSuccess: true, result: Data2.fromJson(decodedJson));
  } 

}