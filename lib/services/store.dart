import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/constants.dart';
import 'package:e_commerce/models/product.dart';

class Store {
  final Firestore _firestore = Firestore.instance;
  addProduct(Product product) async {
    await _firestore.collection(kProductCollection).add({
      kProductName: product.pName,
      kProductDescription: product.pDescription,
      kProductCategory: product.pCategory,
      kProductPrice: product.pPrice,
      kProductLocation: product.pLocation,
    });
  }

  Stream<QuerySnapshot> loadProduct()  {


   return _firestore.collection(kProductCollection).snapshots();
  }

  deleteProduct(documntId){
    _firestore.collection(kProductCollection).document(documntId).delete();
  }


  editProduct(data, documentId){
    _firestore.collection(kProductCollection).document().updateData(data);
  }

  storeOrders(data, List<Product> products){
     var documentRef  = _firestore.collection(kOrders).document();
     documentRef.setData(data);
     for (var product in products) {
            documentRef.collection(kOrdersDetails).document().setData({
               kProductName: product.pName,
        kProductPrice: product.pPrice,
        kProductQuantity: product.pQuantity,
        kProductLocation: product.pLocation
            });

     }
  }
}
