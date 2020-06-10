import 'package:e_commerce/constants.dart';
import 'package:e_commerce/screens/admin/addProduct.dart';
import 'package:e_commerce/screens/admin/mangeProduct.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdminScreen extends StatelessWidget {
  static String id = 'AdminScreen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kMainColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            width: double.infinity,
          ),
          RaisedButton(
            padding: EdgeInsets.all(8),
            textColor: Colors.white,
            color: Colors.purple,
            onPressed: () {
              Navigator.pushNamed(context, AddProduct.id);
            },
            child: Text('Add Product'),
          ),
          RaisedButton(
            color: Colors.purple,
            textColor: Colors.white,
            padding: EdgeInsets.all(8),
            onPressed: () {
              Navigator.pushNamed(context, MangeProduct.id);
            },
            child: Text('Edit Product'),
          ),
          RaisedButton(
            padding: EdgeInsets.all(8),
            textColor: Colors.white,
            color: Colors.purple,
            onPressed: () {},
            child: Text('View Orders'),
          ),
        ],
      ),
    );
  }
}
