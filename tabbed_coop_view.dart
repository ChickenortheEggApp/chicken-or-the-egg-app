import 'package:flutter/material.dart';
import '../services/coop_service.dart';
import '../coop_dashboard.dart';

class TabbedCoopView extends StatefulWidget {
  @override
  _TabbedCoopViewState createState() => _TabbedCoopViewState();
}

class _TabbedCoopViewState extends State<TabbedCoopView> with TickerProviderStateMixin {
  late TabController _tabController;
  List<String> coopIds = [];

  @override
  void initState() {
    super.initState();
    fetchCoopIds().then((ids) {
      setState(() {
        coopIds = ids;
        _tabController = TabController(length: coopIds.length, vsync: this);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (coopIds.isEmpty) return Center(child: CircularProgressIndicator());

    return Column(
      children: [
        TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: coopIds.map((id) => Tab(text: "🐔 $id")).toList(),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: coopIds.map((id) => CoopDashboard(coopId: id)).toList(),
          ),
        ),
      ],
    );
  }
}
