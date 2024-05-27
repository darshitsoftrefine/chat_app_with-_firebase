import 'models/user_model.dart';
import 'repository/user_repo.dart';

class ChatViewModel {
  // Map<String, dynamic> allUsersList = {};
  List<UserModel> allUsersList = [];

  Future<void> loadAllUserList() async {
    Map<String, dynamic> temp = await UserRepository().fetchAllUserList();
    allUsersList = temp.values.map((e) => UserModel(name: e['name'], uid: e['uid'], phoneNumber: e['phoneNumber'], fcmToken: e['fcmToken']))
        .toList();
        print("Hello $allUsersList");
   
  }
}