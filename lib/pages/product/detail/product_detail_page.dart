import 'dart:async';

import 'package:flutter/material.dart';
import 'package:product_app/model/product_model.dart';
import 'package:product_app/pages/product/detail/product_detail_bloc.dart';
import 'package:product_app/pages/product/create/product_create_page.dart';
import 'package:product_app/utils/dialog_utils.dart';
import 'package:product_app/widgets/error_view.dart';
import 'package:product_app/widgets/icon_text_button.dart';
import 'package:product_app/widgets/loading_view.dart';

class ProductDetailPage extends StatefulWidget {
  final int id;
final VoidCallback refreshPage;
  const ProductDetailPage({Key key, this.id, this.refreshPage}) : super(key: key);

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  ProductDetailBloc _bloc;
  StreamSubscription _streamSubscription, _deleteSubscription;

   @override
  void didChangeDependencies() {
    if(_bloc == null){
      _bloc = ProductDetailBloc(id: widget.id);
      _streamSubscription = _bloc.data.listen((_) {}, onError: (error) {
        DialogUtils.showErrorDialog(context, error, onTryAgainTap: _onTryAgain);
      });
      _deleteSubscription = _bloc.delete.listen((_) {
        widget.refreshPage();
        Navigator.pop(context);
      }, onError: (error) {
        DialogUtils.showErrorDialog(context, error, onTryAgainTap: _onTryAgain);
      });
      _bloc.getProductDetail();
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _bloc.dispose();
    _streamSubscription.cancel();
    _deleteSubscription.cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    double imageWidth = MediaQuery.of(context).size.shortestSide;
    double imageHeight = imageWidth * 9 / 16;
    return StreamBuilder(
      stream: _bloc.data,
      builder: (BuildContext context, AsyncSnapshot<Product> snapshot) {
        Widget body;
        if (snapshot.hasData) {
          Product product = snapshot.data;
          body =  Column(
            children: [
              Expanded(
                child: ListView(
                  children: <Widget>[
                    if (product.photo != null && product.photo.isNotEmpty)
                      Image.network(
                        product.photo,
                        fit: BoxFit.cover,
                        width: imageWidth,
                        height: imageHeight,
                      ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  product.code ?? '',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2
                                      .copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 16.0,
                              ),
                              Expanded(
                                child: Text(
                                  product.lastUpdated ?? '',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2
                                      .copyWith(
                                    fontSize: 12,
                                  ),
                                  textAlign: TextAlign.end,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Text(
                            product.name ?? '',
                            style: Theme.of(context).textTheme.headline6.copyWith(
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            product.price.toString() ?? '',
                            style: Theme.of(context).textTheme.headline6.copyWith(),
                          ),
                          SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Card(
                elevation: 2,
                margin: EdgeInsets.zero,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: IconTextButton(
                            iconData: Icons.edit,
                            title: 'Edit',
                            onPressed: ()=> Navigator.of(context).push(
                              MaterialPageRoute(builder: (BuildContext context) {
                                return ProductCreatePage(
                                  product: product,
                                  refreshPage: _onTryAgain,
                                );
                              }),
                            ),
                          ),
                        ),
                        SizedBox(width: 16.0,),
                        Expanded(
                          child: IconTextButton(
                            iconData: Icons.delete,
                            title: 'Clear',
                            onPressed: (){
                              _deleteDialog();
                            },
                          ),
                        )
                      ]),
                ),
              )
            ],
          );
        } else if (snapshot.hasError) {
          body = ErrorView(error: snapshot.error, onTryAgain: _onTryAgain);
        } else {
          body = LoadingView();
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(snapshot.hasData ? snapshot.data.name : ''),
          ),
          body: body,
        );
      },
    );
  }

  void _onTryAgain() {
    _bloc.getProductDetail();
  }
  void _deleteProduct() {
    _bloc.deleteProduct();
  }
  void _deleteDialog(){
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text('Are sure you want to delete the product?'),
            actions: [
              FlatButton.icon(
                  color: Theme.of(context).errorColor,
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.clear),
                  label: Text('No')),
                FlatButton.icon(
                    color: Theme.of(context).primaryColor,
                    onPressed: () {
                      Navigator.pop(context);
                      _deleteProduct();
                    },
                    icon: Icon(Icons.check),
                    label: Text('Yes'))
            ],
          );
        });
  }
}
