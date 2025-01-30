import 'package:flutter/material.dart';
import 'package:tradeable_learn_widget/expandable_edutile_widget/expandable_edutile_model.dart';
import 'package:tradeable_learn_widget/tradeable_learn_widget.dart';
import 'package:tradeable_learn_widget/utils/button_widget.dart';
import 'package:tradeable_learn_widget/utils/theme.dart';

class ExpandableEduTileMain extends StatefulWidget {
  final ExpandableEduTileModel model;
  final VoidCallback onNextClick;

  const ExpandableEduTileMain(
      {super.key, required this.model, required this.onNextClick});

  @override
  State<StatefulWidget> createState() => _ExpandableEduTileMainState();
}

class _ExpandableEduTileMainState extends State<ExpandableEduTileMain> {
  late ExpandableEduTileModel model;

  @override
  void initState() {
    model = widget.model;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).customTextStyles;
    final colors = Theme.of(context).customColors;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    model.shortInfo,
                    style: textStyles.smallNormal,
                  ),
                  const SizedBox(height: 16),
                  ListView(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    children: model.tiles.map((tile) {
                      return ExpandableEduTile(
                        title: tile.title,
                        subtitle: tile.subtitle,
                        content: tile.content,
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 10),
                  model.videoId.isNotEmpty
                      ? Align(
                          alignment: Alignment.bottomRight,
                          child: Container(
                              height: 50,
                              width: 150,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: colors.primary),
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Material(
                                                child: VideoEduCorner(
                                                    model: VideoEduCornerModel
                                                        .fromJson({
                                                      "video_id": model.videoId
                                                    }),
                                                    onNextClick: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    }),
                                              )));
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    const Icon(Icons.play_arrow,
                                        color: Colors.white),
                                    Text('Watch Video',
                                        style: textStyles.smallNormal
                                            .copyWith(color: Colors.white)),
                                  ],
                                ),
                              )),
                        )
                      : Container(),
                  const SizedBox(height: 60),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 50,
            child: ButtonWidget(
              color: colors.primary,
              btnContent: "Next",
              onTap: () {
                widget.onNextClick();
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ExpandableEduTile extends StatefulWidget {
  final String title;
  final String subtitle;
  final String content;

  const ExpandableEduTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.content,
  });

  @override
  State<ExpandableEduTile> createState() => _ExpandableEduTileState();
}

class _ExpandableEduTileState extends State<ExpandableEduTile> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).customColors;
    final textStyles = Theme.of(context).customTextStyles;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        border: Border.all(color: colors.borderColorSecondary),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: ExpansionTile(
        initiallyExpanded: _isExpanded,
        onExpansionChanged: (bool expanded) {
          setState(() {
            _isExpanded = expanded;
          });
        },
        shape: const Border(),
        title: Text(widget.subtitle),
        subtitle: Text(
          widget.title,
          style: textStyles.mediumBold,
        ),
        children: [
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
            child: Text(widget.content),
          ),
        ],
      ),
    );
  }
}
