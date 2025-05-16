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
  List<int> _selectedRowIndex = [];
  bool _isChecked = false;
  List<int> userSelectedIndex = [];
  final ScrollController _horizontalScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _selectedRowIndex = List.from(widget.previewData.selectedRowIndices);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToStrikePrice();
    });
  }

  @override
  void dispose() {
    _horizontalScrollController.dispose();
    super.dispose();
  }

  void _scrollToStrikePrice() {
    final strikeColumnIndex = _getStrikeColumnIndex();
    if (strikeColumnIndex != null) {
      final scrollPosition = strikeColumnIndex * 75.0;
      final screenWidth = MediaQuery.of(context).size.width;
      final centerPosition = scrollPosition - (screenWidth / 2) + 75;
      final scrollTo = centerPosition < 0 ? 0 : centerPosition;

      _horizontalScrollController.animateTo(
        scrollTo.toDouble(),
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOut,
      );
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

  List<int>? getCorrectRowIndex() => _selectedRowIndex;

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
          Expanded(child: _buildOptionsTable()),
        ],
      ),
    );
  }

  Widget _buildOptionsTable() {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        controller: _horizontalScrollController,
        child: Stack(
          children: [
            ..._buildBackgroundColumns(),
            DataTable(
              columnSpacing: 0,
              horizontalMargin: 0,
              dividerThickness: 0.01,
              dataRowMinHeight: 30,
              dataRowMaxHeight: 70,
              columns: _buildDataColumns(),
              rows: _buildDataRows(),
            ),
          ],
        ),
      ),
    );
  }

  List<DataColumn> _buildDataColumns() {
    final colors =
        TLW().themeData?.customColors ?? Theme.of(context).customColors;
    final textStyles =
        TLW().themeData?.customTextStyles ?? Theme.of(context).customTextStyles;

    return widget.previewData.columns
        .where((column) => column.isColumnVisible)
        .map((column) => DataColumn(
              label: Container(
                width: 75,
                color: column.columnType == ColumnType.strike
                    ? colors.strikePriceHeaderColor
                    : colors.headerColumnColor,
                alignment: Alignment.center,
                child: AutoSizeText(
                  column.columnTitle,
                  style: textStyles.smallNormal,
                  minFontSize: 10,
                  maxFontSize: 14,
                ),
              ),
            ))
        .toList();
  }

  List<Widget> _buildBackgroundColumns() {
    final colors =
        TLW().themeData?.customColors ?? Theme.of(context).customColors;

    double totalWidth = 0;
    List<Widget> columns = [];
    int strikeColumnIndex = -1;

    final visibleColumns = widget.previewData.columns
        .where((column) => column.isColumnVisible)
        .toList();

    for (int i = 0; i < visibleColumns.length; i++) {
      if (visibleColumns[i].columnType == ColumnType.strike) {
        strikeColumnIndex = i;
        break;
      }
      totalWidth += 76;
    }

    if (strikeColumnIndex >= 0) {
      columns.add(Positioned(
        left: totalWidth,
        top: 0,
        bottom: 0,
        width: 78,
        child: Container(color: colors.strikePriceColumnColor),
      ));
    }

    return columns;
  }

  List<DataRow> _buildDataRows() {
    final strikeColumnIndex = _getStrikeColumnIndex();
    return widget.previewData.optionData.asMap().entries.map((entry) {
      final rowIndex = entry.key;
      return DataRow(
        color: _getRowColor(rowIndex, strikeColumnIndex),
        cells: _buildRowCells(rowIndex, entry.value, strikeColumnIndex),
      );
    }).toList();
  }

  WidgetStateProperty<Color>? _getRowColor(
      int rowIndex, int? strikeColumnIndex) {
    final colors =
        TLW().themeData?.customColors ?? Theme.of(context).customColors;

    final selectionMode =
        widget.previewData.settings?.selectionMode ?? SelectionMode.entireRow;
    if (widget.previewData.visibility == OptionChainVisibility.both) {
      if (!_isChecked) {
        if (_selectedRowIndex.contains(rowIndex)) {
          if (selectionMode == SelectionMode.entireRow) {
            return WidgetStateProperty.all(
                colors.selectedRowColor.withAlpha((0.2 * 255).round()));
          }
        }
        return null;
      }
      if (userSelectedIndex.contains(rowIndex)) {
        if (selectionMode == SelectionMode.entireRow) {
          return WidgetStateProperty.all(
              colors.correctRowColor.withAlpha((0.2 * 255).round()));
        }
      } else {
        if (_selectedRowIndex.contains(rowIndex)) {
          if (selectionMode == SelectionMode.entireRow) {
            return WidgetStateProperty.all(
                colors.incorrectRowColor.withAlpha((0.4 * 255).round()));
          }
        } else if (userSelectedIndex.contains(rowIndex)) {
          if (selectionMode == SelectionMode.entireRow) {
            return WidgetStateProperty.all(
                colors.correctRowColor.withAlpha((0.4 * 255).round()));
          }
        }
      }
    }
    return null;
  }

  List<DataCell> _buildRowCells(
      int rowIndex, OptionData data, int? strikeColumnIndex) {
    final strikePrice = widget.previewData.strikePrice;
    final currentRowStrike = data.strike;
    final selectionMode =
        widget.previewData.settings?.selectionMode ?? SelectionMode.entireRow;

    return widget.previewData.columns
        .where((column) => column.isColumnVisible)
        .toList()
        .asMap()
        .entries
        .map((entry) {
      final columnIndex = entry.key;
      final column = entry.value;

      Color? cellColor;
      bool isSelectable = true;

      final colors =
          TLW().themeData?.customColors ?? Theme.of(context).customColors;

      if (strikePrice != null && strikeColumnIndex != null) {
        if (currentRowStrike < strikePrice && columnIndex < strikeColumnIndex) {
          cellColor = colors.selectedRowColor.withAlpha((0.1 * 255).round());
        } else if (currentRowStrike > strikePrice &&
            columnIndex > strikeColumnIndex) {
          cellColor = colors.incorrectRowColor.withAlpha((0.1 * 255).round());
        }
      }

      if (_selectedRowIndex.contains(rowIndex) ||
          userSelectedIndex.contains(rowIndex)) {
        bool shouldHighlight = false;
        if (selectionMode == SelectionMode.callOnly) {
          shouldHighlight =
              strikeColumnIndex != null && columnIndex <= strikeColumnIndex;
        } else if (selectionMode == SelectionMode.putOnly) {
          shouldHighlight =
              strikeColumnIndex != null && columnIndex >= strikeColumnIndex;
        } else {
          shouldHighlight = true;
        }
        if (shouldHighlight) {
          if (userSelectedIndex.contains(rowIndex)) {
            cellColor = colors.correctRowColor.withAlpha((0.2 * 255).round());
          } else if (_selectedRowIndex.contains(rowIndex)) {
            if (_isChecked &&
                !widget.previewData.correctRowIndices.contains(rowIndex)) {
              cellColor =
                  colors.incorrectRowColor.withAlpha((0.2 * 255).round());
            } else {
              cellColor =
                  colors.selectedRowColor.withAlpha((0.2 * 255).round());
            }
          }
        }
      }
      switch (selectionMode) {
        case SelectionMode.callOnly:
          isSelectable =
              strikeColumnIndex != null && columnIndex <= strikeColumnIndex;
          break;
        case SelectionMode.putOnly:
          isSelectable =
              strikeColumnIndex != null && columnIndex >= strikeColumnIndex;
          break;
        case SelectionMode.entireRow:
          isSelectable = true;
          break;
      }

      return DataCell(
        Center(
          child: Container(
            width: 74,
            margin: const EdgeInsets.only(bottom: 2, left: 2),
            decoration: BoxDecoration(
              color: cellColor,
              borderRadius: BorderRadius.circular(14),
              border:
                  Border.all(color: colors.optionChainStrokeColor, width: 1.8),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: isSelectable ? () => _handleCellTap(rowIndex) : null,
              child: Center(
                child: _buildCellContent(rowIndex, data, column.columnType),
              ),
            ),
          ),
        ),
      );
    }).toList();
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

  void _handleCellTap(int rowIndex) {
    setState(() {
      final maxSelectedRows =
          widget.previewData.settings?.maxSelectableRows ?? 0;
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
