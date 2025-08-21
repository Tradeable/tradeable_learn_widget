import 'package:flutter/material.dart';
import 'package:tradeable_learn_widget/utils/theme.dart';
import 'package:tradeable_learn_widget/tlw.dart';

class FeedbackWidget extends StatefulWidget {
  const FeedbackWidget({super.key});

  @override
  State<FeedbackWidget> createState() => _FeedbackWidgetState();
}

class _FeedbackWidgetState extends State<FeedbackWidget> {
  int? _selectedRating;
  final TextEditingController _feedbackController = TextEditingController();

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors =
        TLW().themeData?.customColors ?? Theme.of(context).customColors;

    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: colors.containerColor,
      ),
      child: Row(
        children: [
          _buildCircularIconButton(
              context, Icons.thumb_up_off_alt_outlined, true),
          _buildCircularIconButton(
              context, Icons.thumb_down_off_alt_outlined, false),
        ],
      ),
    );
  }

  Widget _buildCircularIconButton(
      BuildContext context, IconData icon, bool isPositiveFeedback) {
    final colors =
        TLW().themeData?.customColors ?? Theme.of(context).customColors;

    return Container(
      height: 28,
      width: 28,
      margin: const EdgeInsets.all(4),
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      child: Container(
        margin: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: isPositiveFeedback ? colors.bullishColor : colors.bearishColor,
          shape: BoxShape.circle,
        ),
        child: IconButton(
          padding: EdgeInsets.zero,
          icon: Icon(icon, color: colors.cardBasicBackground, size: 14),
          tooltip: "Provide feedback",
          onPressed: () => _showFeedbackDialog(context),
        ),
      ),
    );
  }

  void _showFeedbackDialog(BuildContext context) {
    final colors =
        TLW().themeData?.customColors ?? Theme.of(context).customColors;
    final textStyles =
        TLW().themeData?.customTextStyles ?? Theme.of(context).customTextStyles;

    _selectedRating = null;
    _feedbackController.clear();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            String getHintText() {
              switch (_selectedRating) {
                case 1:
                  return "What made this content so unhelpful?";
                case 2:
                  return "What could have made this more helpful?";
                case 3:
                  return "What were you looking for specifically?";
                case 4:
                  return "What improvements would you suggest?";
                default:
                  return "Tell us your thoughts...";
              }
            }

            String getRatingDescription() {
              switch (_selectedRating) {
                case 1:
                  return "Absolute rubbish";
                case 2:
                  return "Nice but not helpful";
                case 3:
                  return "Helpful but not what I was looking for";
                case 4:
                  return "I liked it but need improvements";
                case 5:
                  return "More of this!";
                default:
                  return "Rate your experience";
              }
            }

            return AlertDialog(
              backgroundColor: colors.cardColorPrimary,
              title: Text("Your Feedback", style: textStyles.smallBold),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("How would you rate this content?",
                        style: textStyles.smallNormal),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        final starValue = index + 1;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedRating = starValue;
                            });
                          },
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                            child: Icon(
                              _selectedRating != null &&
                                      _selectedRating! >= starValue
                                  ? Icons.star
                                  : Icons.star_border,
                              color: _selectedRating != null &&
                                      _selectedRating! >= starValue
                                  ? colors.primary
                                  : colors.textColorSecondary,
                              size: 28,
                            ),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 5),
                    Center(
                      child: Text(
                        getRatingDescription(),
                        style: textStyles.smallNormal
                            .copyWith(color: colors.textColorSecondary),
                      ),
                    ),
                    const SizedBox(height: 15),
                    if (_selectedRating != null && _selectedRating! < 5) ...[
                      Text("Your Review", style: textStyles.smallNormal),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: colors.cardColorSecondary),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: TextField(
                          controller: _feedbackController,
                          maxLines: 3,
                          style: textStyles.smallNormal,
                          decoration: InputDecoration(
                            hintText: getHintText(),
                            hintStyle: textStyles.smallNormal
                                .copyWith(color: colors.textColorSecondary),
                            contentPadding: const EdgeInsets.all(10),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              actions: [
                TextButton(
                  child: Text("Cancel",
                      style: textStyles.smallNormal
                          .copyWith(color: colors.textColorSecondary)),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text("Submit",
                      style: textStyles.smallNormal
                          .copyWith(color: colors.primary)),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}
