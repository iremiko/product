import 'dart:async';
import 'package:flutter/material.dart';
import 'package:product_app/model/product_model.dart';
import 'package:product_app/pages/product/create/product_create_bloc.dart';
import 'package:product_app/utils/dialog_utils.dart';
import 'package:product_app/widgets/icon_text_button.dart';
import 'package:product_app/widgets/my_text_form_field.dart';

class ProductCreatePage extends StatefulWidget {
  final Product product;
  final VoidCallback refreshPage;
  const ProductCreatePage({Key key, this.product, this.refreshPage}) : super(key: key);
  @override
  _ProductCreatePageState createState() => _ProductCreatePageState();
}

class _ProductCreatePageState extends State<ProductCreatePage> {

  Product _product;
  ProductCreateBloc _bloc;
  final _formKey = GlobalKey<FormState>();
  bool _isSubmitted = false;
  StreamSubscription _streamSubscription;

  @override
  void didChangeDependencies() {
    if(widget.product != null){
      _product = widget.product;
    }else{
      _product = Product();
    }

    if(_bloc == null){
      _bloc = ProductCreateBloc();
      _streamSubscription = _bloc.createUpdate.listen((_) {
        widget.refreshPage();
      }, onError: (error) {
        DialogUtils.showErrorDialog(context, error);
      });
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _bloc.dispose();
    _streamSubscription.cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_product != null ? 'Update Product' : 'Create Product'),),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Form(
            autovalidateMode: _isSubmitted
                ? AutovalidateMode.always
                : AutovalidateMode.disabled,
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                MyTextFormField(
                  initialValue: _product.code ?? '',
                  labelText: 'Code',
                  onSaved: (value){
                    _product.code = value;
                  },
                ),
                SizedBox(
                  height: 16,
                ),
                MyTextFormField(
                  initialValue: _product.name ?? '',
                  labelText: 'Name',
                  onSaved: (value){
                    _product.name = value;
                  },
                ),
                SizedBox(
                  height: 16,
                ),
                MyTextFormField(
                  initialValue: _product.price.toString() ?? '',
                  labelText: 'Price',
                  onSaved: (value){
                    _product.price = int.tryParse(value);
                  },
                ),
                SizedBox(
                  height: 16,
                ),
                IconTextButton(
                    onPressed: (){
                      _createUpdate();
                    },
                    iconData: Icons.check,
                    title: 'Submit'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _createUpdate() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
     _bloc.createUpdateProduct(_product.code, _product.name, _product.price);
    }else{
      setState(() {
        _isSubmitted = true;
      });
    }
  }
}
