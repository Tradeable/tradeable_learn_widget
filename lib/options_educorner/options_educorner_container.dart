import 'package:flutter/material.dart';

class OptionsEduCorner extends StatelessWidget {
  final Widget topSection;
  final Widget middleSection;
  final Widget explanationSection;
  final String title;
  final VoidCallback onNextPressed;

  const OptionsEduCorner({
    super.key,
    required this.topSection,
    required this.middleSection,
    required this.explanationSection,
    required this.title,
    required this.onNextPressed
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Center(
          child: Text(
            title,
            style: const TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(flex: 4, child: topSection),
        const SizedBox(height: 20),
        Expanded(flex: 3, child: middleSection),
        const SizedBox(height: 30),
        Expanded(flex: 3, child: explanationSection),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: () {
              onNextPressed();
            },
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color.fromRGBO(56, 235, 84, 1),
                ),
              ),
              child: const Align(
                alignment: Alignment.center,
                child: Text(
                  "Next",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
