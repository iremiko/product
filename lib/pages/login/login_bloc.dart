import 'dart:async';
import 'package:logging/logging.dart';
import 'package:product_app/data/api_data.dart';
import 'package:product_app/data/shared_preferences.dart';
import 'package:product_app/model/login_response.dart';
import 'package:product_app/model/user_model.dart';
import 'package:rxdart/rxdart.dart';

class LoginBloc {
  LoginBloc({
    Preferences preferences,
    ApiData apiData,
  })  : _preferences = preferences ?? Preferences(),
        _apiData = apiData ?? ApiData();

  final Preferences _preferences;
  final ApiData _apiData;
  final log = Logger('LoginBloc');

  ValueStream<User> get currentUser => _currentUserSubject.stream;

  ValueStream<bool> get isLoading => _isLoadingSubject.stream;

  final _currentUserSubject = BehaviorSubject<User>();

  final _isLoadingSubject = BehaviorSubject<bool>.seeded(false);

  Future<void> login(String username, String password) async {
    _isLoadingSubject.add(true);
    try {
      Login response = await _apiData.login(username, password);

      //Save access token
      await _preferences.setAccessToken(response.accessToken);

      //Save user
      await _preferences.setCurrentUser(response.user);

      //Add user to stream
      _currentUserSubject.add(response.user);
    } catch (error, stacktrace) {
      log.info("LOGIN ERROR: ${error.toString()}");
      log.info(stacktrace);
      _currentUserSubject.addError(error);
    } finally {
      _isLoadingSubject.add(false);
    }
  }

  Future<void> checkUser() async {
    log.info('Start Checking User');
    User user = await _preferences.getCurrentUser();
    _currentUserSubject.add(user);
    log.info('End Checking User');
  }

  Future<void> updateUser(User user) async {
    log.info('Start Update User');
    await _preferences.setCurrentUser(user);
    _currentUserSubject.add(user);
    log.info('End Update User');
  }

  Future<void> logout() async {
    await _preferences.setCurrentUser(null);
    await _preferences.setAccessToken(null);
    _currentUserSubject.add(null);
  }

  void dispose() {
    _currentUserSubject.close();
    _isLoadingSubject.close();
  }
}
