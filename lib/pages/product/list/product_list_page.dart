import 'dart:async';

import 'package:flutter/material.dart';
import 'package:product_app/model/product_model.dart';
import 'package:product_app/pages/product/list/product_list_bloc.dart';
import 'package:product_app/pages/product/list/product_list_card.dart';
import 'package:product_app/utils/dialog_utils.dart';
import 'package:product_app/widgets/empty_view.dart';
import 'package:product_app/widgets/error_view.dart';
import 'package:product_app/widgets/loading_view.dart';
import 'package:product_app/pages/product/create/product_create_page.dart';


class ProductListPage extends StatefulWidget {
  @override
  _ProductListPageState createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {

  ProductListBloc _bloc;
  StreamSubscription _streamSubscription;
  final ScrollController _scrollController = ScrollController();
  @override
  void didChangeDependencies() {
  if(_bloc == null){
    _bloc = ProductListBloc();
    _streamSubscription = _bloc.data.listen((_) {}, onError: (error) {
      DialogUtils.showErrorDialog(context, error, onTryAgainTap: _onTryAgain);
    });
    _bloc.getProductList();
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
    return  Scaffold(
      appBar: AppBar(
        title: Text('Products'),
        actions: [
          IconButton(icon: Icon(Icons.add), onPressed: ()=> Navigator.of(context).push(
      MaterialPageRoute(builder: (BuildContext context) {
        return ProductCreatePage(
          refreshPage: _onTryAgain,
        );
      }),
    ),),
        ],
      ),
      body: Stack(
        children: <Widget>[
          StreamBuilder(
              stream: _bloc.data,
              builder: (BuildContext context,
                  AsyncSnapshot<List<Product>> snapshot) {
                if (snapshot.hasData) {
                  return GridView.builder(
                    padding: EdgeInsets.all(
                        8.0
                    ),
                    itemCount: snapshot.data.length,
                    shrinkWrap: true,
                    gridDelegate:
                    new SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: 0.75,
                        crossAxisCount: 2,
                        mainAxisSpacing: 8.0,
                        crossAxisSpacing: 8.0),
                    itemBuilder: (BuildContext context, int index) {
                      return ProductListCard( product: snapshot.data[index],);
                    },
                    controller: _scrollController,
                  );
                } else if (snapshot.hasError) {
                  return ErrorView(
                      error: snapshot.error, onTryAgain: _onTryAgain);
                } else {
                  return const SizedBox();
                }
              }),
          StreamBuilder(
              initialData: false,
              stream: _bloc.isLoading,
              builder:
                  (BuildContext context, AsyncSnapshot<bool> snapshot) {
                return snapshot.data ? LoadingView() : const SizedBox();
              }),
          StreamBuilder(
            initialData: false,
            stream: _bloc.isEmpty,
            builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
              return snapshot.data
                  ? EmptyView()
                  : const SizedBox();
            },
          ),
        ],
      ),
    );
  }
  void _onTryAgain() {
    _bloc.getProductList();
  }
}

