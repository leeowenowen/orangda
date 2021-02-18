import 'dart:async';
import 'dart:core';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoder/geocoder.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:orangda/common/constants/constants.dart';
import 'package:orangda/service/account_service.dart';
import 'package:orangda/themes/theme.dart';
import 'package:random_color/random_color.dart';
import 'package:uuid/uuid.dart';

import '../../common/utils/location_util.dart';
import '../../models/user.dart';

class UploadPage extends StatefulWidget {
  static final String ROUTE = 'UploadPage';

  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  static const int MAX_IMG_SIZE = 6;
  List<Asset> assets;
  RandomColor _randomColor = RandomColor();

  //Strings required to save address
  Address address;

  Map<String, double> currentLocation = Map();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController locationController = TextEditingController();

  bool uploading = false;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  initState() {
    super.initState();
    currentLocation['latitude'] = 0.0;
    currentLocation['longitude'] = 0.0;
    initPlatformState(); //method to call location
  }

  //method to get Location and save into variables
  initPlatformState() async {
    Address first = await getUserLocation();
    if (!mounted) {
      return;
    }
    setState(() {
      address = first;
    });
  }

  Widget buildUploadingWidget() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          LoadingRotating.square(
            size: 100,
            itemBuilder: (BuildContext context, int index) {
              return Image.asset('assets/logo.png');
            },
          ),
          SizedBox(
            height: 10,
          ),
          Text('Uploading...',
              style: TextStyle(fontSize: 12, color: MyColors.FOREGROUND)),
        ]);
    // LoadingBouncingGrid.circle(
    //   size: 200,
    //   backgroundColor: Colors.white,
    //   itemBuilder: (BuildContext context, int index){
    //     return Image.asset('assets/logo.png');
    //   },
    // );
  }

  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          backgroundColor: MyColors.BACKGROUND,
          shadowColor: MyColors.FOREGROUND,
          leading: IconButton(
              icon: Icon(Icons.arrow_back, color: MyColors.FOREGROUND),
              onPressed: clearImage),
          title: const Text(
            'Post to',
            style: const TextStyle(color: MyColors.FOREGROUND),
          ),
          actions: <Widget>[
            IconButton(
                padding: EdgeInsets.only(left: 20, right: 20),
                icon: Icon(Icons.send, color: MyColors.FOREGROUND),
                onPressed: postImage)
          ],
        ),
        body: Stack(children: [
          Container(
              padding: EdgeInsets.only(left: 10, right: 10, top: 10),
              color: MyColors.BACKGROUND,
              child: Column(
                children: [
                  buildPostForm(context),
                  SizedBox(
                    height: 10,
                  ),
                  (address == null)
                      ? Container()
                      : SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.only(right: 5.0, left: 5.0),
                          child: Row(
                            children: <Widget>[
                              buildLocationButton(address.featureName),
                              buildLocationButton(address.subLocality),
                              buildLocationButton(address.locality),
                              buildLocationButton(address.subAdminArea),
                              buildLocationButton(address.adminArea),
                              buildLocationButton(address.countryName),
                            ],
                          ),
                        ),
                  (address == null)
                      ? Container()
                      : SizedBox(
                          height: 10,
                        ),
                ],
              )),
          uploading
              ? Center(
                  child: Container(
                      color: Color.fromARGB(128, 0, 0, 0),
                      child: buildUploadingWidget()))
              : Container()
        ]));
  }

  //method to build buttons with location.
  buildLocationButton(String locationName) {
    if (locationName != null ?? locationName.isNotEmpty) {
      return InkWell(
        onTap: () {
          locationController.text = locationName;
        },
        child: Center(
          child: Container(
            //width: 100.0,
            height: 30.0,
            padding: EdgeInsets.only(left: 8.0, right: 8.0),
            margin: EdgeInsets.only(right: 3.0, left: 3.0),
            decoration: BoxDecoration(
              color: _randomColor.randomColor(
                  colorHue: ColorHue.multiple(colorHues: [
                ColorHue.yellow,
                ColorHue.orange,
                ColorHue.red,
                ColorHue.pink,
                ColorHue.green
              ])),
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: Center(
                child: Text(locationName,
                    style: TextStyle(color: _randomColor.randomColor()))),
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  void clearImage() {
    setState(() {
      assets = null;
    });
  }

  int itemCount() {
    if (assets == null) {
      return 1;
    }
    if (assets.length == MAX_IMG_SIZE) {
      return assets.length;
    }
    return assets.length + 1;
  }

  Widget buildImageGrid() {
    return GridView.builder(
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, //每行三列
            crossAxisSpacing: 5,
            mainAxisSpacing: 5,
            childAspectRatio: 1.0 //显示区域宽高相等
            ),
        itemCount: itemCount(),
        itemBuilder: (context, index) {
          bool isLast = false;
          if (assets == null) {
            //only one item
            isLast = true;
          } else {
            isLast = (index == assets.length);
          }
          if (isLast) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: Colors.white54, width: 2),
              ),
              child: IconButton(
                  onPressed: () {
                    selectAssets();
                  },
                  icon: Icon(Icons.add)),
            );
          } else {
            return Container(
                child: Container(
                    child: Stack(children: [
              ClipRRect(
                  borderRadius: BorderRadius.circular(5.0),
                  child: AssetThumb(
                    asset: assets[index],
                    width: 200,
                    height: 200,
                  )),
              Positioned(
                top: 0,
                right: 0,
                child: InkWell(
                    child: Image.asset(
                      'assets/close.png',
                      width: 20,
                    ),
                    onTap: () {
                      setState(() {
                        assets.removeAt(index);
                      });
                    }),
              ),
            ])));
          }
        });
  }

  Future<List<Asset>> selectAssets() async {
    try {
      List<Asset> selectedAssets = await MultiImagePicker.pickImages(
          enableCamera: true,
          maxImages: MAX_IMG_SIZE,
          selectedAssets: (assets == null) ? [] : assets,
          materialOptions: MaterialOptions(
            useDetailsView: true,
            actionBarColor: "#000000",
            actionBarTitleColor: "#ffffff",
          ));
      setState(() {
        assets = selectedAssets;
      });
    } on Exception catch (e) {
      debugPrint(e.toString());
    }
    return List<Asset>();
  }

  Widget buildPostForm(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(padding: EdgeInsets.only(top: 0.0)),
        Container(
            margin: EdgeInsets.only(top: 10, bottom: 10),
            child: buildImageGrid()),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            CircleAvatar(
              radius: 20,
              backgroundImage:
                  NetworkImage(AccountService.currentUser().photoUrl),
            ),
            SizedBox(
              width: 10,
            ),
            Flexible(
                child: Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: Colors.white38),
              ),
              child: TextField(
                style: TextStyle(
                  color: Colors.white70,
                ),
                textAlign: TextAlign.left,
                maxLines: 3,
                controller: descriptionController,
                decoration: InputDecoration(
                    hintStyle: TextStyle(color: Colors.white54),
                    hintText: "Write a caption...",
                    border: InputBorder.none),
              ),
            )),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(width: 40, child: Icon(Icons.pin_drop)),
            SizedBox(
              width: 10,
            ),
            Flexible(
                child: Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: Colors.white38),
              ),
              child: TextField(
                style: TextStyle(
                  color: Colors.white70,
                ),
                textAlign: TextAlign.left,
                controller: locationController,
                decoration: InputDecoration(
                    hintStyle: TextStyle(color: Colors.white54),
                    hintText: "Where was this photo taken?",
                    border: InputBorder.none),
              ),
            )),
          ],
        ),
      ],
    );
  }

  Future<String> saveImage(Asset asset) async {
    var uuid = Uuid().v1();
    ByteData byteData =
        await asset.getByteData(); // requestOriginal is being deprecated
    List<int> imageData = byteData.buffer.asUint8List();
    StorageReference ref = FirebaseStorage().ref().child(
        "post_imgs/$uuid.jpg"); // To be aligned with the latest firebase API(4.0)
    StorageUploadTask uploadTask = ref.putData(imageData);

    String url = await (await uploadTask.onComplete).ref.getDownloadURL();
    return url;
  }

  Future<List<String>> uploadAllImages() async {
    List<String> imgUrls = List();
    for (var i = 0; i < assets.length; i++) {
      Asset asset = assets[i];
      String url = await saveImage(asset);
      imgUrls.add(url);
    }
    return imgUrls;
  }

  Future<void> postImage() async {
    setState(() {
      uploading = true;
    });
    uploadAllImages().then((List<String> imgUrls) {
      dynamic args = ModalRoute.of(context).settings.arguments;
      String collection = Constants.COLLECTION_POST;
      if (args != null && args['collection'] != null) {
        collection = args['collection'];
      }
      postToFireStore(
        context,
        imgUrls: imgUrls,
        description: descriptionController.text,
        location: locationController.text,
        collection: collection,
      );
    }).then((_) {
      Fluttertoast.showToast(msg: 'Post send success!');
      Navigator.of(context).pop();
      setState(() {
        uploading = false;
      });
    });
  }
}

Future<String> uploadImage(var imageFile) async {
  var uuid = Uuid().v1();
  StorageReference ref = FirebaseStorage.instance.ref().child("post_$uuid.jpg");
  StorageUploadTask uploadTask = ref.putFile(imageFile);

  String downloadUrl = await (await uploadTask.onComplete).ref.getDownloadURL();
  return downloadUrl;
}

void postToFireStore(BuildContext context,
    {List<String> imgUrls,
    String location,
    String description,
    String collection}) async {
  var reference = FirebaseFirestore.instance.collection(collection);
  User currentUserModel = AccountService.currentUser();
  reference.add({
    "username": currentUserModel.username,
    "location": location,
    "likes": {},
    "images": imgUrls,
    "description": description,
    "ownerId": currentUserModel.id,
    "timestamp": DateTime.now(),
  }).then((DocumentReference doc) async {
    String docId = doc.id;
    await reference.doc(docId).update({"postId": docId});
  });
}
