import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:orangda/common/utils/font_util.dart';
import 'package:orangda/models/post/post.dart';
import 'package:orangda/models/post/post_model.dart';
import 'package:orangda/themes/theme.dart';
import 'package:orangda/ui/upload/upload_page.dart';
import 'package:orangda/ui/widgets/image_post.dart';

class Feed extends StatefulWidget {
  _Feed createState() => _Feed();
}

class _Feed extends State<Feed> {
  List<ImagePost> feedData;

  @override
  void initState() {
    super.initState();
  }

  Future<void> onUpload() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );
    Navigator.of(context).pushNamed(UploadPage.ROUTE, arguments: {
      'FilePickerResult': result
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: MyColors.BACKGROUND,
        appBar: AppBar(
          titleSpacing: 0,
          shadowColor: Colors.white54,
          title: Container(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                Image.asset(
                  'assets/logo.png',
                  width: 40,
                ),
                FontUtil.makeTitle(),
                IconButton(
                  icon: Icon(
                    Icons.add_photo_alternate,
                    color: Colors.white,
                    size: 30,
                  ),
                  onPressed: onUpload,
                )
              ])),
          centerTitle: true,
        ),
        body: _buildFeed());
  }

  Widget _buildFeed() {
    return StreamBuilder<QuerySnapshot>(
      stream: PostModel.getAllPost(),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data.size > 0) {
          return ListView.separated(
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              itemCount: snapshot.data.docs.length,
              separatorBuilder: (context, index) {
                return Container(
                  height: 0,
                  color: Colors.red,
                );
              },
              itemBuilder: (context, index) {
                var doc = snapshot.data.docs[index];
                if (doc == null) {
                  debugPrint('null doc');
                }
                Post post = Post.fromDocument(doc);
                final ImagePost imagePost = ImagePost(post);
                return imagePost;
              });
        }
        return Center(
            child: CircularProgressIndicator(
          backgroundColor: Colors.red,
        ));
      },
    );
  }
}
