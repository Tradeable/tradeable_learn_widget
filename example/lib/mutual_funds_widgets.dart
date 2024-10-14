import 'package:example/data_model/bucket_containerV2_model.dart';
import 'package:example/data_model/bucket_containerv1_model.dart';
import 'package:example/main.dart';
import 'package:flutter/material.dart';
import 'package:tradeable_learn_widget/bucket_widgetv1/models/bucket_model.dart';
import 'package:tradeable_learn_widget/mutual_funds/bucket_widgetv2/bucket_container.dart';
import 'package:tradeable_learn_widget/mutual_funds/family_plot/family_plot_widget.dart';

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
                    destination: BucketContainerV2Page())
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
          model: BucketContainerModel(bucketContainerV2Model)),
    );
  }
}
