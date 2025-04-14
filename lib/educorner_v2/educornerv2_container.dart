import 'package:flutter/material.dart';
import 'package:tradeable_learn_widget/educorner_v2/educorner_v2_model.dart';
import 'package:tradeable_learn_widget/educorner_v2/educornerv2_editor_mode.dart';

class EduCornerV2Container extends StatelessWidget {
  final EducornerV2Model model;

  const EduCornerV2Container({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => EduCornerV2Editor(onSave: () {})));
              },
              child: const Text("Edu Corner Editor")),
        ],
      ),
    );
  }
}
