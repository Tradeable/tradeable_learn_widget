import 'package:tradeable_learn_widget/tradeable_learn_widget.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:tradeable_learn_widget/dynamic_chart/dynamic_chart_model.dart';

class SahiChartInputScreen extends StatefulWidget {
  const SahiChartInputScreen({super.key});

  @override
  State<SahiChartInputScreen> createState() => _SahiChartInputScreenState();
}

class _SahiChartInputScreenState extends State<SahiChartInputScreen> {
  final TextEditingController _jsonController = TextEditingController();
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter Chart JSON'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: TextField(
                  controller: _jsonController,
                  maxLines: null,
                  expands: true,
                  decoration: InputDecoration(
                    hintText: 'Paste your JSON here...',
                    border: const OutlineInputBorder(),
                    errorText: _errorMessage,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _validateAndNavigate,
                child: const Text('Generate Chart'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _validateAndNavigate() {
    try {
      final jsonString = _jsonController.text.trim();

      if (jsonString.isEmpty) {
        setState(() {
          _errorMessage = 'Please enter JSON data';
        });
        return;
      }

      final jsonData = jsonDecode(jsonString);

      if (jsonData == null) {
        setState(() {
          _errorMessage = 'Invalid JSON: null value';
        });
        return;
      }

      if (jsonData is! Map<String, dynamic>) {
        setState(() {
          _errorMessage =
              'JSON must be an object (map). Received: ${jsonData.runtimeType}';
        });
        return;
      }

      final wrappedData =
          jsonData.containsKey('recipe') ? jsonData : {'recipe': jsonData};

      final model = DynamicChartModel.fromJson(wrappedData);

      if (!mounted) return;
      setState(() {
        _errorMessage = null;
      });

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => SahiChartScreen(model: model),
        ),
      );
    } on FormatException catch (e) {
      setState(() {
        _errorMessage = 'Invalid JSON format: ${e.message}';
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error: ${e.toString()}';
      });
    }
  }

  @override
  void dispose() {
    _jsonController.dispose();
    super.dispose();
  }
}
