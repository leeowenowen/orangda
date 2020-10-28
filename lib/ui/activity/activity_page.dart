import 'package:flutter/material.dart';
import 'package:orangda/common/utils/RandomColorUtil.dart';
import 'package:orangda/ui/activity/smile_wall/smile_wall_page.dart';
import 'package:orangda/ui/home/home_page.dart';
import 'package:orangda/ui/widgets/color_text_banner.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class ActivityPage extends StatefulWidget {
  @override
  _ActivityPageState createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  final RandomColorUtil _randomColorUtil = RandomColorUtil();
  final activities = [
    {'title': 'Take Smail Photo with People all over the world', 'desc': '1'},
    {'title': 'I want to see China Great Wall', 'desc': ''},
    {'title': 'Take Smail Photo with People all over the world', 'desc': '1'},
    {'title': 'I want to see China Great Wall', 'desc': '1'}
  ];
  Map<String, dynamic> redirectPageInfo = {};

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: <Widget>[
          SliverToBoxAdapter(child: _swiper()),
          // SliverToBoxAdapter(child: SmileWallPage()),
        ],
      ),
    );
  }

  Widget _swiper() {
    return Container(
      height: 130,
      child: Swiper(
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: (){
              Navigator.pushNamedAndRemoveUntil(context, HomePage.ROUTE, (route) => false, arguments:{
                'collection':'smile_wall'
              });
            },
              child:ColorTextBanner(
            activities[index]['title'],
            desc: activities[index]['desc'],
            bgColor: _randomColorUtil.getRandomColor(index),
          ));
        },
        itemCount: activities.length,
        viewportFraction: 1,
        scale: 1,
        autoplay: true,
        duration: 1000,
        autoplayDelay: 5000,
        autoplayDisableOnInteraction: true,
      ),
    );
  }
}
