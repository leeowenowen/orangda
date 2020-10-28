import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:orangda/themes/theme.dart';

class ColorTextBanner extends StatelessWidget{
  final Color bgColor;
  final Color titleColor;
  final Color descColor;
  final String title;
  final String desc;
  ColorTextBanner(this.title, {this.desc, this.bgColor, this.titleColor=Colors.white, this.descColor=Colors.white});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      padding: EdgeInsets.only(left: AppTheme.SPACE_S, right: AppTheme.SPACE_S),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppTheme.SPACE_S),
        color: bgColor,

      ),
      child:Container(
        child: Column(
          children:[
            Text(title, style:TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color:titleColor )),
            SizedBox(height: AppTheme.SPACE,),
            Text(title, style:TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color:descColor )),
          ]
        )
      )
    );
  }


}