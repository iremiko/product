import 'package:product_app/data/api_data.dart';
import 'package:product_app/data/shared_preferences.dart';
import 'package:product_app/model/product_model.dart';
import 'package:rxdart/rxdart.dart';

class ProductListBloc {
  final ApiData _apiData;
  final Preferences _preferences;

  ProductListBloc({
    ApiData apiData,
    Preferences preferences,
  }) : _apiData = apiData ?? ApiData(),
  _preferences = preferences ?? Preferences();

  final data = BehaviorSubject<List<Product>>();

  final isLoading = BehaviorSubject<bool>.seeded(false);
  final isEmpty = BehaviorSubject<bool>.seeded(false);

  getProductList() async {
    isLoading.add(true);
    try {
      //Get access token
      String accessToken =
      await _preferences.getAccessToken();
      List<Product> response = await _apiData.getProductList(accessToken);
      if(response.isNotEmpty)
       isEmpty.add(true) ;
      data.add(response);
    } catch (e) {
      data.addError(e);
    } finally {
      isLoading.add(false);
    }
  }

  void dispose() {
    data.close();
    isLoading.close();
    isEmpty.close();
  }
}
