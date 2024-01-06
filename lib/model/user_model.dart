class UserModel {
  final String name;
  final String uid;
 
  UserModel({
    required this.name,
    required this.uid,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'uid': uid, 
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] ?? '',
      uid: map['uid'] ?? '',
    );
  }
}
