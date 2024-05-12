import 'package:cloud_firestore/cloud_firestore.dart';

class DocumentNotFoundException<T> implements Exception {
  final DocumentSnapshot<T> document;

  const DocumentNotFoundException(this.document);
}
