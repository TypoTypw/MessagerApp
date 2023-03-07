import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import '../firebase_auth/firebaseAuthentication.dart';
import '../firestore_handler/firestoreServiceHandler.dart';

class MessageProvider extends ChangeNotifier {
  final _authentication = AuthenticationService();
  final _fireStoreInstance = firestoreServices();

  Map<Timestamp, List<String>> _messages = HashMap();

  void getMessages(String id) async {
    await _fireStoreInstance
        .getUserMessages(id)
        .then((value) => _messages = value);
    notifyListeners();
  }

  Map<Timestamp, List<String>> get messages => _messages;
}
