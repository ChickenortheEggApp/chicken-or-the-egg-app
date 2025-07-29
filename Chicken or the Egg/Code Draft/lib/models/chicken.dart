import 'package:confetti/confetti.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:http/http.dart' as http;
import 'dart:io';

class Chicken {
  final String id;
  final String name;
  final String breed;
  final DateTime hatchDate;
  final String lineageId;
  final int eggsLaid;
  final double sunshineHours;
  final List<String> badges;
  final String originStory;

  Chicken({
    required this.id,
    required this.name,
    required this.breed,
    required this.hatchDate,
    required this.lineageId,
    required this.eggsLaid,
    required this.sunshineHours,
    required this.badges,
    required this.originStory,
  });

  factory Chicken.fromFirestore(Map<String, dynamic> data, String id) {
    return Chicken(
      id: id,
      name: data['name'],
      breed: data['breed'],
      hatchDate: DateTime.parse(data['hatchDate']),
      lineageId: data['lineageId'],
      eggsLaid: data['eggsLaid'],
      sunshineHours: data['sunshineHours'].toDouble(),
      badges: List<String>.from(data['badges']),
      originStory: data['originStory'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'breed': breed,
      'hatchDate': hatchDate.toIso8601String(),
      'lineageId': lineageId,
      'eggsLaid': eggsLaid,
      'sunshineHours': sunshineHours,
      'badges': badges,
      'originStory': originStory,
    };
  }
}

// Assign badges to a chicken based on its stats and lineage depth
List<String> assignBadges(Chicken chicken, int lineageDepth) {
  List<String> badges = [];

  if (lineageDepth >= 3) badges.add('Legacy Clucker');
  if (chicken.eggsLaid > 100) badges.add('Golden Layer');
  if (chicken.sunshineHours > 300) badges.add('Sunshine Star');

  return badges;
}

// Generate BarChartData for sunshine hours visualization
BarChartData generateSunshineChart(List<Chicken> chickens) {
  return BarChartData(
    barGroups: chickens.map((chicken) {
      return BarChartGroupData(
        x: chickens.indexOf(chicken),
        barRods: [BarChartRodData(y: chicken.sunshineHours, colors: [Colors.orange])],
      );
    }).toList(),
  );
}

// Widget to display a chicken avatar based on badges
Widget chickenAvatar(Chicken chicken) {
  String asset = 'assets/avatars/default.png';

  if (chicken.badges.contains('Legacy Clucker')) {
    asset = 'assets/avatars/legacy_crown.gif';
  } else if (chicken.badges.contains('Sunshine Star')) {
    asset = 'assets/avatars/sunny_chicken.gif';
  } else if (chicken.badges.contains('Golden Layer')) {
    asset = 'assets/avatars/golden_hen.gif';
  }

  return Image.asset(asset, height: 50, width: 50);
}

// Widget to display a sunshine hours bar chart for chickens
Widget sunshineChart(List<Chicken> chickens) {
  return BarChart(
    BarChartData(
      alignment: BarChartAlignment.spaceAround,
      barGroups: chickens.map((chicken) {
        return BarChartGroupData(
          x: chickens.indexOf(chicken),
          barRods: [
            BarChartRodData(
              y: chicken.sunshineHours,
              colors: [Colors.deepOrangeAccent],
              width: 16,
            ),
          ],
        );
      }).toList(),
    ),
  );
}

// Widget to display coop traits summary card
Widget coopTraitsCard(Map<String, dynamic> traits) {
  return Card(
    child: Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("🥚 Eggs: "+traits['averageEggs'].toStringAsFixed(1)),
          Text("🌞 Sunshine: "+traits['averageSunshine'].toStringAsFixed(1)+" hrs"),
          Text("🧬 Lineage Depth: "+traits['averageLineageDepth'].toStringAsFixed(1)),
          Text("🎭 Personality: "+traits['personality'], style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    ),
  );
}

// Widget to display a coop mood avatar based on personality
Widget coopMoodAvatar(String personality) {
  switch (personality) {
    case "Sunny Socialites":
      return Image.asset('assets/moods/sun_squad.png');
    case "Heritage Hustlers":
      return Image.asset('assets/moods/royal_roost.png');
    case "Hardy Harvesters":
      return Image.asset('assets/moods/iron_hen.png');
    default:
      return Image.asset('assets/moods/balanced.png');
  }
}

// Generate a fun coop name based on traits
String generateCoopName(Map<String, dynamic> traits) {
  if (traits['personality'] == 'Sunny Socialites') return "☀️ The Sun Squad";
  if (traits['personality'] == 'Heritage Hustlers') return "👑 The Cluckerati";
  if (traits['personality'] == 'Hardy Harvesters') return "🥚 Eggforce One";
  return "🌿 The Featherfold";
}

// Widget to display a decorated coop card with name, avatar, and stats
Widget decoratedCoopCard(Map<String, dynamic> traits) {
  String name = generateCoopName(traits);
  Widget avatar = coopMoodAvatar(traits['personality']);

  return Card(
    elevation: 6,
    color: Colors.yellow[50],
    child: Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          avatar,
          SizedBox(height: 8),
          Text(name, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          Divider(),
          Text("🥚 Avg Eggs: "+traits['averageEggs'].toStringAsFixed(1)),
          Text("🌞 Avg Sunshine: "+traits['averageSunshine'].toStringAsFixed(1)+" hrs"),
          Text("🧬 Avg Lineage Depth: "+traits['averageLineageDepth'].toStringAsFixed(1)),
          Text("🎭 Personality: "+traits['personality']),
        ],
      ),
    ),
  );
}

