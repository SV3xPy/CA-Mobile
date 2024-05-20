class UserModel {
  final String name;
  final String lastName;
  final String uid;
  final String profilePic;
  final String email;
  final String birthDay;
  final bool isPremium;
  final List<String> classIDs;

  UserModel({
    required this.name,
    required this.lastName,
    required this.uid,
    required this.profilePic,
    required this.email,
    required this.birthDay,
    required this.isPremium,
    required this.classIDs,
  });
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'lastName': lastName,
      'uid': uid,
      'profilePic': profilePic,
      'email': email,
      'birthDay': birthDay,
      'isPremium': isPremium,
      'classIDs': classIDs,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] ?? '',
      lastName: map['lastName'] ?? '',
      uid: map['uid'] ?? '',
      profilePic: map['profilePic'] ?? '',
      email: map['email'] ?? '',
      birthDay: map['birthDay'] ?? '',
      isPremium: map['isPremium'] ?? '',
      classIDs: List<String>.from(map['classIDs']),
    );
  }
}
