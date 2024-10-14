import 'package:example/data_model/bucket_containerV2_model.dart';
import 'package:example/data_model/bucket_containerv1_model.dart';
import 'package:example/data_model/selectable_image_grid_model.dart';
import 'package:example/main.dart';
import 'package:flutter/material.dart';
import 'package:tradeable_learn_widget/bucket_widgetv1/models/bucket_model.dart';
import 'package:tradeable_learn_widget/mutual_funds/bucket_widgetv2/bucket_containerv2.dart';
import 'package:tradeable_learn_widget/mutual_funds/bucket_widgetv2/models/bucket_modelv2.dart';
import 'package:tradeable_learn_widget/mutual_funds/family_plot/family_plot_widget.dart';
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
                    destination: SelectableGridImagePage())
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