// Get the asset path for a coop mood avatar
String coopMoodAvatarPath(String mood) {
  switch (mood) {
    case "Sunny Socialites": return "assets/moods/sun_squad.png";
    case "Heritage Hustlers": return "assets/moods/royal_roost.png";
    case "Hardy Harvesters": return "assets/moods/iron_hen.png";
    default: return "assets/moods/balanced.png";
  }
}

// Get default badges for a coop personality
List<String> getDefaultBadges(String personality) {
  switch (personality) {
    case "Sunny Socialites":
      return ["Sun Seeker", "Friendly Feathers", "Early Riser"];
    case "Heritage Hustlers":
      return ["Golden Beak", "Legacy Clucker", "Egg Scholar"];
    case "Hardy Harvesters":
      return ["Tough Talon", "Nest Builder", "Hard-Boiled"];
    default:
      return ["Curious Clucker", "Barnyard Buddy"];
  }
}

// Assign and save a badge to a chicken in Firestore
Future<void> assignAndSaveBadge(Chicken chicken, String badgeName) async {
  final updatedBadges = [...chicken.badges, badgeName];
  await FirebaseFirestore.instance.collection('chickens').doc(chicken.id).update({
    'badges': updatedBadges,
  });
}

// Show a confetti overlay when a chicken earns a badge
void showConfettiOverlay(BuildContext context, String chickenName, String badgeName) {
  final controller = ConfettiController(duration: Duration(seconds: 3));
  controller.play();

  showDialog(
    context: context,
    builder: (_) => Stack(
      children: [
        ConfettiWidget(confettiController: controller, blastDirectionality: BlastDirectionality.explosive),
        AlertDialog(
          title: Text("🎉 Coop Celebration!"),
          content: Text("$chickenName earned the $badgeName badge!"),
        ),
      ],
    ),
  );
}

// Show a dialog when a badge is unlocked
void showBadgeUnlocked(BuildContext context, String badgeName, String iconPath) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      backgroundColor: Colors.yellow[100],
      title: Text("🏅 Badge Unlocked!"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(iconPath, height: 60),
          SizedBox(height: 8),
          Text("Your chicken earned: $badgeName"),
        ],
      ),
    ),
  );
}

