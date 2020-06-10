
import 'package:e_commerce/functions.dart';
import 'package:e_commerce/models/product.dart';
import 'package:e_commerce/screens/user/product_info.dart';
import 'package:flutter/material.dart';


Widget productView(String pCategory, List<Product> allproducts) {
  List<Product> products = [];
  products = GetProductByCategory(pCategory, allproducts);
  return GridView.builder(
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        childAspectRatio: .8, crossAxisCount: 2),
    itemBuilder: (context, index) => Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: (){
          Navigator.pushNamed(context, ProductInfo.id , arguments:  products[index]);
        },
        child: Stack(
          children: <Widget>[
            Positioned.fill(
              child: Image(
                fit: BoxFit.fill,
                image: AssetImage(products[index].pLocation),
              ),
            ),
            Positioned(
              bottom: 0,
              child: Opacity(
                opacity: .6,
                child: Expanded(
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(products[index].pName),
                          Text('\$ ${products[index].pPrice}'),
                        ],
                      ),
                    ),
                    color: Colors.white,
                    height: 60,
                    width: MediaQuery.of(context).size.width,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
    itemCount: products.length,
  );
}
