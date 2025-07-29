import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/chicken.dart';

class ChickenService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final CollectionReference chickensRef = FirebaseFirestore.instance.collection('chickens');

  // Get all chickens
  Stream<List<Chicken>> getChickens() {
    return chickensRef.snapshots().map((snapshot) => snapshot.docs.map((doc) {
      return Chicken.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
    }).toList());
  }

  // Add a chicken
  Future<void> addChicken(Chicken chicken) {
    return chickensRef.add(chicken.toFirestore());
  }

  // Update a chicken
  Future<void> updateChicken(Chicken chicken) {
    return chickensRef.doc(chicken.id).update(chicken.toFirestore());
  }

  // Delete a chicken
  Future<void> deleteChicken(String chickenId) {
    return chickensRef.doc(chickenId).delete();
  }

  // Update chicken badges based on lineage depth and stats
  Future<void> updateChickenBadges(Chicken chicken, int lineageDepth) async {
    final List<String> newBadges = [];

    if (lineageDepth >= 3) newBadges.add('Legacy Clucker');
    if (chicken.eggsLaid > 100) newBadges.add('Golden Layer');
    if (chicken.sunshineHours > 300) newBadges.add('Sunshine Star');

    await chickensRef.doc(chicken.id).update({
      'badges': newBadges,
    });
  }
}