// Monitor chicken milestones and unlock badges
void monitorChickenMilestones(String chickenId, BuildContext context) {
  FirebaseFirestore.instance.collection('chickens').doc(chickenId).snapshots().listen((snapshot) {
    if (!snapshot.exists) return;
    final chicken = Chicken.fromFirestore(snapshot.data() as Map<String, dynamic>, chickenId);

    if (chicken.eggsLaid == 100 && !chicken.badges.contains("Egg Scholar")) {
      showBadgeUnlocked(context, "Egg Scholar", "assets/badges/egg_scholar.png");
      assignAndSaveBadge(chicken, "Egg Scholar");
      logMilestone(chickenId, "Egg Scholar", "Laid 100 eggs. Legendary yolker!");
    }

    if (chicken.sunshineHours > 300 && !chicken.badges.contains("Sunshine Star")) {
      showBadgeUnlocked(context, "Sunshine Star", "assets/badges/sun_star.png");
      assignAndSaveBadge(chicken, "Sunshine Star");
      logMilestone(chickenId, "Sunshine Star", "Over 300 hours in the sun! True sunbather.");
    }
    // Add more milestone checks here
    if (chicken.lineageId.isNotEmpty && chicken.badges.contains("Legacy Clucker") == false && chicken.lineageId.length >= 5) {
      showBadgeUnlocked(context, "Legacy Clucker", "assets/badges/legacy_clucker.png");
      assignAndSaveBadge(chicken, "Legacy Clucker");
      logMilestone(chickenId, "Legacy Clucker", "Lineage depth 5+. Family roots run deep!");
    }
  });
}

// Monitor coop-wide chicken milestones and celebrate new badge unlocks
void monitorCoopMilestones(String coopId, BuildContext context) {
  FirebaseFirestore.instance.collection('chickens')
    .where('coopId', isEqualTo: coopId)
    .snapshots()
    .listen((snapshot) {
      for (var doc in snapshot.docs) {
        final chicken = Chicken.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
        if (shouldCelebrate(chicken)) {
          showConfettiOverlay(context, chicken.name, getNewBadge(chicken));
        }
      }
    });
}

// Returns true if a chicken should be celebrated for a new badge unlock
bool shouldCelebrate(Chicken chicken) {
  // Example: Celebrate if the chicken has a badge that was not present last time (requires tracking previous state)
  // For demo, celebrate if badges list is not empty
  return chicken.badges.isNotEmpty;
}

// Returns the most recently unlocked badge for a chicken
String getNewBadge(Chicken chicken) {
  // Example: Return the last badge in the list
  return chicken.badges.isNotEmpty ? chicken.badges.last : "";
}

// Log milestone badge unlocks to the journals collection
Future<void> logMilestone(String chickenId, String badgeName, String note) async {
  await FirebaseFirestore.instance.collection('journals').add({
    'chickenId': chickenId,
    'badge': badgeName,
    'timestamp': FieldValue.serverTimestamp(),
    'note': note,
  });
}

// Generate a fun origin story for a chicken
String generateOriginStory(String name, String breed, String personality) {
  final templates = [
    "$name hatched under a full moon in the legendary coop of $personality.",
    "No one expected a $breed with feathers so fine — until $name strutted in.",
    "$name was raised on sunshine, sass, and the teachings of the Great Clucker.",
    "Born in a peanut-powered storm, $name rewrote the rules of eggdom.",
  ];

  templates.shuffle();
  return templates.first;
}


// Widget for generating and displaying a random origin story for a chicken
class OriginStoryButton extends StatefulWidget {
  final String name;
  final String breed;
  final String personality;

  const OriginStoryButton({
    Key? key,
    required this.name,
    required this.breed,
    required this.personality,
  }) : super(key: key);

  @override
  _OriginStoryButtonState createState() => _OriginStoryButtonState();
}

