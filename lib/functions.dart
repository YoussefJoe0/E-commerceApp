import 'models/product.dart';

List<Product> GetProductByCategory(String kJackets, List<Product> allproducts) {
  List<Product> products = [];

  try{
  for (var product in allproducts) {
    if (product.pCategory == kJackets) {
      products.add(product);
    }
  }} on Error catch(ex){}
  return products;
}
