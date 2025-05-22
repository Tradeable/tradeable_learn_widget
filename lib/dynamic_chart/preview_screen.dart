import 'package:auto_size_text/auto_size_text.dart';
import 'package:fin_chart/models/tasks/add_option_chain.task.dart';
import 'package:fin_chart/option_chain/models/column_config.dart';
import 'package:fin_chart/option_chain/models/option_data.dart';
import 'package:fin_chart/option_chain/models/preview_data.dart';
import 'package:fin_chart/option_chain/utils/data_transformer.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tradeable_learn_widget/dynamic_chart/option_chain/option_chain_container.dart';
import 'package:tradeable_learn_widget/dynamic_chart/option_chain/option_chain_header.dart';
import 'package:tradeable_learn_widget/tlw.dart';
import 'package:tradeable_learn_widget/utils/theme.dart';

class PreviewScreen extends StatefulWidget {
  final PreviewData previewData;
  final VoidCallback onViewChartClicked;
  final VoidCallback onSettingsClicked;
  final Function(int rowIndex, bool isCallSide)? onBuySellSelected;

  const PreviewScreen({
    super.key,
    required this.previewData,
    required this.onViewChartClicked,
    required this.onSettingsClicked,
    this.onBuySellSelected,
  });

  factory PreviewScreen.from(
      {required GlobalKey key,
      required AddOptionChainTask task,
      List<int>? selectedRowIndex,
      List<int>? correctRowIndex,
      Function(int rowIndex, bool isCallSide)? onBuySellSelected,
      required bool isEditorMode,
      required VoidCallback onViewChartClicked,
      required VoidCallback onSettingsClicked}) {
    return PreviewScreen(
      key: key,
      previewData: PreviewData(
          strikePrice: task.strikePrice,
          expiryDate: task.expiryDate,
          optionData: task.data,
          columns: task.columns.where((c) => c.isColumnVisible).toList(),
          visibility: task.visibility,
          settings: task.settings,
          selectedRowIndices: selectedRowIndex ?? [],
          correctRowIndices: correctRowIndex ?? [],
          isEditorMode: isEditorMode),
      onBuySellSelected: onBuySellSelected,
      onViewChartClicked: onViewChartClicked,
      onSettingsClicked: onSettingsClicked,
    );
  }

  @override
  State<PreviewScreen> createState() => PreviewScreenState();
}

class PreviewScreenState extends State<PreviewScreen> {
  static const double cellHeight = 55;
  static const double cellWidth = 75;
  List<int> _selectedRowIndex = [];
  bool _isChecked = false;
  List<int> userSelectedIndex = [];
  final ScrollController _leftScrollController = ScrollController();
  final ScrollController _rightScrollController = ScrollController();
  bool _isScrolling = false;
  List<Map<int, int>> correctBucketIndexes = [];
  Map<int, bool> bucketSelections = {};
  Map<int, bool> bucketCallSelections = {};
  Map<int, bool> bucketPutSelections = {};

