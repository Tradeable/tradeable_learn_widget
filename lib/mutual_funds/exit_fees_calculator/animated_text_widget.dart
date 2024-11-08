import 'package:flutter/material.dart';

class AnimatedText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final VoidCallback onAnimationComplete;

  const AnimatedText({
    super.key,
    required this.text,
    this.style,
    required this.onAnimationComplete,
  });

  @override
  State<StatefulWidget> createState() => _AnimatedTextState();
}

class _AnimatedTextState extends State<AnimatedText> {
  late String displayedText = '';
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    animateNextLetter();
  }

  void animateNextLetter() {
    if (currentIndex < widget.text.length) {
      setState(() {
        displayedText += widget.text[currentIndex];
        currentIndex++;
      });
      Future.delayed(const Duration(milliseconds: 50), animateNextLetter);
    } else {
      widget.onAnimationComplete();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      displayedText,
      style: widget.style,
      textAlign: TextAlign.center,
    );
  }
}
