import 'package:flutter/material.dart';
import 'package:tradeable_learn_widget/bucket_widgetv1/models/stock_bucket_map.dart';

class CategoryFolder extends StatelessWidget {
  final String value;
  final List<StockBucketMap>? acceptedValues;
  final int index;
  final double folderHeight;
  final double screenWidth;
  final double padding;
  final Function(DragTargetDetails<StockBucketMap>) onAcceptWithDetails;

  const CategoryFolder({
    super.key,
    required this.value,
    required this.acceptedValues,
    required this.index,
    required this.folderHeight,
    required this.screenWidth,
    required this.padding,
    required this.onAcceptWithDetails,
  });

  @override
  Widget build(BuildContext context) {
    return DragTarget<StockBucketMap>(
      onAcceptWithDetails: onAcceptWithDetails,
      builder: (context, candidateData, rejectedData) {
        return Stack(
          children: [
            CustomPaint(
              painter: FolderPainter(index),
              child: Container(
                decoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(color: Colors.grey[400]!, width: 6),
                      right: BorderSide(color: Colors.grey[400]!, width: 6),
                      bottom: BorderSide(color: Colors.grey[400]!, width: 6),
                    ),
                    borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(16),
                        bottomRight: Radius.circular(16))),
                height: folderHeight,
                width: screenWidth - 2 * padding,
              ),
            ),
            Positioned(
              top: 12,
              left: 16,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4)),
                child: Text(
                  value,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ),
            ),
            if (acceptedValues != null && acceptedValues!.isNotEmpty)
              Positioned(
                top: folderHeight * 0.5,
                left: padding * 2,
                right: padding * 2,
                child: Wrap(
                  spacing: 8.0,
                  children: acceptedValues!.map((acceptedValue) {
                    return Container(
                      padding: const EdgeInsets.all(4),
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      child: acceptedValue.imageUrl.startsWith("https")
                          ? Center(
                              child: Image.network(acceptedValue.imageUrl,
                                  width: 50, height: 50),
                            )
                          : Center(
                              child: Text(
                                acceptedValue.imageUrl,
                                style: const TextStyle(color: Colors.black),
                              ),
                            ),
                    );
                  }).toList(),
                ),
              ),
          ],
        );
      },
    );
  }
}

class FolderPainter extends CustomPainter {
  final int index;

  FolderPainter(this.index);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.primaries[index % Colors.primaries.length]
      ..style = PaintingStyle.fill;

    final path = Path();
    final folderTabHeight = size.height * 0.2;
    final folderTabWidth = size.width * 0.4;
    const borderRadius = 16.0;

    path.moveTo(0, folderTabHeight);
    path.quadraticBezierTo(0, 0, borderRadius + 10, 0);
    path.lineTo(size.width - folderTabWidth - folderTabHeight, 0);
    path.quadraticBezierTo(size.width - folderTabWidth, 0,
        size.width - folderTabWidth, folderTabHeight);
    path.lineTo(size.width, folderTabHeight);
    path.lineTo(size.width, size.height - borderRadius);
    path.quadraticBezierTo(
        size.width, size.height, size.width - borderRadius, size.height);
    path.lineTo(borderRadius, size.height);
    path.quadraticBezierTo(0, size.height, 0, size.height - borderRadius);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
