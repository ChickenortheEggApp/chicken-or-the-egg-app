import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/chicken.dart';
import '../models/lineage.dart';

Future<Map<String, dynamic>> computeCoopTraits(String coopId) async {
  final chickens = await getChickensByCoop(coopId);

  int totalEggs = chickens.fold(0, (sum, c) => sum + c.eggsLaid);
  double totalSunshine = chickens.fold(0.0, (sum, c) => sum + c.sunshineHours);
  int totalDepth = 0;

  for (var chicken in chickens) {
    final lineageDoc = await FirebaseFirestore.instance
        .collection('lineage')
        .doc(chicken.lineageId)
        .get();

    if (lineageDoc.exists) {
      final lineage = Lineage.fromFirestore(lineageDoc.data() as Map<String, dynamic>, lineageDoc.id);
      totalDepth += lineage.parentIds.length;
    }
  }

  int count = chickens.length;
  double avgEggs = count > 0 ? totalEggs / count : 0;
  double avgSunshine = count > 0 ? totalSunshine / count : 0;
  double avgDepth = count > 0 ? totalDepth / count : 0;

  // Simple classifier
  String personality = "Balanced Blend";
  if (avgSunshine > 250 && avgEggs < 50) personality = "Sunny Socialites";
  if (avgDepth > 3 && avgEggs > 100) personality = "Heritage Hustlers";
  if (avgEggs > 80 && avgSunshine < 100) personality = "Hardy Harvesters";

  return {
    'averageEggs': avgEggs,
    'averageSunshine': avgSunshine,
    'averageLineageDepth': avgDepth,
    'personality': personality,
  };
}
