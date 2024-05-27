import 'package:chat_app/models/user_model.dart';
import 'package:firebase_database/firebase_database.dart';

class UserRepository {

  List<UserModel> userDetails = [];

   Future<Map<String, dynamic>> fetchAllUserList() async {
    DataSnapshot data = await FirebaseDatabase.instance.ref("users/").get();
    Map<String, dynamic> users =  Map<String, dynamic>.from(data.value as Map);
    //print(users);
    return users;
  }
}