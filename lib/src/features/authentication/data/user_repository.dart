import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/user_model.dart';

part 'user_repository.g.dart';

@Riverpod(keepAlive: true)
FirebaseFirestore firebaseFirestore(FirebaseFirestoreRef ref) {
  return FirebaseFirestore.instance;
}

@Riverpod(keepAlive: true)
FirebaseStorage firebaseStorage(FirebaseStorageRef ref) {
  return FirebaseStorage.instance;
}

@Riverpod(keepAlive: true)
UserRepository userRepository(UserRepositoryRef ref) {
  return UserRepository(
    ref.watch(firebaseFirestoreProvider),
    ref.watch(firebaseStorageProvider),
  );
}

class UserRepository {
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  UserRepository(this._firestore, this._storage);

  Future<void> storeNewUser({
    required String uid,
    required String email,
    required String name,
    required String phone,
    String gender = 'Secret',
  }) async {
    // In original code, documents were nested under the user's email:
    // userData/{uEmail}/profile/{uEmail}
    // For backwards compatibility, matching that path, though it is usually better to use uid.
    await _firestore
        .collection('userData')
        .doc(email)
        .collection('profile')
        .doc(email)
        .set({
      'name': name,
      'phone': phone,
      'email': email,
      'gender': gender,
      'uid': uid // Added to keep track better
    });
  }

  Future<UserModel?> getProfile(String userEmail) async {
    if (userEmail.isEmpty) return null;
    
    final querySnapshot = await _firestore
        .collection('userData')
        .doc(userEmail)
        .collection('profile')
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      final data = querySnapshot.docs.first.data();
      // Ensure uid is attached to UserModel
      data['uid'] ??= FirebaseAuth.instance.currentUser?.uid ?? '';
      return UserModel.fromJson(data);
    }
    return null;
  }

  Future<void> updateProfile({
    required String email,
    required String name,
    required String gender,
  }) async {
    await _firestore
        .collection('userData')
        .doc(email)
        .collection('profile')
        .doc(email)
        .set({
      'name': name,
      'gender': gender,
    }, SetOptions(merge: true));
  }

  Future<String> updateProfilePhoto(String email, String uid, File file) async {
    final String filePath = 'userImages/$email.png';
    // Using default storage bucket logic
    final storageRef = _storage.ref().child(filePath);
    final uploadTask = await storageRef.putFile(file);
    final profilePhotoUrl = await uploadTask.ref.getDownloadURL();

    // Update in profile
    await _firestore
        .collection('userData')
        .doc(email)
        .collection('profile')
        .doc(email)
        .update({
      'profilePhoto': profilePhotoUrl,
    });

    // Also update in Posts if needed (as per legacy)
    try {
      await _firestore.collection('Posts').doc(uid).update({
        'postbyimage': profilePhotoUrl,
      });
    } catch (e) {
      // Ignored if post doesn't exist
    }

    return profilePhotoUrl;
  }

  Future<void> saveDeviceToken(String email, String? fcmToken) async {
    if (fcmToken != null && email.isNotEmpty) {
      await _firestore.collection('userToken').doc(email).set({
        'userEmail': email,
        'token': fcmToken,
        'createdAt': FieldValue.serverTimestamp(),
        'platform': Platform.operatingSystem,
      });
    }
  }
}
