import 'package:flutter/material.dart';

class GradientSlider extends StatefulWidget {
  final ValueChanged<int> onChanged;

  const GradientSlider({super.key, required this.onChanged});

  @override
  State<GradientSlider> createState() => _GradientSliderState();
}

class _GradientSliderState extends State<GradientSlider> {
  double _sliderValue = 0.0;

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        trackHeight: 20.0,
        thumbShape: CustomThumbShape(),
        overlayShape: const RoundSliderOverlayShape(overlayRadius: 24.0),
        trackShape: GradientRectSliderTrackShape(),
        activeTrackColor: Colors.transparent,
        inactiveTrackColor: Colors.transparent,
      ),
      child: Slider(
        value: _sliderValue,
        min: -1,
        max: 1,
        divisions: 2,
        onChanged: (value) {
          setState(() {
            _sliderValue = value;
          });
          widget.onChanged(value.toInt());
        },
      ),
    );
  }
}

class GradientRectSliderTrackShape extends SliderTrackShape {
  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double trackHeight = sliderTheme.trackHeight ?? 2.0;
    final double trackLeft = offset.dx;
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight) / 2;
    final double trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }

  @override
  void paint(
    PaintingContext context,
    Offset offset, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required Offset thumbCenter,
    Offset? secondaryOffset,
    bool isEnabled = false,
    bool isDiscrete = false,
    required TextDirection textDirection,
  }) {
    final Rect trackRect = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
    );

    final Paint paint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xff20DF4D), Color(0xffD6DF20), Color(0xffDF2020)],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ).createShader(trackRect)
      ..style = PaintingStyle.fill;

    RRect roundedRect =
        RRect.fromRectAndRadius(trackRect, const Radius.circular(20));
    context.canvas.drawRRect(roundedRect, paint);

    final Paint borderPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    context.canvas.drawRRect(roundedRect, borderPaint);
  }
}

class CustomThumbShape extends SliderComponentShape {
  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return const Size(6, 30);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextDirection textDirection,
    required double textScaleFactor,
    required double value,
    required Size sizeWithOverflow,
    required TextPainter labelPainter,
  }) {
    final Paint paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 6.0
      ..style = PaintingStyle.stroke;

    context.canvas.drawLine(Offset(center.dx, center.dy - 15),
        Offset(center.dx, center.dy + 15), paint);

    final RRect thumbRect = RRect.fromLTRBR(center.dx - 3, center.dy - 15,
        center.dx + 3, center.dy + 15, const Radius.circular(3));
    context.canvas.drawRRect(thumbRect, paint);
  }
}
