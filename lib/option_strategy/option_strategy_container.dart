import 'package:flutter/material.dart';
import 'package:tradeable_learn_widget/option_strategy/models/option_strategy_leg.model.dart';
import 'package:tradeable_learn_widget/option_strategy/option_strategy_info_component.dart';
import 'package:tradeable_learn_widget/option_strategy/utils/option_strategy_helper.dart';
import 'package:tradeable_learn_widget/option_strategy/payoff_graph_widget.dart';
import 'package:tradeable_learn_widget/option_strategy/payoff_table_widget.dart';
import 'package:tradeable_learn_widget/utils/theme.dart';

class OptionStrategyContainer extends StatefulWidget {
  final List<OptionLeg> legs;
  final double spotPrice;
  final double spotPriceDayDelta;
  final double spotPriceDayDeltaPer;
  final Function onExecute;
  const OptionStrategyContainer(
      {super.key,
      required this.legs,
      required this.spotPrice,
      required this.spotPriceDayDelta,
      required this.spotPriceDayDeltaPer,
      required this.onExecute});

  @override
  State<OptionStrategyContainer> createState() =>
      _OptionStrategyContainerState();
}

class _OptionStrategyContainerState extends State<OptionStrategyContainer>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late PageController _pageViewController;
  late OptionStrategyHelper helper;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _pageViewController = PageController();
    helper = OptionStrategyHelper(legs: widget.legs);
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
        title: Text(
          "Analyse Your Order",
          style: Theme.of(context).customTextStyles.mediumBold,
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
        children: [
          PayoffGraphWidget(
            helper: helper,
            spotPrice: widget.spotPrice,
            spotPriceDayDelta: widget.spotPriceDayDelta,
            spotPriceDayDeltaPer: widget.spotPriceDayDeltaPer,
            optionStrategyInfoComponent: OptionStrategyInfoComponent(
              helper: helper,
              spotPrice: widget.spotPrice,
              spotPriceDayDelta: widget.spotPriceDayDelta,
              spotPriceDayDeltaPer: widget.spotPriceDayDeltaPer,
              onExecute: widget.onExecute,
            ),
          ),
          PayoffTableWidget(
              helper: helper,
              spotPrice: widget.spotPrice,
              spotPriceDayDelta: widget.spotPriceDayDelta,
              spotPriceDayDeltaPer: widget.spotPriceDayDeltaPer,
              optionStrategyInfoComponent: OptionStrategyInfoComponent(
                helper: helper,
                spotPrice: widget.spotPrice,
                spotPriceDayDelta: widget.spotPriceDayDelta,
                spotPriceDayDeltaPer: widget.spotPriceDayDeltaPer,
                onExecute: widget.onExecute,
              ))
        ],
      )),
    );
  }
}
