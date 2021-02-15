/// 13.02.2021
/// Irem Arikan

import 'package:flutter/material.dart';
import 'package:product_app/data/shared_preferences.dart';
import 'package:product_app/model/user_model.dart';
import 'package:product_app/pages/login/login_bloc.dart';
import 'package:product_app/pages/login/login_page.dart';
import 'package:product_app/pages/product/list/product_list_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
static Color appColor = Color(0xFF2E2E56);
static Color secondaryColor = Color(0xFFB9B1C0);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
User user;
  LoginBloc _loginBloc;
  @override
  void initState() {
    if(_loginBloc == null) {
      _loginBloc = LoginBloc();
      getUser();
    }
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Product App',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        primaryTextTheme: TextTheme(
            headline6: TextStyle(
                color: Colors.white
            )
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        backgroundColor: Colors.white,
        scaffoldBackgroundColor: Colors.white,
        cardColor: Colors.white,
        errorColor: Colors.redAccent,
        primaryColor: MyApp.appColor,
        dividerColor:MyApp.secondaryColor,
        iconTheme: IconThemeData(color:MyApp.appColor),
        textTheme: TextTheme(
          headline6: Theme.of(context).textTheme.headline6.copyWith(color: Colors.black87),
          subtitle1: Theme.of(context).textTheme.subtitle1.copyWith(color: Colors.black87),
          bodyText2: Theme.of(context).textTheme.bodyText2.copyWith(color: Colors.black87),
          bodyText1: Theme.of(context).textTheme.bodyText1.copyWith(color: Colors.black87),
          caption: Theme.of(context).textTheme.caption.copyWith(color: Colors.black87),
        ),
      ),
      home: user != null ? LoginPage(loginBloc: _loginBloc,) : ProductListPage(),
    );
  }

  Future<User> getUser() async {
    Preferences preferences = Preferences();
   user = await preferences.getCurrentUser();
    return user;
  }
}



