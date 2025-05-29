import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  // final String subtitle;
  final bool enabled;
  final VoidCallback? onIncrement;
  final VoidCallback? onDecrement;
  final TextInputType keyboardType;
  final String? suffix;
  final Function(String)? onChanged;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    // required this.subtitle,
    this.enabled = true,
    this.onIncrement,
    this.onDecrement,
    this.keyboardType = TextInputType.number,
    this.suffix,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 2),
        decoration: BoxDecoration(
          color: const Color(0xFF395046),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            if (onDecrement != null)
              IconButton(
                padding: const EdgeInsets.all(0),
                color: const Color(0xFFD3CABD),
                icon: const Icon(Icons.remove),
                iconSize: 32,
                onPressed: enabled ? onDecrement : null,
              ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 2, vertical: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2BC381),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: TextField(
                            controller: controller,
                            textAlign: TextAlign.center,
                            keyboardType: keyboardType,
                            enabled: enabled,
                            readOnly: !enabled, // Add this line
                            onChanged: onChanged,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors
                                  .white, // Force black text when disabled
                            ),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                              fillColor: enabled
                                  ? null
                                  : const Color(
                                      0xFF2BC381), // Keep white background
                              filled: !enabled, // Fill with white when disabled
                            ),
                          ),
                        ),
                      ),
                      if (suffix != null)
                        Text(
                          suffix!,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            if (onIncrement != null)
              IconButton(
                padding: const EdgeInsets.all(0),
                color: const Color(0xFFD3CABD),
                icon: const Icon(Icons.add),
                iconSize: 32,
                onPressed: enabled ? onIncrement : null,
              ),
          ],
        ),
      ),
    );
  }
}
