import 'package:example/data_model/bucket_containerV2_model.dart';
import 'package:example/data_model/image_mcq_model.dart';
import 'package:example/data_model/risk_reward_ratio_model.dart';
import 'package:example/data_model/selectable_image_grid_model.dart';
import 'package:example/main.dart';
import 'package:flutter/material.dart';
import 'package:tradeable_learn_widget/mutual_funds/bucket_widgetv2/bucket_containerv2.dart';
import 'package:tradeable_learn_widget/mutual_funds/bucket_widgetv2/models/bucket_modelv2.dart';
import 'package:tradeable_learn_widget/mutual_funds/family_plot/family_plot_widget.dart';
import 'package:tradeable_learn_widget/mutual_funds/image_mcq/image_mcq.dart';
import 'package:tradeable_learn_widget/mutual_funds/image_mcq/image_mcq_model.dart';
import 'package:tradeable_learn_widget/mutual_funds/risk_reward_ratio_widget/risk_reward_ratio_main.dart';
import 'package:tradeable_learn_widget/mutual_funds/risk_reward_ratio_widget/risk_reward_ratio_model.dart';
import 'package:tradeable_learn_widget/mutual_funds/selectable_image_grid_widget/selectable_grid_image_main.dart';
import 'package:tradeable_learn_widget/mutual_funds/selectable_image_grid_widget/selectable_image_grid_model.dart';

class MutualFundsWidgets extends StatelessWidget {
  const MutualFundsWidgets({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: const SafeArea(
          child: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                NavigationButton(
                    text: "Family Plot", destination: FamilyPlotPage()),
                NavigationButton(
                    text: "Bucket Container V2",
                    destination: BucketContainerV2Page()),
                NavigationButton(
                    text: "Selectable Image Widget",
                    destination: SelectableGridImagePage()),
                NavigationButton(
                    text: "Risk reward ratio Widget",
                    destination: RiskRewardWidgetPage()),
                NavigationButton(
                    text: "Image MCQ Widget", destination: ImageMCQPage())
              ],
            ),
          ),
        ),
      )),
    );
  }
}

class FamilyPlotPage extends StatelessWidget {
  const FamilyPlotPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldWithAppBar(
      title: "Problem",
      body: FamilyPlotWidget(),
    );
  }
}

class BucketContainerV2Page extends StatelessWidget {
  const BucketContainerV2Page({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldWithAppBar(
      title: "Problem",
      body: BucketContainerV2(
          model: BucketContainerV2Model(bucketContainerV2Model)),
    );
  }
}

class SelectableGridImagePage extends StatelessWidget {
  const SelectableGridImagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldWithAppBar(
        title: "Problem",
        body: SelectableImageGridWidget(
            model: SelectableImageGridModel(selectableImageGridModel)));
  }
}

class RiskRewardWidgetPage extends StatelessWidget {
  const RiskRewardWidgetPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldWithAppBar(
        title: "Problem",
        body: RiskRewardRatioWidget(
            model: RiskRewardRatioModel(riskRewardRatioModel)));
  }
}

class ImageMCQPage extends StatelessWidget {
  const ImageMCQPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldWithAppBar(
        title: "Problem", body: ImageMcq(model: ImageMCQModel(imageMCQModel)));
  }
}
