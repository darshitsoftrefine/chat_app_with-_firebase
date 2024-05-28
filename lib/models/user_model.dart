class UserModel {
  final String name;
  final String uid;
  final String phoneNumber;
  String? fcmToken;

  UserModel({required this.name, required this.uid, this.fcmToken, required this.phoneNumber,});

  factory UserModel.fromRTDB(Map<String, dynamic> users) {
    return UserModel(
      name: users['name'],
       uid: users['uid'],
       phoneNumber: users['phoneNumber'],
       fcmToken: users['fcmToken'] ?? "",
       );
  }
}
