import 'package:flutter/material.dart';
import 'package:tradeable_learn_widget/utils/bottom_sheet_widget.dart';
import 'package:tradeable_learn_widget/utils/button_widget.dart';
import 'package:tradeable_learn_widget/utils/theme.dart';
import 'selectable_image_grid_model.dart'; // Import the model

class SelectableImageGridWidget extends StatefulWidget {
  final SelectableImageGridModel model;

  const SelectableImageGridWidget({super.key, required this.model});

  @override
  State<SelectableImageGridWidget> createState() =>
      _SelectableImageGridWidgetState();
}

class _SelectableImageGridWidgetState extends State<SelectableImageGridWidget> {
  late SelectableImageGridModel model;
  late List<ImageItem> images;

  @override
  void initState() {
    super.initState();
    model = widget.model;
    images = model.imageUrls.map((url) => ImageItem(imageUrl: url)).toList();
  }

  List<ImageItem> get selectedImages =>
      images.where((image) => image.isSelected).toList();

  void toggleSelection(ImageItem imageItem) {
    setState(() {
      imageItem.isSelected = !imageItem.isSelected;
    });
  }

  void submitSelection() {
    List<String> selectedUrls = selectedImages.map((e) => e.imageUrl).toList();
    Set<String> selectedSet = selectedUrls.toSet();
    Set<String> correctSet = model.correctResponses.toSet();

    setState(() {
      model.isCorrect = selectedSet.length == correctSet.length &&
          selectedSet.containsAll(correctSet);
    });
    showModalBottomSheet(
        isDismissible: false,
        context: context,
        builder: (context) => BottomSheetWidget(
            isCorrect: model.isCorrect,
            explanationString: "Explanation goes here"));
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
            child: Text(model.title, style: textStyles.smallBold)),
        SizedBox(
          height: 300,
          width: double.infinity,
          child: Container(
            padding: const EdgeInsets.all(8),
            margin: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  'assets/folder.png',
                  package: 'tradeable_learn_widget/lib',
                ),
              ),
            ),
            child: selectedImages.isEmpty
                ? const Center(child: Text('No Images Selected'))
                : Center(
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 10,
                      runSpacing: 10,
                      children: selectedImages
                          .map((image) => Image.network(
                                image.imageUrl,
                                width: 80,
                                height: 80,
                              ))
                          .toList(),
                    ),
                  ),
          ),
        ),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Text(model.question, style: textStyles.mediumNormal)),
        const SizedBox(height: 20),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1.4,
              ),
              shrinkWrap: true,
              itemCount: images.length,
              itemBuilder: (context, index) {
                final imageItem = images[index];
                return GestureDetector(
                  onTap: () => toggleSelection(imageItem),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          imageItem.imageUrl,
                          fit: BoxFit.cover,
                          width: 140,
                          height: 140,
                        ),
                      ),
                      if (imageItem.isSelected)
                        const Positioned(
                          right: 0,
                          bottom: 0,
                          child: Icon(Icons.check_circle, color: Colors.green),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
          child: ButtonWidget(
              color: colors.primary,
              btnContent: "Submit",
              onTap: () {
                submitSelection();
              }),
        )
      ],
    );
  }
}
