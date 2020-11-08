import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:orangda/common/utils/font_util.dart';
import 'package:orangda/localization/my_l10n.dart';
import 'package:orangda/service/account_service.dart';

class LoginPage extends StatefulWidget {
  static final String ROUTE = 'login page';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  Future<void> fbLogin() async {
    await AccountService.signInWithFacebook();
    Navigator.of(context).pop();
  }

  Future<void> ggLogin() async {
    await AccountService.signInWithGoogle();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    String photoTheWorld =
        MyLocalizations.of(context).get('common.photo_the_world');
    return Scaffold(
      body: Container(
        color: Colors.black,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 100.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(children: [
                  Container(
                    alignment: Alignment.center,
                    child: Image.asset('assets/logo.png', height: 250),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                        margin: EdgeInsets.only(top: 220),
                        child: FontUtil.makeBrand()),
                  )
                ]),
                SizedBox(
                  height: 10,
                ),
                Text(photoTheWorld,
                    style: const TextStyle(
                        // fontFamily: "Fontdiner Swanky",
                        color: Colors.grey,
                        fontSize: 15)),
                Padding(padding: const EdgeInsets.only(bottom: 100.0)),
                InkWell(
                    onTap: () {
                      ggLogin();
                    },
                    child: Container(
                      margin: EdgeInsets.only(left: 50, right: 50),
                      padding: EdgeInsets.only(top:10, bottom: 10, left: 20, right: 30),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          // color:Colors.red,
                          border: Border.all(width:1, color: Colors.red),
                      ),
                      child: Row(children: [
                        Icon(
                          FontAwesomeIcons.google,
                          color: Colors.white,
                        ),
                        SizedBox(width: 10,),
                        Expanded(
                            child: Text(
                          "Google",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                        )),
                      ]),
                    )),
                SizedBox(
                  height: 20,
                ),
                InkWell(
                    onTap: () {
                      fbLogin();
                    },
                    child: Container(
                      margin: EdgeInsets.only(left: 50, right: 50),
                      padding: EdgeInsets.only(top:10, bottom: 10, left: 20, right: 30),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          // color:Colors.indigo,
                          border: Border.all(width:1, color: Colors.indigo)),
                      child: Row(children: [
                        Icon(
                          FontAwesomeIcons.facebookF,
                          color: Colors.white,
                        ),
                        Expanded(
                            child: Text(
                              "Facebook",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            )),
                      ]),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
