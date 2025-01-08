import 'package:flutter/material.dart';
import 'package:tradeable_learn_widget/trend_line/widgets/question_widget.dart';
import 'package:tradeable_learn_widget/utils/button_widget.dart';
import 'package:tradeable_learn_widget/utils/theme.dart';

class LineQuestion extends StatelessWidget {
  final String question;
  final VoidCallback onSubmit;

  const LineQuestion(
      {super.key, required this.question, required this.onSubmit});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).customColors;
    return Column(
      children: [

        // Container(
        //     height: 40,
        //     margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 40),
        //     decoration: BoxDecoration(
        //       borderRadius: const BorderRadius.all(Radius.circular(10)),
        //       border: Border.all(
        //         color: Colors.green,
        //       ),
        //     ),
        //     child: ClipRRect(
        //       borderRadius: const BorderRadius.all(Radius.circular(10)),
        //       child: MaterialButton(
        //         onPressed: () {
        //           // takeToCorrectOffsets();
        //           // Future.delayed(const Duration(seconds: 2)).then((value) {
        //           //   goToNextQuestion();
        //           // });
        //           onSubmit();
        //         },
        //         child: const Padding(
        //           padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        //           child: Center(
        //             child: Text("Submit",
        //                 style: TextStyle(
        //                     color: Colors.white,
        //                     fontWeight: FontWeight.normal)),
        //           ),
        //         ),
        //       ),
        //     ))
      ],
    );
  }
}
