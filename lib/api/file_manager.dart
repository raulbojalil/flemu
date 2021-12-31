import 'dart:convert';
import 'package:http/http.dart' as http;

class GameData {
  final String name;
  final String url;

  GameData({required this.name, required this.url});
}

class FileManager {
  static Future<List<String>> listGames(String folder) async {
    var gameList = await _httpRequest(
        "http://localhost:5000/filemanager/list?folder=" + folder, "get", {});

    return List<String>.from(gameList);
  }

  static Future<http.Response> _getRequest(
      http.Client client, String method, String url, Object? body) async {
    var headers = {"content-type": "application/json"};
    if (method == "post")
      return await client.post(Uri.parse(url), body: body, headers: headers);
    if (method == "put")
      return await client.put(Uri.parse(url), body: body, headers: headers);
    if (method == "patch")
      return await client.patch(Uri.parse(url), body: body, headers: headers);

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
