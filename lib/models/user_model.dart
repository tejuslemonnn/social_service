import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String uid;
  final String? name;
  final String? email;
  final String? password;
  final String? photo;
  final String? role;
  final int? wallet;

  const User({
    required this.uid,
    this.name,
    this.email,
    this.password,
    this.photo,
    this.role,
    this.wallet,
  });

  static const empty = User(uid: '');

  bool get isEmpty => this == User.empty;

  bool get isNotEmpty => this != User.empty;

  @override
  List<Object?> get props => [
        uid,
        name,
        email,
        password,
        photo,
        wallet,
      ];

  Map<String, Object?> toJson() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'password': password,
      'photo': photo,
      'role': role,
      'wallet': wallet,
    };
  }

  static User fromJson(Map<String, dynamic> json) {
    return User(
      uid: json['uid'] as String,
      name: json['name'] as String?,
      email: json['email'] as String?,
      password: json['password'] as String?,
      photo: json['photo'] as String?,
      role: json['role'] as String?,
      wallet: json['wallet'] as int?,
    );
  }

  static User fromSnapshot(DocumentSnapshot snapshot) {
    return User(
      uid: snapshot['uid'],
      name: snapshot['name'],
      email: snapshot['email'],
      photo: snapshot['photo'],
      role: snapshot['role'],
      wallet: snapshot['wallet'],
    );
  }
}
