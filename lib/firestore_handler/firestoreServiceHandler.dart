import 'dart:collection';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../model/messagesModel.dart';
import 'firestoreStatus.dart';
import '../firebase_auth/firebaseAuthentication.dart';
import '/model/profileModel.dart';

class firestoreServices {
  final _firestore = FirebaseFirestore.instance;
  final _authentication = AuthenticationService();
  late FirestoreStatus _status;
  Set<String> _friendsUIDs = {};

  Future<FirestoreStatus> createProfile({
    required String name,
    required String surname,
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
      _authentication.currentUser.updateDisplayName(name);
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

  Future<Person> retrieveUserProfileByID(String id) async {
    final snapshot = await _firestore.collection('profiles').doc(id).get();
    return Person(
        id: id,
        name: snapshot.data()!['name'],
        surname: snapshot.data()!['surname'],
        online: snapshot.data()!['online'],
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

  Future<void> _retrieveUserFriendsUIDs() async {
    FirebaseAuth.instance.userChanges().listen((loggedInUser) {
      if (loggedInUser != null) {
        var documentID = _firestore.collection('profiles').get();
        documentID.then((value) => value.docs.forEach((element) {
              _friendsUIDs.add(element.id);
            }));
        print(_friendsUIDs);
        // _friendsUIDs = [];
        // snapshot.docs.forEach((element)
        //   _friendsUIDs.add(element.id);

      } else {
        _friendsUIDs = {};
      }
    });
  }

  Future<Set<Person>> retrieveUserFriendsList() async {
    await _retrieveUserFriendsUIDs();
    Set<Person> friendsList = {};

    for (var id in _friendsUIDs) {
      if (id != _authentication.currentUser.uid) {
        await retrieveUserProfileByID(id)
            .then((value) => friendsList.add(value));
      }
    }

    return friendsList;
  }

  Future<Map<Timestamp, List<String>>> getUserMessages(String id) async {
    Map<Timestamp, List<String>> messages = HashMap();
    final snapshot = await _firestore
        .collection('messages')
        .doc(_authentication.currentUser.uid)
        .collection(id)
        .get();

    for (var postDoc in snapshot.docs) {
      messages.addAll({
        postDoc.get('date'): [postDoc.get('text'), postDoc.get('sender')]
      });
    }

    var sortedMessages = Map.fromEntries(
        messages.entries.toList()..sort((e1, e2) => e1.key.compareTo(e2.key)));
    return sortedMessages;
  }

  void sendMessages(String id, String message) async {
    DateTime now = DateTime.now();
    await _firestore
        .collection('messages')
        .doc(_authentication.currentUser.uid)
        .collection(id)
        .doc()
        .set({
      'text': message,
      'date': now,
      'sender': _authentication.currentUser.uid
    });
    await _firestore
        .collection('messages')
        .doc(id)
        .collection(_authentication.currentUser.uid)
        .doc()
        .set({
      'text': message,
      'date': now,
      'sender': _authentication.currentUser.uid
    });
  }
}
