import 'dart:convert';
import 'package:http/http.dart' as http;

import '../constants.dart';

class GameSystem {
  final String name;
  final String core;

  GameSystem({required this.name, required this.core});
}

class GameDescription {
  final String lang;
  final String description;

  GameDescription({required this.lang, required this.description});
}

class FileManager {
  static Future<List<String>> listGames(String folder) async {
    var gameList = await _httpRequest(
        "$backendUrl/filemanager/list?folder=$folder", "get", {});

    return List<String>.from(gameList);
  }

  static Future<List<GameDescription>> fetchGameDescription(
      String system, String name) async {
    var gameList = await _httpRequest(
        "$backendUrl/filemanager/description?system=$system&name=$name",
        "get", {});

    var list = gameList.map((x) => GameDescription(
        lang: x["lang"].toString(), description: x["description"].toString()));

    return List<GameDescription>.from(list);
  }

  static Future<List<GameSystem>> listSystems() async {
    var gameList =
        await _httpRequest("$backendUrl/filemanager/systems", "get", {});

    var list = gameList.map((x) =>
        GameSystem(name: x["name"].toString(), core: x["core"].toString()));

    return List<GameSystem>.from(list);
  }

  static Future<http.Response> _getRequest(
      http.Client client, String method, String url, Object? body) async {
    var headers = {"content-type": "application/json"};
    if (method == "post") {
      return await client.post(Uri.parse(url), body: body, headers: headers);
    }
    if (method == "put") {
      return await client.put(Uri.parse(url), body: body, headers: headers);
    }
    if (method == "patch") {
      return await client.patch(Uri.parse(url), body: body, headers: headers);
    }

    return await client.get(Uri.parse(url));
  }

  static Future<dynamic> _httpRequest(String url, method, Map bodyMap,
      [bool authenticate = true]) async {
    var client = http.Client();

    var response = await _getRequest(client, method, url, json.encode(bodyMap));

    dynamic parsedJson = json.decode(response.body);
    return parsedJson;
  }
}
