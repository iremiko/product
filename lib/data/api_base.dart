import 'dart:async';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';
import 'package:product_app/data/constants.dart' as constants;
import 'package:product_app/utils/status_error.dart';

abstract class ApiBase {
  ApiBase({String defaultUrl, HttpClient client})
      : defaultUrl = defaultUrl ?? constants.defaultUrl,
        client = client ?? http.Client();

  String defaultUrl;
  http.Client client;

  final log = Logger('API');

  Future<http.Response> get(Uri uri, {String accessToken}) async {
    log.info(uri.toString());
    final response = await client.get(uri, headers: {
      HttpHeaders.acceptHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer $accessToken'
    }).timeout(Duration(seconds: 30));

    if (response.statusCode == 200) {
      return response;
    } else {
      throw StatusError(response.statusCode, response.body);
    }
  }

  Future<http.Response> del(Uri uri, {String accessToken}) async {
    log.info(uri.toString());
    final response = await client.delete(uri, headers: {
      HttpHeaders.acceptHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer $accessToken'
    }).timeout(Duration(seconds: 30));

    if (response.statusCode == 200) {
      return response;
    } else {
      throw StatusError(response.statusCode, response.body);
    }
  }

  Future<http.Response> put(Uri uri,  {String accessToken}) async {
    log.info(uri.toString());

    final response = await client.put(
      uri,
      headers: {
        HttpHeaders.acceptHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $accessToken'
      },
    ).timeout(Duration(seconds: 30));

    if (response.statusCode == 200) {
      return response;
    } else {
      throw StatusError(response.statusCode, response.body);
    }
  }

  Future<http.Response> post(Uri uri,
      {String accessToken}) async {
    log.info(uri.toString());


    final response = await client.post(
      uri,
      headers: {
        HttpHeaders.acceptHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $accessToken'
      },
    ).timeout(Duration(seconds: 30));

    if (response.statusCode == 200) {
      return response;
    } else {
      throw StatusError(response.statusCode, response.body);
    }
  }

  Uri createUri(String defaultUrl, String unEncodedPath,
      [Map<String, String> queryParameters]) {
    return Uri.https(defaultUrl, '$unEncodedPath', queryParameters);
  }
}
