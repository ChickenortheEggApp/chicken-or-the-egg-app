import 'package:cloud_firestore/cloud_firestore.dart';

Future<List<String>> fetchCoopIds() async {
  final snapshot = await FirebaseFirestore.instance.collection('coops').get();
  return snapshot.docs.map((doc) => doc.id).toList();
}
