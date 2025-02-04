import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Updates the FCM token for a specific user by email
  Future<void> updateFcmToken(String userEmail, String fcmToken) async {
    try {
      DocumentReference docRef = _firestore.collection("users").doc(userEmail);
      DocumentSnapshot docSnap = await docRef.get();

      if (docSnap.exists) {
        // Document exists, update the FCM token
        await docRef.update({"fcmToken": fcmToken});
        print("FCM Token updated for $userEmail");
      } else {
        // Document does not exist, create a new one
        await docRef.set({"fcmToken": fcmToken});
        print("New user created and FCM Token saved for $userEmail");
      }
    } catch (e) {
      print("Error updating FCM Token: $e");
    }
  }

  /// Reads the FCM token for a specific user by email
  Future<String?> getFcmToken(String userEmail) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection("users").doc(userEmail).get();

      if (doc.exists && doc.data() != null) {
        return (doc.data() as Map<String, dynamic>)["fcmToken"];
      } else {
        print("No FCM Token found for $userEmail");
        return null;
      }
    } catch (e) {
      print("Error fetching FCM Token: $e");
      return null;
    }
  }
}
