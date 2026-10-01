import 'package:flutter/material.dart';
import 'package:tradeable_learn_widget/candle_match_the_pair/candle_part_match.dart';
import 'package:tradeable_learn_widget/candle_match_the_pair/match_the_pair_model.dart';
import 'package:tradeable_learn_widget/sahi/content/journey_content.dart';

class SahiWidgetScreen extends StatelessWidget {
  final JourneyContentItem activity;
  final VoidCallback onNext;

  const SahiWidgetScreen({
    super.key,
    required this.activity,
    required this.onNext,
  });

  Map<String, dynamic>? get _payload {
    final payload = activity.data?['data'];
    if (payload is Map) return payload.cast<String, dynamic>();
    return null;
  }

  @override
  Widget build(BuildContext context) {
    switch (activity.widgetType) {
      case 'CA1.2':
        final payload = _payload;
        if (payload == null ||
            payload['pairFor'] is! List ||
            payload['isBullish'] is! bool) {
          return const SizedBox.shrink();
        }
        return CandlePartMatchLink(
          model: CandleMatchThePairModel.fromJson(payload),
          onNextClick: onNext,
        );
      default:
        return const SizedBox.shrink();
    }
  }
}
