import 'package:flutter/cupertino.dart';
import '../firebase_auth/firebaseAuthentication.dart';
import '../firestore_handler/firestoreServiceHandler.dart';

class MessageProvider extends ChangeNotifier {
  final _authentication = AuthenticationService();
  final _fireStoreInstance = firestoreServices();
}
