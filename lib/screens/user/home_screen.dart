import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/constants.dart';
import 'package:e_commerce/models/product.dart';
import 'package:e_commerce/screens/user/product_info.dart';
import 'package:e_commerce/services/auth.dart';
import 'package:e_commerce/services/store.dart';
import 'package:e_commerce/wedgits/product_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:e_commerce/constants.dart';
import '../../functions.dart';
import 'cart_screen.dart';

class HomeScreen extends StatefulWidget {
  static String id = 'HomeScreen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  int _bottonBarIndex = 0;
  TabController _tabController;
  final _auth = Auth();
  FirebaseUser _loggedUser;
  List<Product> _products;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  final _store = Store();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
          fixedColor: kButtonColor,
          currentIndex: _bottonBarIndex,
          type: BottomNavigationBarType.fixed,
          onTap: (value) {
            setState(() {
              _bottonBarIndex = value;
            });
          },
          items: [
            BottomNavigationBarItem(
              title: Text('1'),
              icon: Icon(Icons.add),
            ),
            BottomNavigationBarItem(
              title: Text('2'),
              icon: Icon(Icons.add),
            ),
            BottomNavigationBarItem(
              title: Text('3'),
              icon: Icon(Icons.add),
            ),
            BottomNavigationBarItem(
              title: Text('4'),
              icon: Icon(Icons.add),
            ),
          ]),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'discover'.toUpperCase(),
        ),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.pushNamed(context, CartScreen.id);
              }),
        ],
        bottom: TabBar(
          labelColor: Colors.white,
          unselectedLabelColor: kButtonColor,
          indicatorColor: Colors.white,
          tabs: [
            Tab(
              text: "Jackets".toUpperCase(),
            ),
            Tab(
              text: "Trousers".toUpperCase(),
            ),
            Tab(
              text: "T-shirts".toUpperCase(),
            ),
            Tab(
              text: "Shoes".toUpperCase(),
            ),
          ],
          controller: _tabController,
        ),
      ),
      body: Center(
        child: TabBarView(
          children: [
            jacketView(),
            productView(kTrousers, _products),
            productView(kTshirts, _products),
            productView(kShoes, _products),
          ],
          controller: _tabController,
        ),
      ),
    );
  }

  Widget jacketView() {
    return StreamBuilder<QuerySnapshot>(
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

            _products = [...products];
            products.clear();
            products = GetProductByCategory(kJackets, _products);
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: .8, crossAxisCount: 2),
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, ProductInfo.id,
                        arguments: products[index]);
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
          } else {
            return Center(child: Text('Loading..'));
          }
        });
  }
}