class _OriginStoryButtonState extends State<OriginStoryButton> {
  String originStory = "";

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ElevatedButton(
          onPressed: () {
            final story = generateOriginStory(
              widget.name,
              widget.breed,
              widget.personality,
            );
            setState(() => originStory = story);
          },
          child: Text("🎲 Random Origin"),
        ),
        if (originStory.isNotEmpty)
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Text(
              originStory,
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
        // Optionally, add a copy-to-clipboard button for convenience
        if (originStory.isNotEmpty)
          TextButton.icon(
            icon: Icon(Icons.copy, size: 18),
            label: Text("Copy Story"),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: originStory));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Origin story copied!")),
              );
            },
          ),
      ],
    );
  }
}


// Card widget to display chicken details and origin story
class ChickenStoryCard extends StatelessWidget {
  final Chicken chicken;

  const ChickenStoryCard({Key? key, required this.chicken}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(12),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            chickenAvatar(chicken),
            SizedBox(height: 8),
            Text(chicken.name, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text("Breed: ${chicken.breed} • Eggs: ${chicken.eggsLaid} • ☀️ ${chicken.sunshineHours} hrs"),
            SizedBox(height: 8),
            Text("Origin Story", style: TextStyle(fontWeight: FontWeight.bold)),
            Text(chicken.originStory, style: TextStyle(fontStyle: FontStyle.italic)),
            SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: chicken.badges.map((b) => Chip(label: Text(b))).toList(),
            ),
            // Add the OriginStoryButton for generating a new story
            SizedBox(height: 12),
            OriginStoryButton(
              name: chicken.name,
              breed: chicken.breed,
              personality: "", // Pass the coop personality if available
            ),
          ],
        ),
      ),
    );
  }
}

class GoogleAuthClient extends http.BaseClient {
  final Map<String, String> _headers;
  final http.Client _client = http.Client();
  GoogleAuthClient(this._headers);
  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    return _client.send(request..headers.addAll(_headers));
  }
}

Future<void> saveProfileToGoogleDrive(String filePath, String folderId) async {
  final GoogleSignInAccount? account = await GoogleSignIn(scopes: ['https://www.googleapis.com/auth/drive.file']).signIn();
  if (account == null) throw Exception('Google sign-in failed');
  final authHeaders = await account.authHeaders;
  final authenticateClient = GoogleAuthClient(authHeaders);
  final driveApi = drive.DriveApi(authenticateClient);

  var fileToUpload = drive.File();
  fileToUpload.name = 'profile.json';
  fileToUpload.parents = [folderId];

  var fileContent = await File(filePath).readAsBytes();
  await driveApi.files.create(
    fileToUpload,
    uploadMedia: drive.Media(Stream.value(fileContent), fileContent.length),
  );
}
// Usage: await saveProfileToGoogleDrive('/path/to/profile.json', '1sPfKOvmPeHbxmTYcfr1TQhB2Fx1z8b7J');

Future<void> saveChickenProfile(Chicken chicken) async {
  // Serialize chicken profile to JSON
  final profileJson = {
    'id': chicken.id,
    'name': chicken.name,
    'breed': chicken.breed,
    'hatchDate': chicken.hatchDate.toIso8601String(),
    'lineageId': chicken.lineageId,
    'eggsLaid': chicken.eggsLaid,
    'sunshineHours': chicken.sunshineHours,
    'badges': chicken.badges,
    'originStory': chicken.originStory,
  };
  final tempDir = Directory.systemTemp;
  final filePath = '${tempDir.path}/chicken_profile_${chicken.id}.json';
  final file = File(filePath);
  await file.writeAsString(profileJson.toString());
  // Save to Google Drive folder
  await saveProfileToGoogleDrive(filePath, '1sPfKOvmPeHbxmTYcfr1TQhB2Fx1z8b7J');
}
// Usage: await saveChickenProfile(chicken);
