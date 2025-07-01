class TableRowSelection {
  final Map<int, Set<int>> selectedRows = {};

  bool get hasSelection => selectedRows.values.any((set) => set.isNotEmpty);

  void toggle(int tableIdx, int rowIdx) {
    final set = selectedRows.putIfAbsent(tableIdx, () => <int>{});
    if (set.contains(rowIdx)) {
      set.remove(rowIdx);
    } else {
      set.add(rowIdx);
    }
  }

  void clear() {
    selectedRows.clear();
  }
}
