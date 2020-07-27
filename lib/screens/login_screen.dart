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
import 'package:shared_preferences/shared_preferences.dart';
import '../constants.dart';

import 'admin/admin_screen.dart';

class LoginScreen extends StatefulWidget {
  static String id = 'LoginScreen';
   final GlobalKey<FormState> globalKey  = GlobalKey<FormState>();

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
 

  String email, password;

  final _auth = Auth();

  bool isAdmin = false;

  bool keepMeLogin = false;

  final adminPassword = '000000';

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return   Scaffold(
      backgroundColor: kMainColor,
      body: ModalProgressHUD(
        inAsyncCall: Provider.of<ModelHud>(context).isLoading,
        child: Form(
          key: widget.globalKey ,
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
              SizedBox(height: height * .05),
              CustomTextField(
                  onClick: (value) {
                    password = value;
                  },
                  hint: 'Enter your password',
                  icon: Icons.lock),
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Row(
                  children: [
                    Theme(
                      data: ThemeData(unselectedWidgetColor: Colors.white),
                      child: Checkbox(
                        value: keepMeLogin,
                        onChanged: (val) {
                          setState(() {
                            keepMeLogin = val;
                          });
                        },
                      ),
                    ),
                    Text(
                      'Remmeber Me',
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 100),
                child: Builder(
                  builder: (context) => FlatButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    color: kButtonColor,
                    onPressed: () {
                      if (keepMeLogin == true) {
                        keepUserLogedIn();
                      }
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
                        Provider.of<AdminMode>(context, listen: false)
                            .changeIsAdmin(true);
                      },
                      child: Text(
                        "I'm an admin",
                        style: TextStyle(
                          color: Provider.of<AdminMode>(context).isAdmin
                              ? kMainColor
                              : Colors.white,
                        ),
                      ),
                    )),
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          await Provider.of<AdminMode>(context, listen: false)
                              .changeIsAdmin(false);
                        },
                        child: Text(
                          "I'm a user",
                          style: TextStyle(
                            color: Provider.of<AdminMode>(context).isAdmin
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
    final modelhud = Provider.of<ModelHud>(context, listen: false);
    modelhud.changeisLoading(true);
    if (widget.globalKey.currentState.validate()) {
      widget.globalKey.currentState.save();
      if (Provider.of<AdminMode>(context, listen: false).isAdmin) {
        if (password == adminPassword) {
          try {
            await _auth.signin(email.trim(), password.trim());
            Navigator.pushNamed(context, AdminScreen.id);
          } catch (e) {
            modelhud.changeisLoading(false);
            Scaffold.of(context).showSnackBar(SnackBar(
              content: Text(e.message),
            ));
          }
        } else {
          modelhud.changeisLoading(false);
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text('Something went wrong !'),
          ));
        }
      } else {
        try {
          await _auth.signin(email.trim(), password.trim());
          Navigator.pushNamed(context, HomeScreen.id);
        } catch (e) {
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text(e.message),
          ));
        }
      }
    }
    modelhud.changeisLoading(false);
  }
  void keepUserLogedIn() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool(kKeepMeLogedIn, keepMeLogin);
  }
}
