class UserModel {
  final String uid;
  final String? email;
  final String? name;
  final String? gender;
  final String? county;
  final String? age;
  final String? birthday;
  final String? profilePhoto;

  UserModel({
    required this.uid,
    this.email,
    this.name,
    this.gender,
    this.county,
    this.age,
    this.birthday,
    this.profilePhoto,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        uid: json["id"] ?? '',
        email: json["email"],
        name: json["name"],
        gender: json["gender"],
        county: json["county"],
        age: json["age"],
        birthday: json["Birthday"],
        profilePhoto: json["profilePhoto"],
      );

  Map<String, dynamic> toJson() => {
        "id": uid,
        "email": email,
        "name": name,
        "gender": gender,
        "county": county,
        "age": age,
        "Birthday": birthday,
        "profilePhoto": profilePhoto,
      };
}
