import 'package:e_commerce/models/product.dart';
import 'package:e_commerce/wedgits/custom_textfield.dart';
import 'package:flutter/material.dart';
import '../../services/store.dart';
import '../../constants.dart';

class EditProduct extends StatelessWidget {
  static String id = 'EditProduct';
  String _name, _price, _categories, _description, _imgeLogation;
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final _store = Store();
  @override
  Widget build(BuildContext context) {
    Product product = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      backgroundColor: kMainColor,
      body: Form(
        key: _globalKey,
        child: ListView(
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).size.height *.2,
            ),
            Column(
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

                      _store.editProduct(
                          {
                            kProductName: _name,
                            kProductCategory: _categories,
                            kProductDescription: _description,
                            kProductLocation: _imgeLogation,
                            kProductPrice: _price,
                          },
                          product.pId);
                    }
                  },
                  child: Text('Add Product'),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
