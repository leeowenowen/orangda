import 'package:flutter/cupertino.dart';
import 'package:orangda/themes/theme.dart';

class BannerItem extends StatelessWidget {
  String _url;
  String _actionName;
  Map<String, dynamic> _actionParams;
  BannerItem(Map<String, dynamic> params) {
    assert(params != null);

    _actionName = params['action']['name'];
    _actionParams = params['action']['params'];
    _url = params['image']['url'];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppTheme.SPACE),
      child: GestureDetector(
          onTap: () {
            // Stat.logClick(ProductListPage.ROUTE, ElementType.BANNER,
            //     _actionName, _actionParams);
            switch (_actionName) {
              case 'showWebPage':
                String url = _actionParams['url'];
                String title = _actionParams['title'];
                // Navigator.of(context).pushNamed(WebPageContainer.ROUTE,
                //     arguments: {'url': url, 'title': title});
                break;
              case 'showProduct':
                String spuId = _actionParams['spuId'];
                // Navigator.of(context)
                //     .pushNamed(ProductDetailPage.ROUTE, arguments: spuId);
                break;
              default:
                debugPrint('BannerItem.unSupportAction:$_actionName');
                break;
            }
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: FadeInImage.assetNetwork(
              placeholder: 'assets/loading.gif',
              image: _url,
              fit: BoxFit.fitWidth,
            ),
          )),
    );
  }
}
