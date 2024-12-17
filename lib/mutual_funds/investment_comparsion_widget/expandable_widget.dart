import 'package:flutter/material.dart';
import 'package:tradeable_learn_widget/utils/theme.dart';

class ExpandableWidget extends StatefulWidget {
  final String title;
  final String subtitle;
  final Widget content;

  const ExpandableWidget({
    super.key,
    required this.title,
    required this.subtitle,
    required this.content,
  });

  @override
  State<ExpandableWidget> createState() => _ExpandableWidgetState();
}

class _ExpandableWidgetState extends State<ExpandableWidget> {
  bool _isExpanded = true;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).customColors;
    final textStyles = Theme.of(context).customTextStyles;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: colors.cardBasicBackground,
        border: Border.all(color: colors.borderColorSecondary),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: colors.borderColorSecondary,
            blurRadius: 4,
            offset: const Offset(1, 4), // Shadow position
          ),
        ],
      ),
      child: ExpansionTile(
        initiallyExpanded: _isExpanded,
        onExpansionChanged: (bool expanded) {
          setState(() {
            _isExpanded = expanded;
          });
        },
        trailing: _isExpanded
            ? Icon(Icons.arrow_drop_up_outlined,
                color: colors.bullishColor, size: 26)
            : Icon(Icons.arrow_drop_down_outlined,
                color: colors.bullishColor, size: 26),
        shape: const Border(),
        title: Text(widget.title, style: textStyles.mediumBold),
        children: [
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(widget.subtitle, style: textStyles.mediumNormal),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
            child: widget.content,
          ),
        ],
      ),
    );
  }
}
