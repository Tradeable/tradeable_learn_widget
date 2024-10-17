import 'package:flutter/material.dart';

class InvestmentAnalysisMain extends StatefulWidget {
  @override
  _MinimalistBarChartWithDragDropState createState() =>
      _MinimalistBarChartWithDragDropState();
}

class _MinimalistBarChartWithDragDropState
    extends State<InvestmentAnalysisMain> {
  List<int> barHeights = [100, 150, 200, 120, 180];
  List<String?> droppedIcons = List.filled(5, null);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 300,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(barHeights.length, (index) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  DragTarget<String>(
                    builder: (context, candidateData, rejectedData) {
                      return Container(
                        height: 30,
                        width: 40,
                        decoration: BoxDecoration(
                          color: droppedIcons[index] != null
                              ? Colors.blueAccent
                              : Colors.grey[200],
                          shape: BoxShape.circle,
                        ),
                        child: droppedIcons[index] != null
                            ? Icon(_getIcon(droppedIcons[index]!),
                                color: Colors.white)
                            : SizedBox.shrink(),
                      );
                    },
                    onAccept: (data) {
                      setState(() {
                        droppedIcons[index] = data;
                      });
                    },
                  ),
                  SizedBox(height: 10),
                  Container(
                    width: 40,
                    height: barHeights[index].toDouble(),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      gradient: LinearGradient(
                        colors: [Colors.greenAccent, Colors.teal],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                  ),
                ],
              );
            }),
          ),
        ),
        SizedBox(height: 40),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: ['star', 'favorite'].map((icon) {
            return Draggable<String>(
              data: icon,
              feedback:
                  Icon(_getIcon(icon), color: Colors.blueAccent, size: 40),
              childWhenDragging:
                  Icon(_getIcon(icon), color: Colors.grey[400], size: 40),
              child: Icon(_getIcon(icon), color: Colors.blueAccent, size: 40),
            );
          }).toList(),
        ),
      ],
    );
  }

  IconData _getIcon(String icon) {
    switch (icon) {
      case 'star':
        return Icons.star;
      case 'favorite':
        return Icons.favorite;
      default:
        return Icons.help;
    }
  }
}
