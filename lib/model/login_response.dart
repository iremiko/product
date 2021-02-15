import 'package:product_app/model/user_model.dart';

class Login{
  String accessToken;
  User user;

  Login.fromJson(Map<String, dynamic> json) {
    accessToken = json['accessToken'];
    user = json['user'] != null
        ? User.fromJson(json['user'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['accessToken'] = this.accessToken;
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    return data;
  }
}