import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyAndroidView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: AndroidView(
        viewType: 'com.orangda.post_page.PostPage',
        // creationParams: {'text': 'Flutter传给Android的参数'},
        // creationParamsCodec: StandardMessageCodec(),
      ),
    );
  }
}