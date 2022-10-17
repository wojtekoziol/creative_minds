import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
class User with _$User {
  const factory User({
    required String id,
    required String name,
    required String photoURL,
    @Default([]) List<String> posts,
  }) = _User;

  const User._();

  factory User.empty() {
    return const User(
      id: '',
      name: '',
      photoURL: '',
    );
  }

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  factory User.fromCredential(auth.UserCredential credential) {
    return User.empty().copyWith(id: credential.user?.uid ?? '');
  }

  factory User.fromDocument(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    if (data == null) return User.empty();
    return User.fromJson(data).copyWith(id: doc.id);
  }

  Map<String, dynamic> toDocument() => toJson()..remove(id);
}
