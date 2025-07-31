import 'package:flutter/material.dart';
import 'package:flutter_treeview/flutter_treeview.dart';

class LineageTreeView extends StatefulWidget {
  @override
  _LineageTreeViewState createState() => _LineageTreeViewState();
}

class _LineageTreeViewState extends State<LineageTreeView> {
  TreeViewController controller = TreeViewController(
    children: [
      Node(
        key: 'lineageRoot',
        label: 'Henrietta',
        children: [
          Node(
            key: 'child1',
            label: 'Cluckster',
            children: [
              Node(key: 'grandchild1', label: 'Eggbert'),
              Node(key: 'grandchild2', label: 'Peep')
            ],
          ),
          Node(key: 'child2', label: 'Featherina'),
        ],
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chicken Lineage Tree')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TreeView(
          controller: controller,
          allowParentSelect: true,
          supportParentDoubleTap: true,
          onNodeTap: (key) {
            // Handle node tap if needed
          },
        ),
      ),
    );
  }
}
