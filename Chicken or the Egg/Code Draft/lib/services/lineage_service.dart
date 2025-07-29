import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/lineage.dart';

class LineageService {
  Future<Lineage?> getLineageForChicken(String lineageId) async {
    DocumentSnapshot doc = await FirebaseFirestore.instance.collection('lineage').doc(lineageId).get();
    if (doc.exists) {
      return Lineage.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
    }
    return null;
  }
}
