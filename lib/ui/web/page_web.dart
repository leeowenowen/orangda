import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebPageContainer extends StatelessWidget {
  static const String ROUTE = 'web_page';

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> params = ModalRoute.of(context).settings.arguments;
    assert(params != null);
    String title = params['title'];
    String url = params['url'];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: TextStyle(fontSize: 18),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: WebView(
        initialUrl: url,
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
