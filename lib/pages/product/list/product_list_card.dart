import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:product_app/model/product_model.dart';
import 'package:product_app/pages/product/detail/product_detail_page.dart';

class ProductListCard extends StatelessWidget {
  final Product product;
  final VoidCallback refreshPage;
  const ProductListCard({Key key, this.product, this.refreshPage}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    double width = (MediaQuery.of(context).size.width-24.0)/2;
    double height =  width ;
    return GestureDetector(
     onTap: () =>    Navigator.of(context).push(
       MaterialPageRoute(builder: (BuildContext context) {
         return ProductDetailPage(
           id: product.id,
           refreshPage: refreshPage,
         );
       }),
     ),
      child: Card(
        margin: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CachedNetworkImage(imageUrl: product.photo, height: height,
            width: width,),
            Divider(height: 0,),
            Padding(
              padding: const EdgeInsets.only(left: 10.0,right: 10.0,top: 10.0,bottom: 4.0),
              child: Text('${product.name}'),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0,right: 10.0,bottom: 10.0),
              child: Text('${product.price}\$'),
            ),
          ],
        ),
      ),
    );
  }
}

