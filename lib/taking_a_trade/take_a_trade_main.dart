import 'package:flutter/material.dart';

class TakeATradeMain extends StatefulWidget {
  final Map<String, dynamic> workflowJson;

  const TakeATradeMain({super.key, required this.workflowJson});

  @override
  _TakeATradeMainState createState() => _TakeATradeMainState();
}

class _TakeATradeMainState extends State<TakeATradeMain> {
  late List<Map<String, dynamic>> displayedSteps;
  late Map<String, dynamic> animatedTextStep;
  final TextEditingController _targetPriceController = TextEditingController();
  final TextEditingController _stopLossPriceController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    displayedSteps = [];

    // Find and add initial skippable steps
    for (var step in widget.workflowJson['steps']) {
      if (step['isSkippable'] == true) {
        displayedSteps.add(step);
        if (step['stepId'] == '1') {
          // Store the first animated text step
          animatedTextStep = step;
        }
        if (step['stepId'] == '2') break;
      }
    }

    // Add buttons step
    var buttonsStep = widget.workflowJson['steps']
        .firstWhere((step) => step['stepId'] == '3');
    displayedSteps.add(buttonsStep);
  }

  void _handleWaitAndWatchButton() {
    // Find the dialog step
    var dialogStep = widget.workflowJson['steps']
        .firstWhere((step) => step['stepId'] == '4');

    // Show dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(dialogStep['ui']['title']),
          content: Text(dialogStep['ui']['message']),
          actions: dialogStep['ui']['options'].map<Widget>((option) {
            return TextButton(
              child: Text(option['label']),
              onPressed: () {
                Navigator.of(context).pop();
                _handleDialogAction(option);
              },
            );
          }).toList(),
        );
      },
    );
  }

  void _handleDialogAction(Map<String, dynamic> option) {
    // Find the next step based on the selected option
    var nextStep = widget.workflowJson['steps']
        .firstWhere((step) => step['stepId'] == option['nextStepId']);

    // Update the existing animated text step
    setState(() {
      animatedTextStep = nextStep;
    });
  }

  void _handleTakeTradeButton() {
    // Find the text fields step
    var textFieldsStep = widget.workflowJson['steps']
        .firstWhere((step) => step['stepId'] == '5');

    // Show bottom sheet with text fields
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _targetPriceController,
                decoration: InputDecoration(
                  labelText: 'Target Price',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16),
              TextField(
                controller: _stopLossPriceController,
                decoration: InputDecoration(
                  labelText: 'Stop Loss Price',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _handleTextFieldSubmit();
                },
                child: Text('Submit'),
              )
            ],
          ),
        );
      },
    );
  }

  void _handleTextFieldSubmit() {
    // Find the final animated text step
    var finalStep = widget.workflowJson['steps']
        .firstWhere((step) => step['stepId'] == '6');

    // Update the existing animated text step
    setState(() {
      animatedTextStep = finalStep;
    });
  }

  Widget _buildButtons() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: _handleWaitAndWatchButton,
          child: Text('Wait and Watch'),
        ),
        SizedBox(height: 16),
        ElevatedButton(
          onPressed: _handleTakeTradeButton,
          child: Text('Set Target and Stop Loss'),
        ),
      ],
    );
  }

  Widget _buildAnimatedText() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Text(
        animatedTextStep['ui']['prompt'],
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildContainer() {
    var containerStep = displayedSteps
        .firstWhere((step) => step['ui']['widget'] == 'Container');
    return Container(
      height: containerStep['ui']['containerStyle']['height'].toDouble(),
      width: containerStep['ui']['containerStyle']['width'].toDouble(),
      color: Colors.grey[300],
      child: Center(
        child: Text(
          containerStep['ui']['title'],
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.workflowJson['name']),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildAnimatedText(),
            _buildContainer(),
            _buildButtons(),
          ],
        ),
      ),
    );
  }
}
