import 'package:flutter/material.dart';
import 'package:flutter_treeview/flutter_treeview.dart';
import 'dynamic_lineage_tree_view.dart';

class CoopLineageTabView extends StatelessWidget {
  const CoopLineageTabView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Coop Lineage Trees'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Coop Alpha'),
              Tab(text: 'Coop Beta'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            FutureBuilder<List<Node>>(
              future: buildCoopLineageTree('coopAlpha'),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
                return TreeView(controller: TreeViewController(children: snapshot.data!));
              },
            ),
            FutureBuilder<List<Node>>(
              future: buildCoopLineageTree('coopBeta'),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
                return TreeView(controller: TreeViewController(children: snapshot.data!));
              },
            ),
          ],
        ),
      ),
    );
  }
}