  @override
  void initState() {
    super.initState();
    _selectedRowIndex = List.from(widget.previewData.selectedRowIndices);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setupScrollSync();
    });
  }

  @override
  void dispose() {
    _leftScrollController.dispose();
    _rightScrollController.dispose();
    super.dispose();
  }

  void _setupScrollSync() {
    _leftScrollController.addListener(() {
      if (!_isScrolling && _rightScrollController.hasClients) {
        _isScrolling = true;
        _rightScrollController.jumpTo(_leftScrollController.offset);
        _isScrolling = false;
      }
    });

    _rightScrollController.addListener(() {
      if (!_isScrolling && _leftScrollController.hasClients) {
        _isScrolling = true;
        _leftScrollController.jumpTo(_rightScrollController.offset);
        _isScrolling = false;
      }
    });
  }

  void chooseBucketRows(List<Map<int, int>> bucketRows) {
    setState(() {
      correctBucketIndexes = bucketRows;
      for (var bucketRow in bucketRows) {
        final rowIndex = bucketRow.keys.first;
        final side = bucketRow.values.first;

        if (side == 0) {
          bucketCallSelections[rowIndex] = true;
        } else {
          bucketPutSelections[rowIndex] = true;
        }
        bucketSelections[rowIndex] = true;
      }
      _isChecked = true;
    });
  }

  List<int>? getCorrectRowIndex() {
    final selectionMode =
        widget.previewData.settings?.selectionMode ?? SelectionMode.entireRow;
    if (selectionMode == SelectionMode.bucketRow) {
      return bucketSelections.entries
          .where((entry) => entry.value)
          .map((entry) => entry.key)
          .toList();
    }
    return _selectedRowIndex;
  }

  List<Map<int, int>>? getBucketRows() {
    final selectionMode =
        widget.previewData.settings?.selectionMode ?? SelectionMode.entireRow;
    if (selectionMode == SelectionMode.bucketRow) {
      List<Map<int, int>> bucketRows = [];
      bucketCallSelections.forEach((rowIndex, isSelected) {
        if (isSelected) {
          bucketRows.add({rowIndex: 0});
        }
      });
      bucketPutSelections.forEach((rowIndex, isSelected) {
        if (isSelected) {
          bucketRows.add({rowIndex: 1});
        }
      });
      return bucketRows;
    }
    return null;
  }

  List<ColumnConfig> _getFilteredColumns({bool isLeftSide = false}) {
    final columns = widget.previewData.columns
        .where((column) =>
            column.isColumnVisible && column.columnType != ColumnType.strike)
        .toList();

    switch (widget.previewData.visibility) {
      case OptionChainVisibility.call:
        return columns
            .where((column) =>
                !column.columnType.name.toLowerCase().contains("put"))
            .toList();
      case OptionChainVisibility.put:
        return columns
            .where((column) =>
                !column.columnType.name.toLowerCase().contains("call"))
            .toList();
      case OptionChainVisibility.both:
        if (isLeftSide) {
          return columns.reversed
              .where((column) =>
                  column.columnType.name.toLowerCase().contains("call"))
              .toList();
        } else {
          return columns
              .where((column) =>
                  column.columnType.name.toLowerCase().contains("put"))
              .toList();
        }
    }
  }

  Widget _buildTableBasedOnVisibility() {
    switch (widget.previewData.visibility) {
      case OptionChainVisibility.call:
        final columns = _getFilteredColumns();
        return Stack(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              controller: _leftScrollController,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...columns.map(
                      (column) => _buildColumn(column, _leftScrollController)),
                  const SizedBox(width: cellWidth), // Placeholder for strike column
                ],
              ),
            ),
            Positioned(
              right: 0,
              child: Container(
                color: Theme.of(context).scaffoldBackgroundColor,
                child: _buildStickyStrikeColumn(),
              ),
            ),
          ],
        );
      case OptionChainVisibility.put:
        final columns = _getFilteredColumns();
        return Stack(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              controller: _rightScrollController,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(width: cellWidth), // Placeholder for strike column
                  ...columns.map(
                      (column) => _buildColumn(column, _rightScrollController)),
                ],
              ),
            ),
            Positioned(
              left: 0,
              child: Container(
                color: Theme.of(context).scaffoldBackgroundColor,
                child: _buildStickyStrikeColumn(),
              ),
            ),
          ],
        );
      case OptionChainVisibility.both:
        final leftColumns = _getFilteredColumns(isLeftSide: true);
        final rightColumns = _getFilteredColumns(isLeftSide: false);

        return LayoutBuilder(
          builder: (context, constraints) {
            final screenWidth = constraints.maxWidth;
            final centerPosition = (screenWidth - cellWidth) / 2;

            // Calculate minimum width needed for columns
            final leftWidth = leftColumns.length * cellWidth;
            final rightWidth = rightColumns.length * cellWidth;
            final minTotalWidth = leftWidth + rightWidth + cellWidth;

            // If total width is less than screen width, center the entire content
            if (minTotalWidth <= screenWidth) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...leftColumns.map(
                      (column) => _buildColumn(column, _leftScrollController)),
                  _buildStickyStrikeColumn(),
                  ...rightColumns.map(
                      (column) => _buildColumn(column, _rightScrollController)),
                ],
              );
            }

            // Otherwise use the scrollable layout
            return Stack(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: centerPosition,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        controller: _leftScrollController,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: leftColumns
                              .map((column) =>
                                  _buildColumn(column, _leftScrollController))
                              .toList(),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: cellWidth,
                      child: _buildStickyStrikeColumn(),
                    ),
                    SizedBox(
                      width: centerPosition,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        controller: _rightScrollController,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: rightColumns
                              .map((column) =>
                                  _buildColumn(column, _rightScrollController))
                              .toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        );
    }
  }

  Widget _buildColumn(ColumnConfig column, ScrollController controller) {
    final colors =
        TLW().themeData?.customColors ?? Theme.of(context).customColors;
    final textStyles =
        TLW().themeData?.customTextStyles ?? Theme.of(context).customTextStyles;

    return SizedBox(
      width: cellWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 56,
            padding: const EdgeInsets.all(2),
            color: colors.headerColumnColor,
            alignment: Alignment.center,
            child: AutoSizeText(
              column.columnTitle,
              style: textStyles.smallNormal,
              minFontSize: 10,
              maxFontSize: 14,
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: widget.previewData.optionData.length * cellHeight,
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.previewData.optionData.length,
              itemBuilder: (context, rowIndex) {
                final data = widget.previewData.optionData[rowIndex];
                final actualColumnIndex =
                    widget.previewData.columns.indexOf(column);
                final strikeColumnIndex = _getStrikeColumnIndex();
                return SizedBox(
                  height: cellHeight,
                  child: _buildCell(
                    rowIndex: rowIndex,
                    data: data,
                    column: column,
                    actualColumnIndex: actualColumnIndex,
                    strikeColumnIndex: strikeColumnIndex,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCell({
    required int rowIndex,
    required OptionData data,
    required ColumnConfig column,
    required int actualColumnIndex,
    required int? strikeColumnIndex,
  }) {
    final colors =
        TLW().themeData?.customColors ?? Theme.of(context).customColors;
    final strikePrice = widget.previewData.strikePrice;
    final currentRowStrike = data.strike;
    final selectionMode =
        widget.previewData.settings?.selectionMode ?? SelectionMode.entireRow;

    Color? cellColor = _getCellColor(
      rowIndex: rowIndex,
      actualColumnIndex: actualColumnIndex,
      strikeColumnIndex: strikeColumnIndex,
      strikePrice: strikePrice,
      currentRowStrike: currentRowStrike,
      selectionMode: selectionMode,
    );

    bool isSelectable = _isCellSelectable(
      actualColumnIndex: actualColumnIndex,
      strikeColumnIndex: strikeColumnIndex,
      selectionMode: selectionMode,
    );

    return Center(
      child: Container(
        width: cellWidth,
        decoration: BoxDecoration(
          color: cellColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: colors.optionChainStrokeColor, width: 1.8),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: isSelectable
              ? () {
                  if (selectionMode == SelectionMode.bucketRow) {
                    _handleBucketCellTap(
                        rowIndex, actualColumnIndex, strikeColumnIndex);
                  } else {
                    _handleCellTap(rowIndex);
                  }
                }
              : null,
          child: Center(
            child: _buildCellContent(rowIndex, data, column.columnType),
          ),
        ),
      ),
    );
  }

  Color? _getCellColor({
    required int rowIndex,
    required int actualColumnIndex,
    required int? strikeColumnIndex,
    required double? strikePrice,
    required double currentRowStrike,
    required SelectionMode selectionMode,
  }) {
    final colors =
        TLW().themeData?.customColors ?? Theme.of(context).customColors;

    Color? cellColor;

    if (strikePrice != null && strikeColumnIndex != null) {
      if (currentRowStrike < strikePrice &&
          actualColumnIndex < strikeColumnIndex) {
        cellColor = colors.selectedRowColor.withAlpha((0.1 * 255).round());
      } else if (currentRowStrike > strikePrice &&
          actualColumnIndex > strikeColumnIndex) {
        cellColor = colors.incorrectRowColor.withAlpha((0.1 * 255).round());
      }
    }

    if (selectionMode == SelectionMode.bucketRow) {
      if (!_isChecked) {
        if (bucketSelections.containsKey(rowIndex) &&
            strikeColumnIndex != null) {
          if (actualColumnIndex < strikeColumnIndex &&
              bucketCallSelections.containsKey(rowIndex)) {
            cellColor = colors.selectedRowColor.withAlpha((0.4 * 255).round());
          } else if (actualColumnIndex > strikeColumnIndex &&
              bucketPutSelections.containsKey(rowIndex)) {
            cellColor = colors.selectedRowColor.withAlpha((0.4 * 255).round());
          }
        }
      } else {
        bool isCorrect = false;
        for (var correct in correctBucketIndexes) {
          if (correct.containsKey(rowIndex)) {
            final correctSide = correct[rowIndex];
            if (strikeColumnIndex != null) {
              if (actualColumnIndex < strikeColumnIndex &&
                  correctSide == 0 &&
                  bucketCallSelections.containsKey(rowIndex)) {
                isCorrect = true;
              } else if (actualColumnIndex > strikeColumnIndex &&
                  correctSide == 1 &&
                  bucketPutSelections.containsKey(rowIndex)) {
                isCorrect = true;
              }
            }
            break;
          }
        }

        if (strikeColumnIndex != null) {
          if (actualColumnIndex < strikeColumnIndex &&
              bucketCallSelections.containsKey(rowIndex)) {
            cellColor = isCorrect
                ? colors.correctRowColor.withAlpha((0.4 * 255).round())
                : colors.incorrectRowColor.withAlpha((0.4 * 255).round());
          } else if (actualColumnIndex > strikeColumnIndex &&
              bucketPutSelections.containsKey(rowIndex)) {
            cellColor = isCorrect
                ? colors.correctRowColor.withAlpha((0.4 * 255).round())
                : colors.incorrectRowColor.withAlpha((0.4 * 255).round());
          }
        }
      }
    } else if (_selectedRowIndex.contains(rowIndex) ||
        userSelectedIndex.contains(rowIndex)) {
      bool shouldHighlight = false;
      if (selectionMode == SelectionMode.callOnly) {
        shouldHighlight =
            strikeColumnIndex != null && actualColumnIndex <= strikeColumnIndex;
      } else if (selectionMode == SelectionMode.putOnly) {
        shouldHighlight =
            strikeColumnIndex != null && actualColumnIndex >= strikeColumnIndex;
      } else {
        shouldHighlight = true;
      }
      if (shouldHighlight) {
        if (userSelectedIndex.contains(rowIndex)) {
          cellColor = colors.correctRowColor.withAlpha((0.2 * 255).round());
        } else if (_selectedRowIndex.contains(rowIndex)) {
          if (_isChecked &&
              !widget.previewData.correctRowIndices.contains(rowIndex)) {
            cellColor = colors.incorrectRowColor.withAlpha((0.2 * 255).round());
          } else {
            cellColor = colors.selectedRowColor.withAlpha((0.2 * 255).round());
          }
        }
      }
    }

    return cellColor;
  }

  bool _isCellSelectable({
    required int actualColumnIndex,
    required int? strikeColumnIndex,
    required SelectionMode selectionMode,
  }) {
    switch (selectionMode) {
      case SelectionMode.callOnly:
        return strikeColumnIndex != null &&
            actualColumnIndex <= strikeColumnIndex;
      case SelectionMode.putOnly:
        return strikeColumnIndex != null &&
            actualColumnIndex >= strikeColumnIndex;
      case SelectionMode.entireRow:
        return true;
      case SelectionMode.bucketRow:
        return strikeColumnIndex != null &&
            actualColumnIndex != strikeColumnIndex;
    }
  }

  void chooseRow(int rowIndex) {
    setState(() {
      final maxSelectedRows =
          widget.previewData.settings?.maxSelectableRows ?? 0;
      if (maxSelectedRows == 1) {
        userSelectedIndex = [rowIndex];
      } else if (maxSelectedRows > 1) {
        if (userSelectedIndex.contains(rowIndex)) {
          userSelectedIndex.remove(rowIndex);
        } else if (userSelectedIndex.length < maxSelectedRows) {
          userSelectedIndex.add(rowIndex);
        }
      } else {
        if (!userSelectedIndex.contains(rowIndex)) {
          userSelectedIndex.add(rowIndex);
        }
      }
      _isChecked = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return OptionChainContainer(
      child: Column(
        children: [
          OptionChainHeader(
            onViewChartClicked: () => widget.onViewChartClicked(),
            onSettingsClicked: () => widget.onSettingsClicked(),
            expiry: DateFormat('dd MMM')
                .format(widget.previewData.expiryDate ?? DateTime.now()),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: SizedBox(
                height: widget.previewData.optionData.length * cellHeight + 56,
                child: _buildTableBasedOnVisibility(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStickyStrikeColumn() {
    final colors =
        TLW().themeData?.customColors ?? Theme.of(context).customColors;
    final textStyles =
        TLW().themeData?.customTextStyles ?? Theme.of(context).customTextStyles;

    final strikeColumn = widget.previewData.columns.firstWhere(
        (column) => column.columnType == ColumnType.strike,
        orElse: () => throw Exception("Strike column not found"));

    return Container(
      width: cellWidth,
      decoration: BoxDecoration(color: colors.strikePriceColumnColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 56,
            padding: const EdgeInsets.all(2),
            color: colors.strikePriceHeaderColor,
            alignment: Alignment.center,
            child: AutoSizeText(
              strikeColumn.columnTitle,
              style: textStyles.smallNormal,
              minFontSize: 10,
              maxFontSize: 14,
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: widget.previewData.optionData.length * cellHeight,
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: widget.previewData.optionData.length,
              itemBuilder: (context, rowIndex) {
                final data = widget.previewData.optionData[rowIndex];
                final cellContent =
                    _buildCellContent(rowIndex, data, ColumnType.strike);
                final colors = TLW().themeData?.customColors ??
                    Theme.of(context).customColors;

                Color? cellColor;
                if (_selectedRowIndex.contains(rowIndex) ||
                    userSelectedIndex.contains(rowIndex)) {
                  if (userSelectedIndex.contains(rowIndex)) {
                    cellColor =
                        colors.correctRowColor.withAlpha((0.2 * 255).round());
                  } else if (_selectedRowIndex.contains(rowIndex)) {
                    if (_isChecked &&
                        !widget.previewData.correctRowIndices
                            .contains(rowIndex)) {
                      cellColor = colors.incorrectRowColor
                          .withAlpha((0.2 * 255).round());
                    } else {
                      cellColor = colors.selectedRowColor
                          .withAlpha((0.2 * 255).round());
                    }
                  }
                }

                return Container(
                  height: cellHeight,
                  alignment: Alignment.center,
                  child: Container(
                    width: cellWidth,
                    margin: const EdgeInsets.only(bottom: 2, left: 2),
                    decoration: BoxDecoration(
                      color: cellColor,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                          color: colors.optionChainStrokeColor, width: 1.8),
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(14),
                      onTap: () => _handleCellTap(rowIndex),
                      child: Center(child: cellContent),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCellContent(
      int rowIndex, OptionData data, ColumnType columnType) {
    final text = DataTransformer.getCellText(data, columnType);
    final textStyles =
        TLW().themeData?.customTextStyles ?? Theme.of(context).customTextStyles;
    final colors =
        TLW().themeData?.customColors ?? Theme.of(context).customColors;
    if (!widget.previewData.isEditorMode &&
        widget.previewData.settings?.isBuySellVisible == true &&
        (columnType == ColumnType.callPremium ||
            columnType == ColumnType.putPremium)) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(text, overflow: TextOverflow.ellipsis),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () => widget.onBuySellSelected?.call(rowIndex, true),
                child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 2, horizontal: 12),
                    decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(12)),
                    child: const Text('B', style: TextStyle(fontSize: 10))),
              ),
              const SizedBox(height: 6),
              InkWell(
                onTap: () => widget.onBuySellSelected?.call(rowIndex, false),
                child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 2, horizontal: 12),
                    decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(12)),
                    child: const Text('S', style: TextStyle(fontSize: 10))),
              ),
            ],
          ),
        ],
      );
    }
    return Text(
      text,
      overflow: TextOverflow.ellipsis,
      style: textStyles.mediumNormal.copyWith(
          fontSize: 16,
          color: columnType == ColumnType.strike
              ? colors.textColorSecondary
              : colors.axisColor),
    );
  }

  void _handleBucketCellTap(
      int rowIndex, int columnIndex, int? strikeColumnIndex) {
    if (strikeColumnIndex == null) return;

    setState(() {
      final maxSelectedRows =
          widget.previewData.settings?.maxSelectableRows ?? 0;

      if (columnIndex < strikeColumnIndex) {
        if (bucketCallSelections.containsKey(rowIndex)) {
          bucketCallSelections.remove(rowIndex);
          if (!bucketPutSelections.containsKey(rowIndex)) {
            bucketSelections.remove(rowIndex);
          }
        } else {
          if (maxSelectedRows == 1) {
            bucketCallSelections.clear();
            bucketPutSelections.clear();
            bucketSelections.clear();
            bucketCallSelections[rowIndex] = true;
            bucketSelections[rowIndex] = true;
          } else if (maxSelectedRows > 1) {
            if (bucketSelections.length < maxSelectedRows) {
              bucketCallSelections[rowIndex] = true;
              bucketSelections[rowIndex] = true;
            }
          } else {
            bucketCallSelections[rowIndex] = true;
            bucketSelections[rowIndex] = true;
          }
        }
      } else if (columnIndex > strikeColumnIndex) {
        if (bucketPutSelections.containsKey(rowIndex)) {
          bucketPutSelections.remove(rowIndex);
          if (!bucketCallSelections.containsKey(rowIndex)) {
            bucketSelections.remove(rowIndex);
          }
        } else {
          if (maxSelectedRows == 1) {
            bucketCallSelections.clear();
            bucketPutSelections.clear();
            bucketSelections.clear();
            bucketPutSelections[rowIndex] = true;
            bucketSelections[rowIndex] = true;
          } else if (maxSelectedRows > 1) {
            if (bucketSelections.length < maxSelectedRows) {
              bucketPutSelections[rowIndex] = true;
              bucketSelections[rowIndex] = true;
            }
          } else {
            bucketPutSelections[rowIndex] = true;
            bucketSelections[rowIndex] = true;
          }
        }
      }
      _isChecked = false;
    });
  }

  void _handleCellTap(int rowIndex) {
    setState(() {
      final selectionMode =
          widget.previewData.settings?.selectionMode ?? SelectionMode.entireRow;
      final maxSelectedRows =
          widget.previewData.settings?.maxSelectableRows ?? 0;

      if (selectionMode == SelectionMode.bucketRow) {
        return;
      }

      if (maxSelectedRows == 1) {
        if (_selectedRowIndex.contains(rowIndex)) {
          _selectedRowIndex.remove(rowIndex);
        } else {
          _selectedRowIndex = [rowIndex];
        }
      } else if (maxSelectedRows > 1) {
        if (_selectedRowIndex.contains(rowIndex)) {
          _selectedRowIndex.remove(rowIndex);
        } else if (_selectedRowIndex.length < maxSelectedRows) {
          _selectedRowIndex.add(rowIndex);
        }
      } else {
        if (_selectedRowIndex.contains(rowIndex)) {
          _selectedRowIndex.remove(rowIndex);
        } else {
          _selectedRowIndex.add(rowIndex);
        }
      }
      _isChecked = false;
    });
  }

  int? _getStrikeColumnIndex() {
    final visibleColumns =
        widget.previewData.columns.where((c) => c.isColumnVisible).toList();
    for (int i = 0; i < visibleColumns.length; i++) {
      if (visibleColumns[i].columnType == ColumnType.strike) {
        return i;
      }
    }
    return null;
  }
}
