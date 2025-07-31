import 'package:flutter/material.dart';
import 'package:flutter_treeview/flutter_treeview.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'models/chicken.dart';
import 'models/lineage.dart';

// --- Dynamic Lineage Tree Widget ---
class LineageTreeView extends StatefulWidget {
  final String rootChickenId;
  const LineageTreeView({required this.rootChickenId, Key? key}) : super(key: key);

  @override
  _LineageTreeViewState createState() => _LineageTreeViewState();
}

class _LineageTreeViewState extends State<LineageTreeView> {
  late TreeViewController controller = TreeViewController(children: []);
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadTree();
  }

  Future<void> _loadTree() async {
    final nodes = await buildLineageTree(widget.rootChickenId);
    setState(() {
      controller = TreeViewController(children: nodes);
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (loading) return Center(child: CircularProgressIndicator());
    return Scaffold(
      appBar: AppBar(title: Text('Chicken Lineage Tree')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TreeView(
          controller: controller,
          allowParentSelect: true,
          supportParentDoubleTap: true,
          onNodeTap: (key) {
            // TODO: Open chicken or lineage detail based on the tapped node's key
            print('Tapped node: $key');
          },
        ),
      ),
    );
  }
}

// --- Dynamic Node Building Functions ---
Future<List<Node>> buildLineageTree(String rootChickenId) async {
  final chickenDoc = await FirebaseFirestore.instance.collection('chickens').doc(rootChickenId).get();
  if (!chickenDoc.exists) return [];

  final rootChicken = Chicken.fromFirestore(chickenDoc.data() as Map<String, dynamic>, chickenDoc.id);
  final lineageDoc = await FirebaseFirestore.instance.collection('lineage').doc(rootChicken.lineageId).get();

  final lineage = Lineage.fromFirestore(lineageDoc.data() as Map<String, dynamic>, lineageDoc.id);
  // Recursively build tree from parent IDs
  return _buildNodesFromLineage(lineage, rootChicken.name);
}

Future<List<Node>> _buildNodesFromLineage(Lineage lineage, String label) async {
  List<Node> children = [];

  for (String parentId in lineage.parentIds) {
    final parentDoc = await FirebaseFirestore.instance.collection('chickens').doc(parentId).get();
    if (!parentDoc.exists) continue;

    final parent = Chicken.fromFirestore(parentDoc.data() as Map<String, dynamic>, parentDoc.id);
    final parentLineageDoc = await FirebaseFirestore.instance.collection('lineage').doc(parent.lineageId).get();

    if (parentLineageDoc.exists) {
      final parentLineage = Lineage.fromFirestore(parentLineageDoc.data() as Map<String, dynamic>, parentLineageDoc.id);
      final childNodes = await _buildNodesFromLineage(parentLineage, parent.name);
      children.add(Node(key: parent.id, label: parent.name, children: childNodes));
    }
  }

  return [Node(key: lineage.id, label: label, children: children)];
}
