import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:e_commerce/constants.dart';
import 'package:e_commerce/models/product.dart';
import 'package:e_commerce/services/store.dart';
import 'package:e_commerce/wedgits/custom_textfield.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_downloader/image_downloader.dart';

class AddProduct extends StatefulWidget {
  static String id = 'AddProduct';

  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  String _name, _price, _categories, _description;
  File _image;

  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  final _store = Store();
  String _url;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kMainColor,
      body: Form(
        key: _globalKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 50,
              ),
              GestureDetector(
                onTap: () {
                  pickImage();
                },
                child: CircleAvatar(
                  backgroundImage: _image == null ? null : FileImage(_image),
                  radius: 80,
                ),
              ),
              SizedBox(
                height: 10,
              ),
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
              // CustomTextField(
              //   onClick: (value) {
              //     _imgeLogation = value;
              //   },
              //   hint: 'Product Location',
              //   icon: null,
              // ),

              Builder(
                builder: (context) => RaisedButton(
                  color: kButtonColor,
                  textColor: Colors.white,
                  padding: EdgeInsets.all(8),
                  onPressed: () {
                    uploadImage(context);
                    if (_globalKey.currentState.validate()) {
                      _globalKey.currentState.save();

                      _store.addProduct(Product(
                        pName: _name,
                        pCategory: _categories,
                        pDescription: _description,
                        pLocation: _image,
                        pPrice: _price,
                      ));
                    }
                  },
                  child: Text('Add Product'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void pickImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
    });
  }

  void uploadImage(context) async {
    try {
      FirebaseStorage storage =
          FirebaseStorage(storageBucket: 'gs://e-commerce-7b4fb.appspot.com');
      StorageReference ref = storage.ref().child(p.basename(_image.path));
      StorageUploadTask storageUploadTask = ref.putFile(_image);
      StorageTaskSnapshot taskSnapshot = await storageUploadTask.onComplete;
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('success'),
      ));
      String url = await taskSnapshot.ref.getDownloadURL();
      print('url $url');
      setState(() {
        _url = url;
      });
    } catch (ex) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(ex.message),
      ));
    }
  }

  Future<void> loadImage() async {
    var imageId = await ImageDownloader.downloadImage(_url);
    var path = await ImageDownloader.findPath(imageId);
    File image = File(path);
    setState(() {
      _image = image;
    });
  }
}
