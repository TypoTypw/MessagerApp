import 'package:firebase_auth/firebase_auth.dart';
import 'authenticationStatus.dart';

class AuthenticationService {
  final _authentication = FirebaseAuth.instance;
  late AuthStatus _status;

  Future<AuthStatus> createAccount({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential newUser =
          await _authentication.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      _status = AuthStatus.successful;
    } on FirebaseAuthException catch (exception) {
      _status = AuthExceptionHandler.handleAuthException(exception);
    }
    return _status;
  }

  Future<AuthStatus> login({
    required String email,
    required String password,
  }) async {
    try {
      await _authentication.signInWithEmailAndPassword(
          email: email, password: password);
      _status = AuthStatus.successful;
    } on FirebaseAuthException catch (exception) {
      _status = AuthExceptionHandler.handleAuthException(exception);
    }
    return _status;
  }

  Future<AuthStatus> resetPassword({required String email}) async {
    await _authentication
        .sendPasswordResetEmail(email: email)
        .then((value) => _status = AuthStatus.successful)
        .catchError((exception) =>
            _status = AuthExceptionHandler.handleAuthException(exception));
    return _status;
  }

  Future<AuthStatus> updateDisplayName({required String name}) async {
    try {
      await _authentication.currentUser!.updateDisplayName(name);

      _status = AuthStatus.successful;
    } on FirebaseAuthException catch (exception) {
      _status = AuthExceptionHandler.handleAuthException(exception);
    }
    return _status;
  }

  Future<void> logout() async {
    await _authentication.signOut();
  }

  User get currentUser => _authentication.currentUser!;

  get authentication => _authentication;
}
