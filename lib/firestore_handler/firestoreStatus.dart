import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore_platform_interface/cloud_firestore_platform_interface.dart';

enum FirestoreStatus {
  successful,
  aborted,
  canceled,
  notFound,
  unknown,
}

class FirestoreExceptionHandler {
  static handleAuthException(FirebaseException e) {
    FirestoreStatus status;
    switch (e.code) {
      case "OK":
        status = FirestoreStatus.successful;
        break;
      case "ABORTED":
        status = FirestoreStatus.aborted;
        break;
      case "CANCELLED":
        status = FirestoreStatus.canceled;
        break;
      case "NOT_FOUND":
        status = FirestoreStatus.notFound;
        break;
      default:
        status = FirestoreStatus.unknown;
    }
    return status;
  }

  static String generateErrorMessage(error) {
    String errorMessage;
    switch (error) {
      case FirestoreStatus.unknown:
        errorMessage = "Could not find entry in database.";
        break;
      case FirestoreStatus.canceled:
        errorMessage = "The operation was canceled.";
        break;
      case FirestoreStatus.aborted:
        errorMessage = "Aborted operation due to error";
        break;
      case FirestoreStatus.notFound:
        errorMessage = "Data not found.";
        break;
      default:
        errorMessage = "OOPS An error occurred. Please try again later.";
    }
    return errorMessage;
  }
}
