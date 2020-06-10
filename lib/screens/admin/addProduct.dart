import 'package:e_commerce/constants.dart';
import 'package:e_commerce/models/product.dart';
import 'package:e_commerce/services/store.dart';
import 'package:e_commerce/wedgits/custom_textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddProduct extends StatelessWidget {
  static String id = 'AddProduct';
  String _name, _price, _categories , _description, _imgeLogation;
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final _store = Store();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kMainColor,
      body: Form(
        key: _globalKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CustomTextField(
              onClick: (value) {
                _name = value;
              },
              hint: 'Product Name',
              icon: null,
            ),
            SizedBox(
              height: 10,
            ),
            CustomTextField(
              onClick: (value) {
                _price = value;
              },
              hint: 'Product Price',
              icon: null,
            ),
            SizedBox(
              height: 10,
            ),
            CustomTextField(
              onClick: (value) {
                _description = value;
              },
              hint: 'Product Description',
            ),
            SizedBox(
              height: 10,
            ),
            CustomTextField(
              onClick: (value) {
                _categories = value;
              },
              hint: 'Product Category',
              icon: null,
            ),
            SizedBox(
              height: 10,
            ),
            CustomTextField(
              onClick: (value) {
                _imgeLogation = value;
              },
              hint: 'Product Location',
              icon: null,
            ),
            SizedBox(
              height: 10,
            ),
            RaisedButton(
              color: kButtonColor,
              textColor: Colors.white,
              padding: EdgeInsets.all(8),
              onPressed: () {
                if (_globalKey.currentState.validate()) {
                  _globalKey.currentState.save();

                  _store.addProduct(Product(
                    pName: _name,
                    pCategory: _categories,
                    pDescription: _description,
                    pLocation: _imgeLogation,
                    pPrice: _price,


                  ));
                }
              },
              child: Text('Add Product'),
            )
          ],
        ),
      ),
    );
  }
}
