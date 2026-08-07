import 'package:flutter/material.dart';
import 'package:markdown_widget/markdown_widget.dart';

final markdownConfig = MarkdownConfig(
  configs: [
    PConfig(
      textStyle: const TextStyle(
        fontSize: 16,
        height: 1.5,
      ),
    ),
    H1Config(
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        height: 1.3,
      ),
    ),
    H2Config(
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        height: 1.35,
      ),
    ),
    H3Config(
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        height: 1.4,
      ),
    ),
    PreConfig(
      textStyle: const TextStyle(
        fontSize: 14,
        fontFamily: 'monospace',
        height: 1.5,
      ),
    ),
  ],
);

final promptConfig = MarkdownConfig(
  configs: [
    PConfig(
      textStyle: const TextStyle(
        fontSize: 14,
        height: 1.5,
      ),
    ),
    H1Config(
      style: const TextStyle(
        fontSize: 19,
        fontWeight: FontWeight.bold,
        height: 1.3,
      ),
    ),
    H2Config(
      style: const TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.bold,
        height: 1.35,
      ),
    ),
    H3Config(
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.bold,
        height: 1.4,
      ),
    ),
    PreConfig(
      textStyle: const TextStyle(
        fontSize: 13,
        fontFamily: 'monospace',
        height: 1.5,
      ),
    ),
  ],
);


final coreConceptConfig = MarkdownConfig(
  configs: [
    PConfig(
      textStyle: const TextStyle(
        fontSize: 13,
        height: 1.5,
      ),
    ),
    H1Config(
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        height: 1.3,
      ),
    ),
    H2Config(
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        height: 1.35,
      ),
    ),
    H3Config(
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        height: 1.4,
      ),
    ),
    PreConfig(
      textStyle: const TextStyle(
        fontSize: 13,
        fontFamily: 'monospace',
        height: 1.5,
      ),
    ),
  ],
);
