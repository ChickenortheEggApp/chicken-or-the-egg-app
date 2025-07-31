import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

String coopMoodAvatarPath(String personality) {
  switch (personality) {
    case "Sunny Socialites":
      return 'assets/moods/sun_squad.png';
    case "Heritage Hustlers":
      return 'assets/moods/royal_roost.png';
    case "Hardy Harvesters":
      return 'assets/moods/iron_hen.png';
    default:
      return 'assets/moods/balanced.png';
  }
}

class CreateCoopScreen extends StatefulWidget {
  @override
  _CreateCoopScreenState createState() => _CreateCoopScreenState();
}

class _CreateCoopScreenState extends State<CreateCoopScreen> {
  String coopName = "";
  String personality = "Balanced Blend";
  String avatarPath = "assets/moods/balanced.png";

  void saveCoop() {
    FirebaseFirestore.instance.collection('coops').doc(coopName).set({
      'personality': personality,
      'avatarPath': avatarPath,
      'createdAt': FieldValue.serverTimestamp(),
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Create Your Coop")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(labelText: "Coop Name"),
              onChanged: (val) => setState(() => coopName = val),
            ),
            DropdownButton<String>(
              value: personality,
              items: ["Sunny Socialites", "Heritage Hustlers", "Hardy Harvesters", "Balanced Blend"]
                .map((type) => DropdownMenuItem(value: type, child: Text(type)))
                .toList(),
              onChanged: (val) {
                setState(() {
                  personality = val!;
                  avatarPath = coopMoodAvatarPath(val);
                });
              },
            ),
            Image.asset(avatarPath, height: 100),
            ElevatedButton(onPressed: saveCoop, child: Text("🪺 Hatch Coop")),
          ],
        ),
      ),
    );
  }
}
