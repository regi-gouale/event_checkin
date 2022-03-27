import 'package:cloud_firestore/cloud_firestore.dart';

Future<DocumentSnapshot<Object?>> getFirestoreDocumentData({
  required String collection,
  required String documentID,
}) async {
  final DocumentSnapshot document = await FirebaseFirestore.instance
      .collection(collection)
      .doc(documentID)
      .get();
  return document;
}

