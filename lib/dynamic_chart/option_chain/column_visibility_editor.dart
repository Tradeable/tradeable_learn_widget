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
  final Map<String, List<ColumnConfig>> _columnGroups = {};

  @override
  void initState() {
    super.initState();
    _allColumns =
        widget.columns.where((c) => c.columnType != ColumnType.strike).toList();
    _groupColumns();
  }

  void _groupColumns() {
    _columnGroups.clear();
    for (ColumnConfig column in _allColumns) {
      String groupName;
      if (column.columnType.name.startsWith('call')) {
        groupName = 'Call';
      } else if (column.columnType.name.startsWith('put')) {
        groupName = 'Put';
      } else {
        groupName = 'Other';
      }
      _columnGroups.putIfAbsent(groupName, () => []).add(column);
    }
  }

  void _toggleColumnVisibility(ColumnConfig column, bool isVisible) {
    setState(() {
      column.isColumnVisible = isVisible;
      widget.onVisibilityChanged(widget.columns);
    });
  }

  void _toggleGroupVisibility(String groupName, bool isVisible) {
    setState(() {
      if (_columnGroups.containsKey(groupName)) {
        for (var column in _columnGroups[groupName]!) {
          column.isColumnVisible = isVisible;
        }
        widget.onVisibilityChanged(widget.columns);
      }
    });
  }

  bool _isGroupAllVisible(String groupName) {
    if (!_columnGroups.containsKey(groupName)) return false;
    return _columnGroups[groupName]!.every((c) => c.isColumnVisible);
  }

  bool _isGroupAllHidden(String groupName) {
    if (!_columnGroups.containsKey(groupName)) return false;
    return _columnGroups[groupName]!.every((c) => !c.isColumnVisible);
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
          ..._columnGroups.entries.map((entry) {
            final groupName = entry.key;
            final columns = entry.value;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      Text(
                        groupName,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      const Spacer(),
                      Switch(
                        value: _isGroupAllVisible(groupName),
                        onChanged: (value) =>
                            _toggleGroupVisibility(groupName, value),
                        activeColor: _isGroupAllHidden(groupName)
                            ? Colors.grey
                            : Theme.of(context).colorScheme.primary,
                      ),
                    ],
                  ),
                ),
                ...columns.map((column) {
                  return CheckboxListTile(
                    title: Text(column.columnTitle),
                    value: column.isColumnVisible,
                    onChanged: (value) =>
                        _toggleColumnVisibility(column, value ?? false),
                    secondary: column.isColumnVisible
                        ? const Icon(Icons.visibility, color: Colors.blue)
                        : const Icon(Icons.visibility_off, color: Colors.grey),
                  );
                }),
                const Divider(height: 1),
              ],
            );
          }).toList(),
        ],
      ),
    );
  }
}
