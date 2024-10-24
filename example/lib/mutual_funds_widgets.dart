import 'package:example/data_model/bucket_containerV2_model.dart';
import 'package:example/data_model/exit_fees_calculator_model.dart';
import 'package:example/data_model/image_mcq_model.dart';
import 'package:example/data_model/investment_analysis_model.dart';
import 'package:example/data_model/mf_calculator_model.dart';
import 'package:example/data_model/risk_reward_ratio_model.dart';
import 'package:example/data_model/selectable_image_grid_model.dart';
import 'package:example/main.dart';
import 'package:flutter/material.dart';
import 'package:tradeable_learn_widget/mutual_funds/bucket_widgetv2/bucket_containerv2.dart';
import 'package:tradeable_learn_widget/mutual_funds/bucket_widgetv2/models/bucket_modelv2.dart';
import 'package:tradeable_learn_widget/mutual_funds/exit_fees_calculator/exit_fees_calculator_main.dart';
import 'package:tradeable_learn_widget/mutual_funds/exit_fees_calculator/exit_fees_calculator_model.dart';
import 'package:tradeable_learn_widget/mutual_funds/family_plot/family_plot_widget.dart';
import 'package:tradeable_learn_widget/mutual_funds/image_mcq/image_mcq.dart';
import 'package:tradeable_learn_widget/mutual_funds/image_mcq/image_mcq_model.dart';
import 'package:tradeable_learn_widget/mutual_funds/investment_analysis_widget/investment_analysis_main.dart';
import 'package:tradeable_learn_widget/mutual_funds/investment_analysis_widget/investment_analysis_model.dart';
import 'package:tradeable_learn_widget/mutual_funds/investment_comparsion_widget/investment_comparision_main.dart';
import 'package:tradeable_learn_widget/mutual_funds/mf_calculator_widget/mf_calculator_main.dart';
import 'package:tradeable_learn_widget/mutual_funds/mf_calculator_widget/mf_calculator_model.dart';
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
      body: SafeArea(
          child: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const NavigationButton(
                    text: "Family Plot", destination: FamilyPlotPage()),
                const NavigationButton(
                    text: "Bucket Container V2",
                    destination: BucketContainerV2Page()),
                const NavigationButton(
                    text: "Selectable Image Widget",
                    destination: SelectableGridImagePage()),
                const NavigationButton(
                    text: "Risk reward ratio Widget",
                    destination: RiskRewardWidgetPage()),
                const NavigationButton(
                    text: "Image MCQ Widget", destination: ImageMCQPage()),
                const NavigationButton(
                    text: "Investment Analysis Widget",
                    destination: InvestmentAnalysisPage()),
                NavigationButton(
                    text: "Mutual Funds Calculator",
                    destination: ScaffoldWithAppBar(
                      title: "Mutual Fund Calculator",
                      body: MfCalculatorMain(
                          model: MfCalculatorModel.fromJson(mfCalculatorModel)),
                    )),
                NavigationButton(
                    text: "Exit fees Calculator",
                    destination: ScaffoldWithAppBar(
                      title: "Exit fees Calculator",
                      body: ExitFeesCalculatorMain(
                          model: ExitFeeCalculatorModel.fromJson(
                              exitFeesCalculatorModel)),
                    )),
                const NavigationButton(
                    text: "Investment Comparsion",
                    destination: ScaffoldWithAppBar(
                      title: "Investment Comparsion",
                      body: InvestmentComparisionMain(),
                    )),
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

class InvestmentAnalysisPage extends StatelessWidget {
  const InvestmentAnalysisPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldWithAppBar(
        title: "Problem",
        body: InvestmentAnalysisMain(
            model: InvestmentAnalysisModel.fromJson(investmentAnalysisModel)));
  }
}
