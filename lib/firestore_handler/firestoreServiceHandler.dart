import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'firestoreStatus.dart';
import '../firebase_auth/firebaseAuthentication.dart';
import '/model/profileModel.dart';

class firestoreServices {
  final _firestore = FirebaseFirestore.instance;
  final _authentication = AuthenticationService();
  late FirestoreStatus _status;

  Future<FirestoreStatus> createProfile({
    required String name,
    required String surname,
    required String phone,
    required String img,
  }) async {
    try {
      _firestore
          .collection('profiles')
          .doc(_authentication.currentUser.uid)
          .set(
        {
          'name': name,
          'surname': surname,
          'online': true,
          'img': img,
        },
      );
      _status = FirestoreStatus.successful;
    } on FirebaseException catch (exception) {
      _status = FirestoreExceptionHandler.handleAuthException(exception);
    }
    return _status;
  }

  Future<void> logoutProfile() async {
    _firestore
        .collection('profiles')
        .doc(_authentication.currentUser.uid)
        .update(
      {
        'online': false,
      },
    );
  }

  Future<void> signInProfile() async {
    _firestore
        .collection('profiles')
        .doc(_authentication.currentUser.uid)
        .update(
      {
        'online': true,
      },
    );
  }

  Future<Person> retrieveUserProfile() async {
    final snapshot = await _firestore
        .collection('profiles')
        .doc(_authentication.currentUser.uid)
        .get();
    return Person(
        id: _authentication.currentUser.uid,
        name: snapshot.data()!['name'],
        surname: snapshot.data()!['surname'],
        online: true,
        imgURL: snapshot.data()!['img']);
  }

  Future<Person> retrieveOtherProfile(String id) async {
    final snapshot = await _firestore.collection('profiles').doc(id).get();
    return Person(
        id: id,
        name: snapshot.data()!['name'],
        surname: snapshot.data()!['surname'],
        online: snapshot.data()!['online'],
        imgURL: snapshot.data()!['img']);
  }

  Future<String> uploadProfilePicture(File selectedFile) async {
    UploadTask uploadTask;
    final firebaseStoragePath =
        'profile_IMG/${selectedFile.uri.pathSegments.last}';

    final reference = FirebaseStorage.instance.ref().child(firebaseStoragePath);
    uploadTask = reference.putFile(selectedFile);
    final snapshot = await uploadTask.whenComplete(() {});
    return await snapshot.ref.getDownloadURL();
  }
}
