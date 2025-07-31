import 'package:flutter/material.dart';
import 'package:flutter_treeview/flutter_treeview.dart';
import '../models/chicken.dart';
import '../compute_coop_traits.dart';

class CoopDashboard extends StatelessWidget {
  final String coopId;

  const CoopDashboard({required this.coopId, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: computeCoopTraits(coopId),
      builder: (context, traitSnapshot) {
        if (!traitSnapshot.hasData) return Center(child: CircularProgressIndicator());
        final traits = traitSnapshot.data!;
        final coopName = generateCoopName(traits);
        final moodAvatar = coopMoodAvatar(traits['personality']);

        return FutureBuilder<List<Chicken>>(
          future: getChickensByCoop(coopId),
          builder: (context, chickenSnapshot) {
            if (!chickenSnapshot.hasData) return Center(child: CircularProgressIndicator());
            final chickens = chickenSnapshot.data!;
            final treeController = TreeViewController(
              children: chickens.map((c) => Node(
                key: c.id,
                label: c.name,
                icon: chickenAvatar(c),
              )).toList(),
            );

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 12),
                  moodAvatar,
                  Text(coopName, textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  SizedBox(height: 16),

                  decoratedCoopCard(traits),

                  Text("🌳 Lineage Tree", style: Theme.of(context).textTheme.headline6),
                  Container(height: 300, child: TreeView(controller: treeController)),

                  Text("☀️ Sunshine Stats", style: Theme.of(context).textTheme.headline6),
                  Container(height: 200, child: sunshineChart(chickens)),

                  Text("🏅 Badge Showcase", style: Theme.of(context).textTheme.headline6),
                  Wrap(
                    spacing: 8,
                    children: chickens.expand((c) => c.badges.map((b) =>
                      Chip(label: Text(b), avatar: chickenAvatar(c))
                    )).toList(),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
