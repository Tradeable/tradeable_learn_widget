import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:tradeable_learn_widget/bucket_widgetv1/models/bucket_model.dart';
import 'package:tradeable_learn_widget/bucket_widgetv1/models/stock_bucket_map.dart';
import 'package:tradeable_learn_widget/utils/button_widget.dart';
import 'package:tradeable_learn_widget/utils/theme.dart';

class BucketContainerV1 extends StatefulWidget {
  final BucketContainerModel model;
  final VoidCallback onNextClick;

  const BucketContainerV1(
      {super.key, required this.model, required this.onNextClick});

  @override
  State<BucketContainerV1> createState() => _BucketContainerV1State();
}

class _BucketContainerV1State extends State<BucketContainerV1> {
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
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 1,
            ),
            itemCount: model.bucketValues.length,
            itemBuilder: (context, index) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    model.bucketValues[index],
                    style: textStyles.mediumBold,
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: DragTarget<StockBucketMap>(
                      onAccept: (data) {
                        if (data.bucketName == model.bucketValues[index]) {
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
                                item.bucketName == model.bucketValues[index])
                            .toList();
                        return Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: colors.borderColorSecondary),
                              borderRadius: BorderRadius.circular(10)),
                          child: GridView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    mainAxisSpacing: 10,
                                    crossAxisSpacing: 10,
                                    childAspectRatio: 1.4),
                            itemCount: acceptedItems.length,
                            itemBuilder: (context, itemIndex) {
                              return Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: colors.borderColorPrimary,
                                        width: 2),
                                    borderRadius: BorderRadius.circular(8)),
                                child: acceptedItems[itemIndex]
                                        .imageUrl
                                        .startsWith('https://')
                                    ? Image.network(
                                        acceptedItems[itemIndex].imageUrl,
                                        fit: BoxFit.contain)
                                    : Center(
                                        child: AutoSizeText(
                                            acceptedItems[itemIndex].imageUrl,
                                            style: textStyles.smallNormal,
                                            textAlign: TextAlign.center),
                                      ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Options", style: textStyles.mediumBold),
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
                          child: value.imageUrl.startsWith('https://')
                              ? Image.network(value.imageUrl,
                                  fit: BoxFit.contain)
                              : Center(
                                  child: AutoSizeText(
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
                          child: AutoSizeText(
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
              onTap: () {
                widget.onNextClick();
              }),
        )
      ],
    );
  }
}
