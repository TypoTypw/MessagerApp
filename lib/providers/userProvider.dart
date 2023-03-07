import 'package:flutter/foundation.dart';
import '/model/profileModel.dart';
import '../firebase_auth/firebaseAuthentication.dart';
import '../firestore_handler/firestoreServiceHandler.dart';

class UserProvider extends ChangeNotifier {
  final _authentication = AuthenticationService();
  final _fireStoreInstance = firestoreServices();
  late Person _user;
  Set<Person> _friendsList = {};

  void fetchUser() async {
    await _fireStoreInstance.retrieveUserProfile().then((value) {
      _user = value;
    });
    await _fireStoreInstance
        .retrieveUserFriendsList()
        .then((value) => _friendsList = value);
    notifyListeners();
  }

  void logout() {
    _user = _user.reset();
    _friendsList = {};
    _fireStoreInstance.logoutProfile();
    _authentication.logout();
  }

  Person get user => _user;
  Set<Person> get friendsList => _friendsList;

  get fireStoreInstance => _fireStoreInstance;

  get authentication => _authentication;
}
