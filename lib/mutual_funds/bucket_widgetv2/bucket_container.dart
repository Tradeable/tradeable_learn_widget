import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:tradeable_learn_widget/bucket_widgetv1/models/bucket_model.dart';
import 'package:tradeable_learn_widget/bucket_widgetv1/models/stock_bucket_map.dart';
import 'package:tradeable_learn_widget/utils/button_widget.dart';
import 'package:tradeable_learn_widget/utils/theme.dart';

class BucketContainerV2 extends StatefulWidget {
  final BucketContainerModel model;

  const BucketContainerV2({super.key, required this.model});

  @override
  State<BucketContainerV2> createState() => _BucketContainerV2State();
}

class _BucketContainerV2State extends State<BucketContainerV2> {
  late BucketContainerModel model;
  int crossAxisCount = 0;

  @override
  void initState() {
    super.initState();
    model = widget.model;
    crossAxisCount = (model.stockBucketMap.length / 2).ceil();
  }

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).customTextStyles;
    final colors = Theme.of(context).customColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Text(model.question, style: textStyles.mediumNormal),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  children: [
                    Text(model.bucketValues[0], style: textStyles.mediumBold),
                    const SizedBox(height: 10),
                    DragTarget<StockBucketMap>(
                      onAccept: (data) {
                        if (data.bucketName == model.bucketValues[0]) {
                          setState(() {
                            model.acceptedValues.add(data);
                            model.stockBucketMap.removeWhere(
                                (item) => item.imageUrl == data.imageUrl);
                          });
                        }
                      },
                      builder: (context, candidateData, rejectedData) {
                        final acceptedItems = model.acceptedValues
                            .where((item) =>
                                item.bucketName == model.bucketValues[0])
                            .toList();
                        return Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: colors.borderColorSecondary),
                              borderRadius: BorderRadius.circular(10)),
                          height: 200,
                          child: ListView.builder(
                            itemCount: acceptedItems.length,
                            itemBuilder: (context, itemIndex) {
                              final item = acceptedItems[itemIndex];
                              return Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: colors.borderColorPrimary,
                                        width: 2),
                                    borderRadius: BorderRadius.circular(8)),
                                child: Center(
                                  child: item.imageUrl.startsWith('https://')
                                      ? Image.network(
                                          item.imageUrl,
                                          fit: BoxFit.contain,
                                          errorBuilder:
                                              (context, error, stackTrace) =>
                                                  const Icon(Icons.error),
                                        )
                                      : AutoSizeText(
                                          item.imageUrl,
                                          style: textStyles.smallNormal,
                                          textAlign: TextAlign.center,
                                        ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  children: [
                    Text(model.bucketValues[1], style: textStyles.mediumBold),
                    const SizedBox(height: 10),
                    DragTarget<StockBucketMap>(
                      onAccept: (data) {
                        if (data.bucketName == model.bucketValues[1]) {
                          setState(() {
                            model.acceptedValues.add(data);
                            model.stockBucketMap.removeWhere(
                                (item) => item.imageUrl == data.imageUrl);
                          });
                        }
                      },
                      builder: (context, candidateData, rejectedData) {
                        final acceptedItems = model.acceptedValues
                            .where((item) =>
                                item.bucketName == model.bucketValues[1])
                            .toList();
                        return Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: colors.borderColorSecondary),
                              borderRadius: BorderRadius.circular(10)),
                          height: 200,
                          child: ListView.builder(
                            itemCount: acceptedItems.length,
                            itemBuilder: (context, itemIndex) {
                              final item = acceptedItems[itemIndex];
                              return Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: colors.borderColorPrimary,
                                        width: 2),
                                    borderRadius: BorderRadius.circular(8)),
                                child: Center(
                                  child: item.imageUrl.startsWith('https://')
                                      ? Image.network(
                                          item.imageUrl,
                                          fit: BoxFit.contain,
                                          errorBuilder:
                                              (context, error, stackTrace) =>
                                                  const Icon(Icons.error),
                                        )
                                      : AutoSizeText(
                                          item.imageUrl,
                                          style: textStyles.smallNormal,
                                          textAlign: TextAlign.center,
                                        ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Sort scripts as per risk", style: textStyles.smallNormal),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(14),
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: colors.borderColorSecondary),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 2,
                  ),
                  itemCount: model.stockBucketMap.length,
                  itemBuilder: (context, index) {
                    final value = model.stockBucketMap[index];
                    return Draggable<StockBucketMap>(
                      data: value,
                      feedback: Material(
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          height: 50,
                          width: 100,
                          decoration: BoxDecoration(
                            color: colors.selectedItemColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: value.imageUrl.startsWith('https://')
                                ? Image.network(
                                    value.imageUrl,
                                    fit: BoxFit.contain,
                                  )
                                : AutoSizeText(
                                    value.imageUrl,
                                    textAlign: TextAlign.center,
                                  ),
                          ),
                        ),
                      ),
                      childWhenDragging: Container(),
                      child: Container(
                        height: 50,
                        width: 100,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          border: Border.all(color: colors.borderColorPrimary),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Center(
                          child: value.imageUrl.startsWith('https://')
                              ? Image.network(
                                  value.imageUrl,
                                  fit: BoxFit.contain,
                                )
                              : AutoSizeText(
                                  value.imageUrl,
                                  textAlign: TextAlign.center,
                                ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
          child: ButtonWidget(
              color: model.stockBucketMap.isEmpty
                  ? colors.primary
                  : colors.secondary,
              btnContent: "Next",
              onTap: () {}),
        )
      ],
    );
  }
}
