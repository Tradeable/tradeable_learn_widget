import 'package:flutter/material.dart';
import 'package:tradeable_learn_widget/utils/theme.dart';

class FamilyPlotWidget extends StatefulWidget {
  const FamilyPlotWidget({super.key});

  @override
  State<FamilyPlotWidget> createState() => _FamilyPlotWidgetState();
}

class _FamilyPlotWidgetState extends State<FamilyPlotWidget> {
  List<Map<String, dynamic>> members = [
    {'name': TextEditingController(), 'value': TextEditingController()}
  ];

  List<Map<String, dynamic>> results = [];

  DateTime? fromDate;
  DateTime? toDate;
  TimeOfDay? fromTime;
  TimeOfDay? toTime;

  void _addRow() {
    setState(() {
      members.add({
        'name': TextEditingController(),
        'value': TextEditingController(),
      });
    });
  }

  Future<void> _selectDate(bool isFromDate, context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      final pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (isFromDate) {
        setState(() {
          fromDate = pickedDate;
          fromTime = pickedTime;
        });
      } else {
        setState(() {
          toDate = pickedDate;
          toTime = pickedTime;
        });
      }
    }
  }

  void _calculateResults() {
    if (members.any((m) => m['value'].text.isNotEmpty)) {
      setState(() {
        results = members
            .where((m) => m['value'].text.isNotEmpty)
            .map((m) => {
                  'name': m['name'].text,
                  'value': double.parse(m['value'].text) * 1.2,
                })
            .toList();
      });
    } else {
      setState(() {
        results = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).customTextStyles;
    final colors = Theme.of(context).customColors;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Text(
              "Family Plot",
              style: textStyles.largeBold,
            ),
          ),
          const SizedBox(height: 20),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: members.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        color: colors.cardColorSecondary,
                        child: TextField(
                          controller: members[index]['name'],
                          decoration: const InputDecoration(
                              labelText: 'Member Name',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.zero)),
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        controller: members[index]['value'],
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                            labelText: 'Value',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.zero)),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
                shape: BoxShape.circle, color: colors.borderColorSecondary),
            child: IconButton(
                icon: Icon(Icons.add, color: colors.axisColor, size: 20),
                onPressed: _addRow),
          ),
          const SizedBox(height: 60),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100,
                height: 40,
                decoration: BoxDecoration(
                    color: colors.cardColorPrimary,
                    border: Border.all(color: colors.borderColorSecondary)),
                child:
                    Center(child: Text("From", style: textStyles.mediumNormal)),
              ),
              Container(
                width: 100,
                height: 40,
                decoration: BoxDecoration(
                    color: colors.cardColorPrimary,
                    border: Border.all(color: colors.borderColorSecondary)),
                child: Center(
                  child: Text(
                    "To",
                    style: textStyles.mediumNormal,
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () => _selectDate(true, context),
                child: Container(
                  width: 160,
                  height: 40,
                  decoration: BoxDecoration(
                      border: Border.all(color: colors.borderColorSecondary)),
                  child: Center(
                    child: Text(
                      fromDate != null && fromTime != null
                          ? "${fromDate!.day}/${fromDate!.month}/${fromDate!.year} ${fromTime!.format(context)}"
                          : "-",
                      style: textStyles.smallNormal,
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => _selectDate(false, context),
                child: Container(
                  width: 160,
                  height: 40,
                  decoration: BoxDecoration(
                      border: Border.all(color: colors.borderColorSecondary)),
                  child: Center(
                    child: Text(
                      toDate != null && toTime != null
                          ? "${toDate!.day}/${toDate!.month}/${toDate!.year} ${toTime!.format(context)}"
                          : "-",
                      style: textStyles.smallNormal,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: ElevatedButton(
              onPressed: _calculateResults,
              child: const Text("Calculate"),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child: Divider(),
          ),
          Text(
            "Results",
            style: textStyles.largeBold,
          ),
          const SizedBox(height: 20),
          results.isNotEmpty
              ? ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: results.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 40,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: colors.borderColorSecondary),
                                  color: colors.cardColorSecondary),
                              child: Center(
                                child: Text(
                                  results[index]['name'],
                                  style: textStyles.smallNormal,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              height: 40,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: colors.borderColorSecondary),
                                  color: colors.cardColorSecondary),
                              child: Center(
                                child: Text(
                                  results[index]['value'].toString(),
                                  style: textStyles.smallNormal,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                )
              : Center(
                  child: Text(
                    "No values entered",
                    style: textStyles.mediumNormal,
                  ),
                ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
