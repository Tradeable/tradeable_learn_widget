import 'package:flutter/material.dart';
import 'package:tradeable_learn_widget/atm_itm_dropdown_widget/atm_itm_dropdown_data_model.dart';
import 'package:tradeable_learn_widget/utils/button_widget.dart';
import 'package:tradeable_learn_widget/utils/theme.dart';

class ATMWidget extends StatefulWidget {
  final ATMWidgetModel model;

  const ATMWidget({super.key, required this.model});

  @override
  State<ATMWidget> createState() => _ATMWidgetState();
}

class _ATMWidgetState extends State<ATMWidget> {
  String userResponse = "";
  late ATMWidgetModel model;
  bool submitted = false;
  bool isDropdownOpen = false;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    model = widget.model;
    _focusNode.addListener(() {
      setState(() {
        isDropdownOpen = !_focusNode.hasFocus;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).customColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        renderQuestion(),
        const SizedBox(height: 40),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ...model.entries.map((e) =>
                textContent(e.model.title, e.model.value, e.model.isQuestion))
          ],
        ),
        submitted
            ? Text(model.correctResponse != userResponse
                ? "${model.correctResponse} is the correct value"
                : "")
            : Container(),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
          child: ButtonWidget(
              color: userResponse.isNotEmpty
                  ? colors.primary
                  : colors.secondary),
        ),
      ],
    );
  }

  Widget renderQuestion() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("SUB HEADING",
              style: Theme.of(context).customTextStyles.smallBold),
          Text(
            model.question,
            style: Theme.of(context).customTextStyles.smallNormal,
          ),
        ],
      ),
    );
  }

  Widget textContent(String title, String value, bool isToBeAnswered) {
    final textStyles = Theme.of(context).customTextStyles;
    final colors = Theme.of(context).customColors;
    final double containerWidth = MediaQuery.of(context).size.width * 0.4;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(title, style: textStyles.mediumBold),
        ),
        isToBeAnswered
            ? Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    Container(
                      width: containerWidth,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        border: Border.all(color: colors.borderColorPrimary),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: DropdownButtonFormField<String>(
                        dropdownColor: Colors.white,
                        decoration:
                            const InputDecoration.collapsed(hintText: ''),
                        isExpanded: true,
                        iconSize: 30,
                        iconEnabledColor: colors.borderColorPrimary,
                        value: userResponse.isEmpty ? null : userResponse,
                        hint: Text(
                          'Pick a value',
                          style: textStyles.smallNormal
                              .copyWith(color: colors.secondary),
                        ),
                        items: model.options.map((String optionValue) {
                          return DropdownMenuItem<String>(
                            value: optionValue,
                            child: Text(optionValue,
                                style: textStyles.mediumNormal),
                          );
                        }).toList(),
                        onChanged: (a) {
                          setState(() {
                            userResponse = a!;
                            submitted = true;
                          });
                        },
                        focusNode: _focusNode,
                      ),
                    ),
                    if (isDropdownOpen)
                      SizedBox(height: model.options.length * 40),
                  ],
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: containerWidth,
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: colors.borderColorSecondary),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(value, style: textStyles.mediumNormal),
                ),
              ),
      ],
    );
  }
}
