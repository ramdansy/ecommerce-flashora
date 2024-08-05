import 'package:firebase_auth/firebase_auth.dart';

import '../../data/models/response/user_response.dart';

class UserModel {
  String id;
  String name;
  String username;
  String email;
  String address;
  String phone;
  String imageUrl;
  String docId;

  UserModel(
      {required this.id,
      required this.name,
      required this.username,
      required this.email,
      required this.address,
      required this.phone,
      this.imageUrl = '',
      this.docId = ''});

  factory UserModel.fromMap(Map<String, dynamic> map) => UserModel(
        id: map['id'],
        name: map['name'],
        username: map['username'],
        email: map['email'],
        address: map['address'],
        phone: map['phone'],
        imageUrl: map['imageUrl'] ?? '',
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "username": username,
        "email": email,
        "address": address,
        "phone": phone,
        "imageUrl": imageUrl
      };

  UserModel copyWith({
    String? id,
    String? name,
    String? username,
    String? email,
    String? address,
    String? phone,
    String? imageUrl,
    String? docId,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      username: username ?? this.username,
      email: email ?? this.email,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      imageUrl: imageUrl ?? this.imageUrl,
      docId: docId ?? this.docId,
    );
  }
}

extension UserModelExtension on UserResponse {
  UserModel convertToLocal() => UserModel(
        id: id,
        name: name,
        username: username,
        email: email,
        address: address,
        phone: phone,
        imageUrl: imageUrl,
        docId: docId,
      );
}

extension UserModelFromAuth on User {
  UserModel convertToLocal() => UserModel(
        id: uid,
        name: displayName ?? "",
        username: email?.split('@').first ?? "",
        email: email ?? "",
        address: "",
        phone: phoneNumber ?? "",
        imageUrl: "",
      );
}
