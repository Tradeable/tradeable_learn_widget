import 'package:flutter/material.dart';
import 'package:fin_chart/option_chain/models/column_config.dart';

class ColumnVisibilityEditor extends StatefulWidget {
  final List<ColumnConfig> columns;
  final Function(List<ColumnConfig> updatedColumns) onVisibilityChanged;

  const ColumnVisibilityEditor({
    super.key,
    required this.columns,
    required this.onVisibilityChanged,
  });

  @override
  State<ColumnVisibilityEditor> createState() => _ColumnVisibilityEditorState();
}

class _ColumnVisibilityEditorState extends State<ColumnVisibilityEditor> {
  late List<ColumnConfig> _allColumns;

  final List<String> greeks = ['Delta', 'Gamma', 'Vega', 'Theta', 'IV'];
  final List<String> others = ['OI', 'LTP', 'Volume'];

  final Map<String, List<ColumnConfig>> _greekColumns = {};
  final Map<String, List<ColumnConfig>> _otherColumns = {};

  @override
  void initState() {
    super.initState();
    _allColumns =
        widget.columns.where((c) => c.columnType != ColumnType.strike).toList();
    _groupColumns();
  }

  void _groupColumns() {
    _greekColumns.clear();
    _otherColumns.clear();

    for (var greek in greeks) {
      _greekColumns[greek] =
          _allColumns.where((c) => c.columnTitle == greek).toList();
    }

    for (var other in others) {
      _otherColumns[other] =
          _allColumns.where((c) => c.columnTitle == other).toList();
    }
  }

  void _toggleGroupVisibility(
      Map<String, List<ColumnConfig>> group, String groupName, bool isVisible) {
    setState(() {
      if (group.containsKey(groupName)) {
        for (var column in group[groupName]!) {
          column.isColumnVisible = isVisible;
        }
        widget.onVisibilityChanged(widget.columns);
      }
    });
  }

  bool _isGroupAllVisible(
      Map<String, List<ColumnConfig>> group, String groupName) {
    if (!group.containsKey(groupName)) return false;
    return group[groupName]!.every((c) => c.isColumnVisible);
  }

  bool _isGroupAllHidden(
      Map<String, List<ColumnConfig>> group, String groupName) {
    if (!group.containsKey(groupName)) return false;
    return group[groupName]!.every((c) => !c.isColumnVisible);
  }

  Widget _buildGroup(String title, Map<String, List<ColumnConfig>> group) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
          child: Text(title,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),
        ...group.entries.where((e) => e.value.isNotEmpty).map((entry) {
          final groupName = entry.key;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Text(groupName,
                    style: const TextStyle(fontWeight: FontWeight.w500)),
                const Spacer(),
                Switch(
                  value: _isGroupAllVisible(group, groupName),
                  onChanged: (value) =>
                      _toggleGroupVisibility(group, groupName, value),
                  activeColor: _isGroupAllHidden(group, groupName)
                      ? Colors.grey
                      : Theme.of(context).colorScheme.primary,
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Column Visibility',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          _buildGroup('Greeks', _greekColumns),
          const Divider(),
          _buildGroup('Others', _otherColumns),
          const SizedBox(height: 20)
        ],
      ),
    );
  }
}
