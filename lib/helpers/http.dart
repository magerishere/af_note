import "dart:convert";
import "dart:io";

import "package:af_note/enums/http_methods.dart";
import "package:af_note/helpers/env.dart";
import "package:http/http.dart" as http;

final String baseApiUrl = Env.baseUrl;

class Http {
  Http(this.url);
  final String url;
  late HttpMethods method;
  Map<String, String> headers = {
    'Content-Type': 'application/json; charset=UTF-8'
  };
  Map<String, dynamic> _body = {};
  Map<String, File?> files = {};

  Http withHeaders(Map<String, String> data) {
    headers = data;
    return this;
  }

  Http withBody(Map<String, dynamic> data) {
    _body = data;
    return this;
  }

  Http withFiles(Map<String, File?> data) {
    files = data;
    return this;
  }

  Future<http.Response> get() async {
    method = HttpMethods.get;
    return await _send();
  }

  Future<http.Response> post() async {
    method = HttpMethods.post;
    return await _send();
  }

  Future<http.Response> patch() async {
    method = HttpMethods.patch;
    return await _send();
  }

  Future<http.Response> delete() async {
    method = HttpMethods.delete;
    return await _send();
  }

  Uri get _fullUrl {
    return Uri.parse('$baseApiUrl/$url');
  }

  String get _jsonBody {
    return jsonEncode(_body);
  }

  Future<http.Response> _send() async {
    late http.Response response;
    switch (method) {
      case HttpMethods.get:
        {
          response = await http.get(_fullUrl, headers: headers);
        }
        break;
      case HttpMethods.post:
        {
          response =
              await http.post(_fullUrl, headers: headers, body: _jsonBody);
        }
        break;
      case HttpMethods.put:
        {
          response =
              await http.put(_fullUrl, headers: headers, body: _jsonBody);
        }
        break;
      case HttpMethods.patch:
        {
          response =
              await http.patch(_fullUrl, headers: headers, body: _jsonBody);
        }
        break;
      case HttpMethods.delete:
        {
          response = await http.delete(_fullUrl, headers: headers);
        }
        break;
    }
    return response;
  }
}
