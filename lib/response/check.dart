import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagramclone/models/user.dart';

class FirebaseHelper {
  static Future<User> getUserModelById(String uid) async {
    User userModel;

    DocumentSnapshot docSnap =
        await FirebaseFirestore.instance.collection("users").doc(uid).get();

    if (docSnap.data() != null) {
      userModel = User.fromSnap(docSnap);
    }

    return userModel;
  }
}
