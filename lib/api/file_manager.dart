import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import '../app_config.dart';

class GameSystem {
  final String id;
  final String name;
  final String handler;
  final String bios;

  GameSystem(
      {required this.id,
      required this.name,
      required this.handler,
      required this.bios});
}

class GameDescription {
  final String lang;
  final String description;

  GameDescription({required this.lang, required this.description});
}

class ListFile {
  final String name;
  final String url;

  ListFile({required this.name, required this.url});
}

class FileManager {
  static Future<List<ListFile>> listGames(String system) async {
    var gameList = await _requestJson(
        "${AppConfig.getInstance().apiUrl}/filemanager/list?system=$system",
        "get", {});

    var list = gameList.map((x) =>
        ListFile(url: x["url"]?.toString() ?? "", name: x["name"].toString()));

    return List<ListFile>.from(list);
  }

  static Future<List<GameDescription>> fetchGameDescription(
      String system, String name) async {
    var response = await _requestJson(
        "${AppConfig.getInstance().apiUrl}/filemanager/description?system=$system&name=$name",
        "get", {});

    var list = response.map((x) => GameDescription(
        lang: x["lang"].toString(), description: x["description"].toString()));

    return List<GameDescription>.from(list);
  }

  static Future<Response> fetchGameImage(String system, String name) async {
    return await _request(
        "${AppConfig.getInstance().apiUrl}/filemanager/image?system=$system&name=$name",
        "get", {});
  }

  static Future<List<GameSystem>> listSystems() async {
    var gameList = await _requestJson(
        "${AppConfig.getInstance().apiUrl}/filemanager/systems", "get", {});

    var list = gameList.map((x) => GameSystem(
        id: x["id"].toString(),
        name: x["name"].toString(),
        handler: x["handler"]?.toString() ?? "",
        bios: x["bios"]?.toString() ?? ""));

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

  static Future<Response> _request(String url, method, Map bodyMap,
      [bool authenticate = true]) async {
    var client = http.Client();

    return await _getRequest(client, method, url, json.encode(bodyMap));
  }

  static Future<dynamic> _requestJson(String url, method, Map bodyMap,
      [bool authenticate = true]) async {
    var client = http.Client();

    var response = await _getRequest(client, method, url, json.encode(bodyMap));

    dynamic parsedJson = json.decode(response.body);
    return parsedJson;
  }
}
