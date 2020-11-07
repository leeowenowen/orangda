import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:orangda/common/constants/constants.dart';

import '../user.dart';

class UserModel {

  static final userCollection = FirebaseFirestore.instance.collection(Constants.COLLECTION_USER);

  static Future<DocumentSnapshot> getUserById(String userId) {
    return FirebaseFirestore.instance
        .collection(Constants.COLLECTION_USER)
        .doc(userId)
        .get();
  }

  static createUser(User user) async{
    DocumentSnapshot userRecord = await userCollection.document(user.id).get();

  }
}