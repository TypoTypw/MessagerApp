import 'package:flutter/foundation.dart';
import '/model/profileModel.dart';
import '../firebase_auth/firebaseAuthentication.dart';
import '../firestore_handler/firestoreServiceHandler.dart';

class UserProvider extends ChangeNotifier {
  final _authentication = AuthenticationService();
  final _fireStoreInstance = firestoreServices();
  late Person _user;
  List<Person>? _friendsList;

  void fetchUser() async {
    await _fireStoreInstance.retrieveUserProfile().then((value) {
      _user = value;
    });
    notifyListeners();
  }

  void logout() {
    // _user = null;
    _friendsList = [];
    _fireStoreInstance.logoutProfile();
    _authentication.logout();
  }

  Person get user => _user;
  List<Person>? get friendsList => _friendsList;

  get fireStoreInstance => _fireStoreInstance;

  get authentication => _authentication;
}
