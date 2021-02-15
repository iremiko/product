import 'package:product_app/data/api_data.dart';
import 'package:product_app/data/shared_preferences.dart';
import 'package:product_app/model/product_model.dart';
import 'package:rxdart/rxdart.dart';

class ProductDetailBloc {
  final ApiData _apiData;
  final Preferences _preferences;

  ProductDetailBloc({
    ApiData apiData,
    Preferences preferences,
    int id,
  }) : _apiData = apiData ?? ApiData(),
        _preferences = preferences ?? Preferences(),
  _id = id;
final int _id;
  final data = BehaviorSubject<Product>();
  final delete = BehaviorSubject<Product>();

  final isLoading = BehaviorSubject<bool>.seeded(false);
  final isEmpty = BehaviorSubject<bool>.seeded(false);

  getProductDetail() async {
    isLoading.add(true);
    try {
      //Get access token
      String accessToken =
      await _preferences.getAccessToken();
      Product response = await _apiData.getProductDetail(_id,accessToken);
      data.add(response);
    } catch (e) {
      data.addError(e);
    } finally {
      isLoading.add(false);
    }
  }
  deleteProduct() async {
    isLoading.add(true);
    try {
      //Get access token
      String accessToken =
      await _preferences.getAccessToken();
      Product response = await _apiData.getProductDetail(_id,accessToken);
      delete.add(response);
    } catch (e) {
      delete.addError(e);
    } finally {
      isLoading.add(false);
    }
  }
  void dispose() {
    data.close();
    delete.close();
    isLoading.close();
    isEmpty.close();
  }
}
