
import 'package:flutter/material.dart';

class FontUtil {
  static RichText makeTitle(){
    return RichText(
        text: TextSpan(
            children: <TextSpan>[
              TextSpan(
                  text: 'Orang',
                  style: const TextStyle(
                      fontFamily: "Fontdiner Swanky", color: Colors.deepOrange, fontSize:35)),
              TextSpan(
                  text: 'da',
                  style: const TextStyle(
                      fontFamily: "Fontdiner Swanky", color: Colors.black, fontSize: 20)),
            ]));
  }

  static RichText makeBrand(){
    return RichText(
        text: TextSpan(
            children: <TextSpan>[
              TextSpan(
                  text: 'Orang',
                  style: const TextStyle(
                      fontFamily: "Fontdiner Swanky", color: Colors.deepOrange, fontSize:60)),
              TextSpan(
                  text: 'da',
                  style: const TextStyle(
                      fontFamily: "Fontdiner Swanky", color: Colors.black, fontSize: 35)),
            ]));
  }

  static RichText makeTitleByString(String title){
    return RichText(
        text: TextSpan(
            children: <TextSpan>[
              TextSpan(
                  text: title,
                  style: const TextStyle(
                      fontFamily: "Fontdiner Swanky", color: Colors.deepOrange, fontSize:25)),
            ]));
  }
}