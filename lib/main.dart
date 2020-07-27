import 'package:e_commerce/constants.dart';
import 'package:e_commerce/provider/admin_mode.dart';
import 'package:e_commerce/provider/cart_item.dart';
import 'package:e_commerce/provider/model_hud.dart';
import 'package:e_commerce/screens/admin/addProduct.dart';
import 'package:e_commerce/screens/admin/editProduct.dart';
import 'package:e_commerce/screens/admin/mangeProduct.dart';
import 'package:e_commerce/screens/admin/order_details.dart';
import 'package:e_commerce/screens/admin/orders_screen.dart';
import 'package:e_commerce/screens/user/cart_screen.dart';
import 'file:///C:/Users/yosse/AndroidStudioProjects/e_commerce/lib/screens/admin/admin_screen.dart';
import 'package:e_commerce/screens/user/home_screen.dart';
import 'package:e_commerce/screens/signup_screen.dart';
import 'package:e_commerce/screens/user/product_info.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './screens/login_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  bool isUserLoggedIn = false;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SharedPreferences>(
      future: SharedPreferences.getInstance(),
      builder: (ctx, snapshot) {
        if (!snapshot.hasData) {
          return MaterialApp(
            home: Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        } else {
          isUserLoggedIn = snapshot.data.get(kKeepMeLogedIn) ?? false;
          return MultiProvider(
            providers: [
              ChangeNotifierProvider<ModelHud>(
                create: (context) => ModelHud(),
              ),
              ChangeNotifierProvider<AdminMode>(
                create: (context) => AdminMode(),
              ),
              ChangeNotifierProvider<CartItem>(
                create: (context) => CartItem(),
              ),
            ],
            child: MaterialApp(
              theme: ThemeData(
                primaryColor: kMainColor,
                accentColor: kButtonColor,
              ),
              debugShowCheckedModeBanner: false,
              initialRoute: isUserLoggedIn ? HomeScreen.id : LoginScreen.id,
              routes: {
                LoginScreen.id: (context) => LoginScreen(),
                SignupScreen.id: (context) => SignupScreen(),
                HomeScreen.id: (context) => HomeScreen(),
                AdminScreen.id: (context) => AdminScreen(),
                AddProduct.id: (context) => AddProduct(),
                MangeProduct.id: (context) => MangeProduct(),
                EditProduct.id: (context) => EditProduct(),
                ProductInfo.id: (context) => ProductInfo(),
                CartScreen.id: (context) => CartScreen(),
                OrdersScreen.id: (context) => OrdersScreen(),
                OrderDetails.id: (context) => OrderDetails(),
              },
            ),
          );
        }
      },
    );
  }
}
