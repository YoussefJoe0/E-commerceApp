import 'package:e_commerce/provider/model_hud.dart';
import 'package:e_commerce/screens/user/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants.dart';
import '../wedgits/custom_textfield.dart';
import '../services/auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';

class SignupScreen extends StatelessWidget {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  static String id = 'SignupScreen';
  final auth = Auth();
  String email, password;
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: kMainColor,
      body: ModalProgressHUD(
        inAsyncCall: Provider.of<ModelHud>(context).isLoading,
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
                
                  hint: 'Enter your name', icon: Icons.perm_identity),
              SizedBox(height: height * .02),
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
                    onPressed: () async {
                      final modelHud = Provider.of<ModelHud>(context, listen: false);
                      modelHud.changeisLoading(true);
                      if (_globalKey.currentState.validate()) {
                        _globalKey.currentState.save();
                        try {
                          final authResult =
                              await auth.signUp(email.trim(), password.trim());
                          modelHud.changeisLoading(false);
                          Navigator.pushNamed(context, HomeScreen.id);
                        }on PlatformException catch (e) {
                          modelHud.changeisLoading(false);

                          Scaffold.of(context).showSnackBar(SnackBar(
                            content: Text(e.message),
                          ));
                        }
                      }
                      modelHud.changeisLoading(false);
                    },
                    child: Text(
                      'Sign up',
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
                    "Don have an account ?",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {},
                    child: Text(
                      'Login',
                      style: TextStyle(
                        color: kButtonColor,
                        fontSize: 18,
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
