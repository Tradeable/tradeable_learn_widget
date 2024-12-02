import 'package:flutter/material.dart';
import 'package:tradeable_learn_widget/option_strategy/payoff_graph_widget.dart';
import 'package:tradeable_learn_widget/option_strategy/payoff_table_widget.dart';
import 'package:tradeable_learn_widget/utils/theme.dart';

class OptionStrategyContainer extends StatefulWidget {
  const OptionStrategyContainer({super.key});

  @override
  State<OptionStrategyContainer> createState() =>
      _OptionStrategyContainerState();
}

class _OptionStrategyContainerState extends State<OptionStrategyContainer>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late PageController _pageViewController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _pageViewController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
    _pageViewController.dispose();
  }

  void _handlePageViewChanged(int currentPageIndex) {
    _tabController.index = currentPageIndex;
  }

  void _updateCurrentPageIndex(int index) {
    _tabController.index = index;
    _pageViewController.animateToPage(
      index,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Analyse Your Order",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.close),
          ),
        ],
        bottom: TabBar(
            controller: _tabController,
            onTap: _updateCurrentPageIndex,
            indicatorColor: Theme.of(context).customColors.primary,
            indicatorSize: TabBarIndicatorSize.tab,
            tabs: const [
              Tab(text: "Payoff Graph"),
              Tab(
                text: "Payoff Table",
              )
            ]),
      ),
      body: SafeArea(
          child: PageView(
        controller: _pageViewController,
        onPageChanged: _handlePageViewChanged,
        children: const [PayoffGraphWidget(), PayoffTableWidget()],
      )),
    );
  }
}
