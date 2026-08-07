import 'package:flutter/material.dart';
import 'package:tradeable_learn_widget/sahi/widgets/journey_item.dart';
import 'package:tradeable_learn_widget/sahi/widgets/journey_toolbar_item.dart';
import 'package:tradeable_learn_widget/utils/theme.dart';
import 'package:url_launcher/url_launcher.dart';

class JourneyToolbar extends StatelessWidget {
  final List<JourneyItem> items;
  final CustomColors colors;
  final VoidCallback onBack;
  final String videoUrl;

  const JourneyToolbar({
    super.key,
    required this.items,
    required this.colors,
    required this.onBack,
    required this.videoUrl,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final itemWidth = constraints.maxWidth * 0.7;
        return Container(
          margin: const EdgeInsets.fromLTRB(12, 14, 0, 24),
          decoration: BoxDecoration(
            color: colors.sahiToolbarBg,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: colors.sahiToolbarShadow,
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              const SizedBox(height: 12),
              GestureDetector(
                onTap: onBack,
                child: Container(
                  width: itemWidth,
                  height: 30,
                  decoration: BoxDecoration(
                    color: colors.sahiStreakColor,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: colors.sahiTabBorder, width: 1),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.arrow_back_ios_rounded, size: 10),
                      const SizedBox(width: 4),
                      const Text("Back", style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () {
                  if(videoUrl.isEmpty) return;
                  launchUrl(Uri.parse(videoUrl));
                },
                child: Container(
                  width: itemWidth,
                  height: 80,
                  decoration: BoxDecoration(
                    color: colors.sahiUtilityBg,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        height: 34,
                        width: 34,
                        decoration: BoxDecoration(
                          color: colors.sahiToolbarActiveBg,
                          shape: BoxShape.circle,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: const [
                                Color.fromRGBO(140, 128, 229, 1),
                                Color.fromRGBO(224, 159, 135, 1),
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.play_arrow_outlined,
                            size: 14,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const Text(
                        "Watch",
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  'JOURNEY',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              items.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          'No journeys',
                          style: TextStyle(
                            fontSize: 13,
                            color: colors.textColorSecondary,
                          ),
                        ),
                      ),
                    )
                  : Center(
                      child: Container(
                        width: itemWidth,
                        decoration: BoxDecoration(
                          color: colors.sahiUtilityBg,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shrinkWrap: true,
                          itemCount: items.length,
                          itemBuilder: (context, index) {
                            final item = items[index];
                            return Column(
                              children: [
                                JourneyToolbarItem(
                                  item: item,
                                  colors: colors,
                                  index: index + 1,
                                ),
                                if (index < items.length - 1)
                                  Container(
                                    width: 2,
                                    height: 16,
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 6),
                                    color: colors.sahiTabBorder,
                                  ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
            ],
          ),
        );
      },
    );
  }
}
