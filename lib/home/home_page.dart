import 'package:flutter/material.dart';
import 'package:time_tracker/home/cupertino_home_scaffold.dart';
import 'package:time_tracker/home/entries/entries_page.dart';
import 'package:time_tracker/home/tab_item.dart';

import 'account/account_page.dart';
import 'jobs/jobs_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys = {
    TabItem.jobs: GlobalKey<NavigatorState>(),
    TabItem.entries: GlobalKey<NavigatorState>(),
    TabItem.account: GlobalKey<NavigatorState>(),
  };

  TabItem _currentTab = TabItem.jobs;
  Map<TabItem, WidgetBuilder> get widgetBuilders {
    return {
      TabItem.jobs: (_) => const JobsPage(),
      TabItem.entries: (context) => EntriesPage.create(context),
      TabItem.account: (_) => const AccountPage(),
    };
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async =>
          !await navigatorKeys[_currentTab]!.currentState!.maybePop(),
      child: CupertinoHomeScaffold(
        widgetBuilders: widgetBuilders,
        currentTab: _currentTab,
        onSelectTab: _select,
        navigatorKeys: navigatorKeys,
      ),
    );
  }

  void _select(TabItem tabItem) {
    if (tabItem == _currentTab) {
      navigatorKeys[tabItem]!.currentState!.popUntil((route) => route.isFirst);
    } else {
      setState(() => _currentTab = tabItem);
    }
  }
}
