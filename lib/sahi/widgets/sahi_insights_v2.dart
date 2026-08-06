import 'package:flutter/material.dart';
import 'package:fin_chart/models/tasks/show_insights_v2.task.dart';
import 'package:fin_chart/models/insights_v2/text_block.dart';
import 'package:fin_chart/models/insights_v2/image_block.dart';
import 'package:fin_chart/models/insights_v2/video_block.dart';
import 'package:markdown_widget/markdown_widget.dart';
import 'package:tradeable_learn_widget/educorner_v2/full_screen_image_viewer.dart';
import 'package:url_launcher/url_launcher.dart';

class SahiInsightsV2 extends StatelessWidget {
  final ShowInsightsPageV2Task task;

  const SahiInsightsV2({super.key, required this.task});

  Future<void> _openLink(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
          child: Text(task.title,
              style:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: task.blocks.length,
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final block = task.blocks[index];
    
              if (block is TextBlock) {
                return MarkdownWidget(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    data: block.markdown,
                    config: MarkdownConfig(configs: [
                      LinkConfig(
                        style: const TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                        onTap: (url) {
                          _openLink(url);
                        },
                      )
                    ]));
              } else if (block is ImageBlock) {
                return Align(
                    alignment: Alignment.center,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            barrierDismissible: true,
                            barrierColor: Colors.transparent,
                            builder: (context) => FullScreenImageViewer(
                                imageUrl: block.url,
                                heroTag: 'image_${block.url}'),
                          );
                        },
                        child: Hero(
                          tag: 'image_${block.url}',
                          child: Image.network(
                            block.url,
                            width: block.width ?? 250,
                            height: block.height ?? 250,
                            errorBuilder: (_, __, ___) =>
                                const Icon(Icons.broken_image, size: 50),
                          ),
                        ),
                      ),
                    ));
              } else if (block is VideoBlock) {
                return GestureDetector(
                  onTap: () => _openLink(block.url),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Center(
                        child: Icon(
                          Icons.play_circle_fill,
                          size: 64,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                );
              }
    
              return const SizedBox.shrink();
            },
          ),
        ),
      ],
    );
  }
}
