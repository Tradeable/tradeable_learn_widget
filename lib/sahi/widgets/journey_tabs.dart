import 'package:flutter/material.dart';
import 'package:tradeable_learn_widget/tlw.dart';
import 'package:tradeable_learn_widget/utils/theme.dart';

class JourneyTabs extends StatefulWidget {
  const JourneyTabs({super.key});

  @override
  State<JourneyTabs> createState() => _JourneyTabsState();
}

class _JourneyTabsState extends State<JourneyTabs> {
  static const _labels = ['Instruction', 'Transcription', 'Notes'];

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final colors =
        TLW().themeData?.customColors ?? Theme.of(context).customColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 44,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: colors.sahiCardBorderColor),
            ),
          ),
          child: Row(
            children: List.generate(_labels.length, (index) {
              return Expanded(
                child: _JourneyTab(
                  label: _labels[index],
                  selected: index == _selectedIndex,
                  onTap: () => setState(() => _selectedIndex = index),
                ),
              );
            }),
          ),
        ),
        const SizedBox(height: 16),
        _buildTabContent(colors),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildTabContent(CustomColors colors) {
    switch (_selectedIndex) {
      case 0:
        return const TaskWidget();
      case 1:
        return _PlaceholderTab(
          text: 'Transcription',
          color: colors.secondary,
        );
      case 2:
        return _PlaceholderTab(
          text: 'Notes',
          color: colors.secondary,
        );
      default:
        return const SizedBox.shrink();
    }
  }
}

class _JourneyTab extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _JourneyTab({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors =
        TLW().themeData?.customColors ?? Theme.of(context).customColors;
    final color = selected ? Colors.black : colors.secondary;

    return InkWell(
      onTap: onTap,
      child: Stack(
        children: [
          Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                color: color,
              ),
            ),
          ),
          if (selected)
            Positioned(
              left: 6,
              right: 6,
              bottom: 0,
              child: Container(
                height: 2,
                color: colors.secondary,
              ),
            ),
        ],
      ),
    );
  }
}

class TaskWidget extends StatelessWidget {
  const TaskWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final colors =
        TLW().themeData?.customColors ?? Theme.of(context).customColors;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'TASK',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: colors.sahiGradientPrimaryStart,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Watch the video',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF303030),
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Learn to read the chart.',
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFF666666),
            ),
          ),
          const SizedBox(height: 18),
          const _TaskStep(
            number: '1',
            text: 'Watch the video to learn Bull Put Spread strategy.',
          ),
          const SizedBox(height: 12),
          const _TaskStep(
            number: '2',
            text:
                'Click Proceed after watching the video to proceed to journey',
          ),
          const SizedBox(height: 18),
          const _LearningObjectiveCard(),
        ],
      ),
    );
  }
}

class _TaskStep extends StatelessWidget {
  final String number;
  final String text;

  const _TaskStep({
    required this.number,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final colors =
        TLW().themeData?.customColors ?? Theme.of(context).customColors;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 22,
          height: 22,
          decoration: BoxDecoration(
            color: colors.sahiToolbarActiveBg,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Text(
            number,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: colors.sahiGradientPrimaryStart,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 1),
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 13,
                height: 1.35,
                color: Color(0xFF3F3F3F),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _LearningObjectiveCard extends StatelessWidget {
  const _LearningObjectiveCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 13, 14, 14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF4EF),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.insights_outlined,
                size: 17,
                color: Color(0xFFFF3D00),
              ),
              SizedBox(width: 7),
              Text(
                'Learning Objective',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFFF3D00),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const _ObjectivePoint(
            text:
                'A Bull Put Spread is one of the most popular option-selling strategies for traders who expect the market to remain above an important support level.',
          ),
          const SizedBox(height: 7),
          const _ObjectivePoint(
            text:
                'In this journey, you’ll learn how professional traders identify support using Open Interest, select the right Put option to sell, understand the risks of naked option selling, and build a Bull Put Spread to limit downside risk.',
          ),
        ],
      ),
    );
  }
}

class _ObjectivePoint extends StatelessWidget {
  final String text;

  const _ObjectivePoint({
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 6),
          child: SizedBox(
            width: 4,
            height: 4,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Color(0xFFFF3D00),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              height: 1.45,
              color: Color(0xFFFF3D00),
            ),
          ),
        ),
      ],
    );
  }
}

class _PlaceholderTab extends StatelessWidget {
  final String text;
  final Color color;

  const _PlaceholderTab({
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140,
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            fontSize: 14,
            color: color,
          ),
        ),
      ),
    );
  }
}
