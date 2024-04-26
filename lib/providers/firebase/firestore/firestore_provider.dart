import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:podcast/providers/firebase/firebase_app_provider.dart';
import 'package:podcast/providers/firebase/user_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'firestore_provider.g.dart';

@riverpod
class Firestore extends _$Firestore {
  late DocumentReference _userDocument;

  @override
  Future<void> build() async {
    final user = await ref.watch(userPodProvider.future);
    if (user == null) throw Exception('User not available');

    final store = FirebaseFirestore.instanceFor(
      app: await ref.watch(firebaseAppProvider.future),
      databaseId: 'podcast',
    )..settings = const Settings(
        persistenceEnabled: true,
      );

    _userDocument = store.collection('users').doc(user.uid);
  }

  CollectionReference<Map<String, dynamic>> userCollection(
    String collectionPath,
  ) {
    return _userDocument.collection(collectionPath);
  }
}
