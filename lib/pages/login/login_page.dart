import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

import 'package:logging/logging.dart';
import 'package:product_app/model/user_model.dart';
import 'package:product_app/pages/login/login_bloc.dart';
import 'package:product_app/pages/product/list/product_list_page.dart';
import 'package:product_app/utils/dialog_utils.dart';
import 'package:product_app/widgets/icon_text_button.dart';
import 'package:product_app/widgets/loading_view.dart';
import 'package:product_app/widgets/my_text_form_field.dart';

class LoginPage extends StatefulWidget {
  final LoginBloc loginBloc;

  const LoginPage({Key key, this.loginBloc}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final log = Logger('_LoginPageState');
  StreamSubscription<User> _userStreamSubscription;
  bool _isSubmitted = false;

  @override
  void initState() {
    _userStreamSubscription = widget.loginBloc.currentUser.listen(
          (user) {
        log.info('CurrentUser: $user');
        if(user!=null)
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => ProductListPage(
              ),
            ),
            ModalRoute.withName(Navigator.defaultRouteName),
          );

      },
      onError: (error) {
        DialogUtils.showErrorDialog(context, error);
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    _userStreamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);
    return Scaffold(
      body: SafeArea(
        child: StreamBuilder<bool>(
            initialData: false,
            stream: widget.loginBloc.isLoading,
            builder: (context, snapshot) {
              return Stack(
                children: <Widget>[
                  SingleChildScrollView(
                    padding: EdgeInsets.all(32.0),
                    child: Form(
                      autovalidateMode: _isSubmitted
                          ? AutovalidateMode.always
                          : AutovalidateMode.disabled,
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            height: 48,
                          ),
                          Text(
                            'Sign In',
                            style: Theme.of(context).textTheme.headline6,
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: 48,
                          ),
                          MyTextFormField(
                            labelText: 'Username',
                            controller: _usernameController,
                            validator: (String value) {
                              if (value.isEmpty) {
                                return 'This field should not be empty!';
                              }
                              return null;
                            },
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (_) =>
                                FocusScope.of(context).requestFocus(node),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          MyTextFormField(
                            labelText: 'Password',
                            validator: (String value) {
                              if (value.isEmpty) {
                                return 'This field should not be empty!';
                              }
                              return null;
                            },
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (_) {
                              _login();
                            },
                            obscureText: true,
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          IconTextButton(
                              onPressed: (){
                                _login();
                              },
                              iconData: Icons.check,
                              title: 'Login'),
                        ],
                      ),
                    ),
                  ),
                  snapshot.data ? LoadingView() : const SizedBox()
                ],
              );
            }),
      ),
    );
  }

  void _login() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      widget.loginBloc.login(_usernameController.text,_passwordController.text);
    }else{
      setState(() {
        _isSubmitted = true;
      });
    }
  }
}
