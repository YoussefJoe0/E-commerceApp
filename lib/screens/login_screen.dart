import 'package:e_commerce/constants.dart';
import 'package:e_commerce/provider/admin_mode.dart';
import 'package:e_commerce/provider/model_hud.dart';
import 'package:e_commerce/screens/user/home_screen.dart';
import 'package:e_commerce/screens/signup_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import '../wedgits/custom_textfield.dart';
import '../services/auth.dart';
import 'package:provider/provider.dart';

import 'admin/admin_screen.dart';

class LoginScreen extends StatelessWidget {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  static String id = 'LoginScreen';
  String email, password;
  final _auth = Auth();
  bool isAdmin = false;
  final adminPassword = 'admin12345';
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: kMainColor,
      body: ModalProgressHUD(
        inAsyncCall: Provider.of<ModelHud>(context, listen: false).isLoading,
        child: Form(
          key: _globalKey,
          child: ListView(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * .1),
                child: Column(
                  children: <Widget>[
                    Container(
                      height: 75,
                      width: 75,
                      child: Image(
                        image: AssetImage('assets/images/logo.png'),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      'E-Commerce',
                      style: TextStyle(
                          fontFamily: 'Pacifico',
                          fontSize: 25,
                          color: Colors.white),
                    )
                  ],
                ),
              ),
              SizedBox(height: height * .1),
              CustomTextField(
                  onClick: (value) {
                    email = value;
                  },
                  hint: 'Enter your email',
                  icon: Icons.email),
              SizedBox(height: height * .02),
              CustomTextField(
                  onClick: (value) {
                    password = value;
                  },
                  hint: 'Enter your password',
                  icon: Icons.lock),
              SizedBox(height: height * .05),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 100),
                child: Builder(
                  builder: (context) => FlatButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    color: kButtonColor,
                    onPressed: () {
                      _validate(context);
                    },
                    child: Text(
                      'Login',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
              SizedBox(height: height * .02),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Don't have an account ?",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      Navigator.pushNamed(context, SignupScreen.id);
                    },
                    child: Text(
                      'Sign up',
                      style: TextStyle(
                        color: kButtonColor,
                        fontSize: 18,
                      ),
                    ),
                  )
                ],
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                        child: GestureDetector(
                      onTap: () {
                        Provider.of<AdminMode>(context, listen: false).changeIsAdmin(true);
                      },
                      child: Text(
                        "I'm an admin",
                        style: TextStyle(
                          color: Provider.of<AdminMode>(context)
                                  .isAdmin
                              ? kMainColor
                              : Colors.white,
                        ),
                      ),
                    )),
                    Expanded(
                      child: GestureDetector (
                        onTap: () async{
                         await Provider.of<AdminMode>(context, listen: false)
                              .changeIsAdmin(false);
                        },
                        child: Text(
                          "I'm a user",
                          style: TextStyle(
                            color:
                                Provider.of<AdminMode>(context)
                                        .isAdmin
                                    ? Colors.white
                                    : kMainColor,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _validate(BuildContext context) async {
    final modelHud = Provider.of<ModelHud>(context, listen: false);
    modelHud.changeisLoading(true);
    if (_globalKey.currentState.validate()) {
      _globalKey.currentState.save();
      if (Provider.of<AdminMode>(context, listen: false).isAdmin) {
        if (password == adminPassword) {
          try {
            await _auth.signin(email, password);
            Navigator.pushNamed(context, AdminScreen.id);
          } catch (e) {
            modelHud.changeisLoading(false);
            Scaffold.of(context).showSnackBar(SnackBar(
              content: Text(e.message()),
            ));
          }
        } else {
          modelHud.changeisLoading(false);
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text('Something went wrong'),
            ),
          );
        }
      } else {
        try {
          await _auth.signin(email, password);
          Navigator.pushNamed(context, HomeScreen.id);
        } catch (e) {
          modelHud.changeisLoading(false);
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text(e.message()),
          ));
        }
      }
    }
    modelHud.changeisLoading(false);
  }
}
