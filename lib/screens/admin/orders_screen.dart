import 'package:e_commerce/constants.dart';
import 'package:e_commerce/models/order.dart';
import 'package:e_commerce/screens/admin/order_details.dart';
import 'package:e_commerce/services/store.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OrdersScreen extends StatelessWidget {
  static String id = 'OrdersScreen';
  final Store _store = Store();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: _store.loadOrders(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: Text('there is no orders'),
            );
          } else {
            List<Order> orders = [];
            for (var doc in snapshot.data.documents) {
              orders.add(Order(
                documentId: doc.documentID,
                address: doc.data[kAddress],
                totalPrice: doc.data[kTotalPrice],
              ));
            }
            return ListView.builder(
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.all(20),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, OrderDetails.id,
                        arguments: orders[index].documentId);
                  },
                  child: Container(
                    height: MediaQuery.of(context).size.height * .2,
                    color: kMainColor,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text('Totall Price = \$${orders[index].totalPrice}',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Address is ${orders[index].address}',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              itemCount: orders.length,
            );
          }
        },
      ),
    );
  }
}
