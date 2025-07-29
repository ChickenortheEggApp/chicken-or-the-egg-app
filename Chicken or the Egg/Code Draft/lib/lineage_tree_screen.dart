import 'package:flutter/material.dart';
import 'package:flutter_treeview/flutter_treeview.dart';
import 'dynamic_lineage_tree_view.dart'; // assumes buildLineageTree is here

class LineageTreeScreen extends StatefulWidget {
  @override
  _LineageTreeScreenState createState() => _LineageTreeScreenState();
}

class _LineageTreeScreenState extends State<LineageTreeScreen> {
  late TreeViewController _controller;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _initTree();
  }

  Future<void> _initTree() async {
    final nodes = await buildLineageTree('rootChicken123');
    setState(() {
      _controller = TreeViewController(children: nodes);
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
          controller: _controller,
          theme: TreeViewTheme(
            expandIcon: Icons.egg,
            labelStyle: TextStyle(fontSize: 16),
          ),
          onNodeTap: (key) {
            // Navigate to chicken profile, show modal, etc.
            print('Tapped node: $key');
          },
        ),
      ),
    );
  }
}
