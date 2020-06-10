import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/models/product.dart';
import 'package:e_commerce/wedgits/custom_menu.dart';
import 'package:flutter/material.dart';
import 'package:e_commerce/services/store.dart';
import 'package:e_commerce/constants.dart';

import 'editProduct.dart';

class MangeProduct extends StatefulWidget {
  static String id = 'MangeProduct';

  @override
  _MangeProductState createState() => _MangeProductState();
}

class _MangeProductState extends State<MangeProduct> {
  final _store = Store();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
          stream: _store.loadProduct(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Product> products = [];
              for (var doc in snapshot.data.documents) {
                var date = doc.data;
                products.add(Product(
                  pId: doc.documentID,
                  pPrice: date[kProductPrice],
                  pLocation: date[kProductLocation],
                  pDescription: date[kProductDescription],
                  pCategory: date[kProductCategory],
                  pName: date[kProductName],
                ));
              }
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: .8, crossAxisCount: 2),
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTapUp: (details) async {
                      double dx = details.globalPosition.dx;
                      double dy = details.globalPosition.dy;
                      double dx2 = MediaQuery.of(context).size.width - dx;
                      double dy2 = MediaQuery.of(context).size.width - dy;
                      await showMenu(
                          context: context,
                          position: RelativeRect.fromLTRB(dx, dy, dx2, dy2),
                          items: [
                            MyPopupMenuItem(
                              onClick: () {
                                Navigator.pushNamed(context, EditProduct.id,
                                    arguments: products[index]);
                              },
                              child: Text('Edit'),
                            ),
                            MyPopupMenuItem(
                              onClick: () {
                                _store.deleteProduct(products[index].pId);
                                Navigator.pop(context);
                              },
                              child: Text('Delete'),
                            ),
                          ]);
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
            } else {
              return Center(child: Text('Loading..'));
            }
          }),
    );
  }
}

