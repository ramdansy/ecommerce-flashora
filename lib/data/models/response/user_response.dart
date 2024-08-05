import 'dart:convert';

UserResponse userResponseFromMap(String str) =>
    UserResponse.fromMap(json.decode(str));

String userResponseToMap(UserResponse data) => json.encode(data.toMap());

class UserResponse {
  String id;
  String email;
  String username;
  String password;
  String name;
  String phone;
  String address;
  String imageUrl;
  String docId;

  UserResponse({
    required this.address,
    required this.id,
    required this.email,
    required this.username,
    required this.password,
    required this.name,
    required this.phone,
    this.imageUrl = '',
    this.docId = '',
  });

  factory UserResponse.fromMap(Map<String, dynamic> json) => UserResponse(
        address: json["address"],
        id: json["id"],
        email: json["email"],
        username: json["username"],
        password: json["password"] ?? "",
        name: json["name"],
        phone: json["phone"],
        imageUrl: json["imageUrl"] ?? '',
      );

  Map<String, dynamic> toMap() => {
        "address": address,
        "id": id,
        "email": email,
        "username": username,
        "password": password,
        "name": name,
        "phone": phone,
        "imageUrl": imageUrl
      };

  UserResponse copyWith({
    String? id,
    String? email,
    String? username,
    String? password,
    String? name,
    String? phone,
    String? address,
    String? imageUrl,
    String? docId,
  }) {
    return UserResponse(
      id: id ?? this.id,
      email: email ?? this.email,
      username: username ?? this.username,
      password: password ?? this.password,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      imageUrl: imageUrl ?? this.imageUrl,
      docId: docId ?? this.docId,
    );
  }
}
