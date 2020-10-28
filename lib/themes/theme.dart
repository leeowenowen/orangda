import 'package:flutter/material.dart';

class AppTheme {
  const AppTheme();

  static ThemeData theme = ThemeData(
    // Define the default brightness and colors.

    brightness: Brightness.light,
    primaryColor: Colors.white,
    accentColor: Colors.black87,
    colorScheme: ColorScheme.light(primary: Colors.white),

    fontFamily: 'Roboto',

    // Define the default TextTheme. Use this to specify the default
    // text styling for headlines, titles, bodies of text, and more.
    textTheme: TextTheme(
      headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
      headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
      bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
      button: TextStyle(fontSize: 15, color: Colors.white),
    ),

    iconTheme: IconThemeData(color: MyColors.PRIMARY),
    buttonTheme: ButtonThemeData(
        buttonColor: MyColors.PRIMARY,
        disabledColor: Colors.grey,
        textTheme: ButtonTextTheme.primary),
  );

  static TextStyle titleStyle =
      const TextStyle(color: MyColors.TEXT_PRIMARY, fontSize: 16);
  static TextStyle subTitleStyle =
      const TextStyle(color: MyColors.TEXT_SECONDARY, fontSize: 12);

  static TextStyle h1Style =
      const TextStyle(fontSize: 24, fontWeight: FontWeight.bold);
  static TextStyle h2Style = const TextStyle(fontSize: 22);
  static TextStyle h3Style = const TextStyle(fontSize: 20);
  static TextStyle h4Style =
      const TextStyle(fontSize: 18, fontWeight: FontWeight.bold);
  static TextStyle h5Style = const TextStyle(fontSize: 16);
  static TextStyle h6Style = const TextStyle(fontSize: 14);
  static TextStyle h7Style =
      const TextStyle(fontSize: 12, color: MyColors.TEXT_SECONDARY);

  static List<BoxShadow> shadow = <BoxShadow>[
    BoxShadow(color: Color(0xfff8f8f8), blurRadius: 10, spreadRadius: 15),
  ];

  static EdgeInsets padding =
      const EdgeInsets.symmetric(horizontal: 20, vertical: 10);
  static EdgeInsets hPadding = const EdgeInsets.symmetric(
    horizontal: 10,
  );

  static double fullWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double fullHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  //airgo
  static const EdgeInsets PADDING_ALL = EdgeInsets.all(SPACE);
  static const double SPACE_XXXL = 30;
  static const double SPACE_XXL = 25;
  static const double SPACE_XL = 20;
  static const double SPACE_L = 15;
  static const double SPACE = 10;
  static const double SPACE_M = 7;
  static const double SPACE_S = 5;
  static const double SPACE_XS = 3;
  static const double SPACE_XXS = 2;
  static const double SPACE_XXXS = 1;
  static const double BOTTOM_BTN_HEIGHT = 50;
  static const EdgeInsets MARGIN_TOP = EdgeInsets.only(top: SPACE);
  static const EdgeInsets MARGIN_LEFT = EdgeInsets.only(left: SPACE);
  static const EdgeInsets MARGIN_BOTTOM = EdgeInsets.only(bottom: SPACE);

  static const TextStyle TEXT_LARGE =
      TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black);

  //FONT
  static const double FONT_SIZE_LARGE = 16;
  static const double FONT_SIZE_MEDIUM = 14;
  static const double FONT_SIZE_SMALL = 12;
}

class MyColors {
  static const Color BACKGROUND = Color(0xFFFAFAFA);
  // static const Color PRIMARY = Color(0xFFFF4158);
  static const Color PRIMARY = Colors.white;
  static const Color SECONDARY_COLOR = Color(0xff08CFCE);
  static const Color FOREGROUND = Colors.white;
  static const Color TEXT_PRIMARY = Colors.white;
  static const Color TEXT_SECONDARY = Color(0xff999999);
  static const Color TEXT_HINT = Color(0xff878a94);
  static const Color TEXT_DARK = Color(0xff141313);
  static const Color TEXT_GREY = Color(0xff111111);
  static const Color BTN_BG_GREY = Color(0xff1e1e1e);
  static const Color HINT_BACKGROUND = Color(0xffffe7c0);
  static const Color CURRENCY = Color(0xffff4857);
  static const Color PRICE = Color(0xffff4857);
  static const Color TAG_BG = Color(0xfff6f6f6);
  static const Color TAG_BORDER = Color(0xffadadad);
  static const Color TAG_TEXT = Color(0xff717171);
  static const Color BLOCK_HINT = Color(0xfff5f4f8);
}
