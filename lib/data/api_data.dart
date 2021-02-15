import 'dart:convert';
import 'dart:io';

import 'package:product_app/data/api_base.dart';
import 'package:product_app/model/login_response.dart';
import 'package:product_app/model/product_model.dart';

class ApiData extends ApiBase {
  String loginPath = '';
  String productPath = 'product';

  ApiData({String defaultUrl, HttpClient client})
      : super(defaultUrl: defaultUrl, client: client);

  Future<Login> login(
    String username,
    String password,
  ) async {
    Uri uri = createUri(defaultUrl, '$loginPath', {
      'username': username,
      'password': password,
    });
    final response = await post(uri);

    final jsonDecoded = json.decode(response.body);

    final result = Login.fromJson(jsonDecoded);

    return result;
  }

  Future<List<Product>> getProductList(String accessToken) async {
    Uri uri = createUri(defaultUrl, '$productPath');

    final response = await get(uri, accessToken: accessToken);
    final jsonDecoded = json.decode(response.body);
    final result =
        (jsonDecoded as List).map((e) => Product.fromJson(e)).toList();
    return result;
  }

  Future<Product> getProductDetail(int id, String accessToken) async {
    Uri uri = createUri(defaultUrl, '$productPath/$id');

    final response = await get(uri, accessToken: accessToken);
    final result = Product.fromJson(json.decode(response.body));
    return result;
  }
  Future<Product> createUpdateProduct(String code, String name,  int price, String accessToken) async {
    Uri uri = createUri(defaultUrl, '$productPath', {
      'Code': code,
      'Name': name,
      'Price': price.toString(),
    });

    final response = await put(uri, accessToken: accessToken);
    final result = Product.fromJson(json.decode(response.body));
    return result;
  }

  Future<Product> deleteProduct(int id, String accessToken) async {
    Uri uri = createUri(defaultUrl, '$productPath', {'id': id.toString()});

    final response = await del(uri, accessToken: accessToken);
    final result = Product.fromJson(json.decode(response.body));
    return result;
  }
}
