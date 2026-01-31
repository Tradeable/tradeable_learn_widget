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
import 'package:fin_chart/option_chain/models/option_leg.dart';

class PreviewScreen extends StatefulWidget {
  final PreviewData previewData;
  final VoidCallback onViewChartClicked;
  final VoidCallback onSettingsClicked;
  final Function(OptionLeg? optionLeg)? onBuySellSelected;

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
      Function(OptionLeg? optionLeg)? onBuySellSelected,
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
  static const double cellHeight = 70;
  static const double cellWidth = 75;
  List<int> _selectedRowIndex = [];
  bool _isChecked = false;
  List<int> userSelectedIndex = [];
  final AutoSizeGroup _textGroup = AutoSizeGroup();

  final ScrollController _leftHeaderScrollController = ScrollController();
  final ScrollController _rightHeaderScrollController = ScrollController();
  final ScrollController _leftContentScrollController = ScrollController();
  final ScrollController _rightContentScrollController = ScrollController();
  bool _isScrolling = false;
  List<Map<int, int>> correctBucketIndexes = [];
  Map<int, bool> bucketSelections = {};
  Map<int, bool> bucketCallSelections = {};
  Map<int, bool> bucketPutSelections = {};
  Map<String, List<bool>> buySellSelections = {};
  Map<int, bool> callBuySelections = {};
  Map<int, bool> callSellSelections = {};
  Map<int, bool> putBuySelections = {};
  Map<int, bool> putSellSelections = {};

  @override
  void initState() {
    super.initState();
    _selectedRowIndex = List.from(widget.previewData.selectedRowIndices);

    if (widget.previewData.bucketRows != null) {
      for (var bucketRow in widget.previewData.bucketRows!) {
        final rowIndex = bucketRow.rowIndex ?? 0;
        final side = bucketRow.side ?? 0;
        final isBuy = bucketRow.type == PositionType.buy;

        if (side == 0) {
          bucketCallSelections[rowIndex] = true;
          bucketSelections[rowIndex] = true;
          if (isBuy) {
            callBuySelections[rowIndex] = true;
          } else {
            callSellSelections[rowIndex] = true;
          }
        } else {
          bucketPutSelections[rowIndex] = true;
          bucketSelections[rowIndex] = true;
          if (isBuy) {
            putBuySelections[rowIndex] = true;
          } else {
            putSellSelections[rowIndex] = true;
          }
        }
      }
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setupScrollSync();
    });
  }

  @override
  void dispose() {
    _leftHeaderScrollController.dispose();
    _rightHeaderScrollController.dispose();
    _leftContentScrollController.dispose();
    _rightContentScrollController.dispose();
    super.dispose();
  }

  void _setupScrollSync() {
    _leftContentScrollController.addListener(() {
      if (!_isScrolling) {
        _isScrolling = true;
        if (_leftHeaderScrollController.hasClients) {
          _leftHeaderScrollController
              .jumpTo(_leftContentScrollController.offset);
        }
        if (_rightHeaderScrollController.hasClients) {
          _rightHeaderScrollController
              .jumpTo(_leftContentScrollController.offset);
        }
        if (_rightContentScrollController.hasClients) {
          _rightContentScrollController
              .jumpTo(_leftContentScrollController.offset);
        }
        _isScrolling = false;
      }
    });

    _rightContentScrollController.addListener(() {
      if (!_isScrolling) {
        _isScrolling = true;
        if (_rightHeaderScrollController.hasClients) {
          _rightHeaderScrollController
              .jumpTo(_rightContentScrollController.offset);
        }
        if (_leftHeaderScrollController.hasClients) {
          _leftHeaderScrollController
              .jumpTo(_rightContentScrollController.offset);
        }
        if (_leftContentScrollController.hasClients) {
          _leftContentScrollController
              .jumpTo(_rightContentScrollController.offset);
        }
        _isScrolling = false;
      }
    });

    _leftHeaderScrollController.addListener(() {
      if (!_isScrolling) {
        _isScrolling = true;
        if (_leftContentScrollController.hasClients) {
          _leftContentScrollController
              .jumpTo(_leftHeaderScrollController.offset);
        }
        if (_rightHeaderScrollController.hasClients) {
          _rightHeaderScrollController
              .jumpTo(_leftHeaderScrollController.offset);
        }
        if (_rightContentScrollController.hasClients) {
          _rightContentScrollController
              .jumpTo(_leftHeaderScrollController.offset);
        }
        _isScrolling = false;
      }
    });

    _rightHeaderScrollController.addListener(() {
      if (!_isScrolling) {
        _isScrolling = true;
        if (_rightContentScrollController.hasClients) {
          _rightContentScrollController
              .jumpTo(_rightHeaderScrollController.offset);
        }
        if (_leftHeaderScrollController.hasClients) {
          _leftHeaderScrollController
              .jumpTo(_rightHeaderScrollController.offset);
        }
        if (_leftContentScrollController.hasClients) {
          _leftContentScrollController
              .jumpTo(_rightHeaderScrollController.offset);
        }
        _isScrolling = false;
      }
    });
  }

  void chooseBucketRows(List<OptionLeg> bucketRows) {
    setState(() {
      correctBucketIndexes = bucketRows.map((e) => e.toLegacyFormat()).toList();
      for (var bucketRow in bucketRows) {
        final rowIndex = bucketRow.rowIndex ?? 0;
        final side = bucketRow.side ?? 0;
        final isBuy = bucketRow.type == PositionType.buy;

        if (side == 0) {
          bucketCallSelections[rowIndex] = true;
          if (isBuy) {
            callBuySelections[rowIndex] = true;
          } else {
            callSellSelections[rowIndex] = true;
          }
        } else {
          bucketPutSelections[rowIndex] = true;
          if (isBuy) {
            putBuySelections[rowIndex] = true;
          } else {
            putSellSelections[rowIndex] = true;
          }
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

  List<OptionLeg>? getBucketRows() {
    final selectionMode =
        widget.previewData.settings?.selectionMode ?? SelectionMode.entireRow;
    if (selectionMode == SelectionMode.bucketRow) {
      List<OptionLeg> bucketRows = [];
      final symbol = widget.previewData.optionData.isNotEmpty
          ? (widget.previewData.strikePrice != null
              ? '${widget.previewData.strikePrice}_${widget.previewData.expiryDate?.millisecondsSinceEpoch}'
              : '')
          : '';
      final expiry = widget.previewData.expiryDate ?? DateTime.now();

      callBuySelections.forEach((rowIndex, isSelected) {
        if (isSelected && rowIndex < widget.previewData.optionData.length) {
          final optionData = widget.previewData.optionData[rowIndex];
          bucketRows.add(OptionLeg(
            symbol: symbol,
            strike: optionData.strike,
            type: PositionType.buy,
            optionType: OptionType.call,
            expiry: expiry,
            quantity: 1,
            premium: optionData.callPremium,
            rowIndex: rowIndex,
            side: 0,
          ));
        }
      });
      callSellSelections.forEach((rowIndex, isSelected) {
        if (isSelected && rowIndex < widget.previewData.optionData.length) {
          final optionData = widget.previewData.optionData[rowIndex];
          bucketRows.add(OptionLeg(
            symbol: symbol,
            strike: optionData.strike,
            type: PositionType.sell,
            optionType: OptionType.call,
            expiry: expiry,
            quantity: 1,
            premium: optionData.callPremium,
            rowIndex: rowIndex,
            side: 0,
          ));
        }
      });

      putBuySelections.forEach((rowIndex, isSelected) {
        if (isSelected && rowIndex < widget.previewData.optionData.length) {
          final optionData = widget.previewData.optionData[rowIndex];
          bucketRows.add(OptionLeg(
            symbol: symbol,
            strike: optionData.strike,
            type: PositionType.buy,
            optionType: OptionType.put,
            expiry: expiry,
            quantity: 1,
            premium: optionData.putPremium,
            rowIndex: rowIndex,
            side: 1,
          ));
        }
      });
      putSellSelections.forEach((rowIndex, isSelected) {
        if (isSelected && rowIndex < widget.previewData.optionData.length) {
          final optionData = widget.previewData.optionData[rowIndex];
          bucketRows.add(OptionLeg(
            symbol: symbol,
            strike: optionData.strike,
            type: PositionType.sell,
            optionType: OptionType.put,
            expiry: expiry,
            quantity: 1,
            premium: optionData.putPremium,
            rowIndex: rowIndex,
            side: 1,
          ));
        }
      });

      bucketCallSelections.forEach((rowIndex, isSelected) {
        if (isSelected &&
            !callBuySelections.containsKey(rowIndex) &&
            !callSellSelections.containsKey(rowIndex) &&
            rowIndex < widget.previewData.optionData.length) {
          final optionData = widget.previewData.optionData[rowIndex];
          bucketRows.add(OptionLeg(
            symbol: symbol,
            strike: optionData.strike,
            type: PositionType.buy,
            optionType: OptionType.call,
            expiry: expiry,
            quantity: 1,
            premium: optionData.callPremium,
            rowIndex: rowIndex,
            side: 0,
          ));
        }
      });

      bucketPutSelections.forEach((rowIndex, isSelected) {
        if (isSelected &&
            !putBuySelections.containsKey(rowIndex) &&
            !putSellSelections.containsKey(rowIndex) &&
            rowIndex < widget.previewData.optionData.length) {
          final optionData = widget.previewData.optionData[rowIndex];
          bucketRows.add(OptionLeg(
            symbol: symbol,
            strike: optionData.strike,
            type: PositionType.buy,
            optionType: OptionType.put,
            expiry: expiry,
            quantity: 1,
            premium: optionData.putPremium,
            rowIndex: rowIndex,
            side: 1,
          ));
        }
      });

      return bucketRows;
    }
    return null;
  }

  List<OptionLeg>? getOptionLegs() {
    final selectionMode =
        widget.previewData.settings?.selectionMode ?? SelectionMode.entireRow;
    if (selectionMode == SelectionMode.bucketRow) {
      List<OptionLeg> optionLegs = [];

      callBuySelections.forEach((rowIndex, isSelected) {
        if (isSelected) {
          final data = widget.previewData.optionData[rowIndex];
          optionLegs.add(OptionLeg(
            symbol: "NIFTY",
            strike: data.strike,
            type: PositionType.buy,
            optionType: OptionType.call,
            expiry: widget.previewData.expiryDate ?? DateTime.now(),
            quantity: 1,
            premium: data.callPremium,
          ));
        }
      });

      callSellSelections.forEach((rowIndex, isSelected) {
        if (isSelected) {
          final data = widget.previewData.optionData[rowIndex];
          optionLegs.add(OptionLeg(
            symbol: "NIFTY",
            strike: data.strike,
            type: PositionType.sell,
            optionType: OptionType.call,
            expiry: widget.previewData.expiryDate ?? DateTime.now(),
            quantity: 1,
            premium: data.callPremium,
          ));
        }
      });

      // Handle put buy selections
      putBuySelections.forEach((rowIndex, isSelected) {
        if (isSelected) {
          final data = widget.previewData.optionData[rowIndex];
          optionLegs.add(OptionLeg(
            symbol: "NIFTY",
            strike: data.strike,
            type: PositionType.buy,
            optionType: OptionType.put,
            expiry: widget.previewData.expiryDate ?? DateTime.now(),
            quantity: 1,
            premium: data.putPremium,
          ));
        }
      });

      // Handle put sell selections
      putSellSelections.forEach((rowIndex, isSelected) {
        if (isSelected) {
          final data = widget.previewData.optionData[rowIndex];
          optionLegs.add(OptionLeg(
            symbol: "NIFTY",
            strike: data.strike,
            type: PositionType.sell,
            optionType: OptionType.put,
            expiry: widget.previewData.expiryDate ?? DateTime.now(),
            quantity: 1,
            premium: data.putPremium,
          ));
        }
      });

      return optionLegs;
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
          return columns
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
            child: Column(
              children: [
                Container(child: _buildHeaderRow()),
                Expanded(
                  child: SingleChildScrollView(
                    child: _buildContentRow(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderRow() {
    switch (widget.previewData.visibility) {
      case OptionChainVisibility.call:
        final columns = _getFilteredColumns();
        final totalWidth = columns.length * cellWidth + cellWidth;
        return LayoutBuilder(
          builder: (context, constraints) {
            final screenWidth = constraints.maxWidth;
            final needsScroll = totalWidth > screenWidth;

            return Stack(
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  controller: _leftHeaderScrollController,
                  physics: const ClampingScrollPhysics(),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...columns.map((column) => _buildColumnHeader(column)),
                      SizedBox(
                          width: cellWidth, child: _buildStrikeColumnHeader()),
                    ],
                  ),
                ),
                if (needsScroll)
                  Positioned(
                    right: 0,
                    child: Container(
                      width: cellWidth,
                      height: 56,
                      color: Theme.of(context).scaffoldBackgroundColor,
                      child: _buildStrikeColumnHeader(),
                    ),
                  ),
              ],
            );
          },
        );
      case OptionChainVisibility.put:
        final columns = _getFilteredColumns();
        final totalWidth = columns.length * cellWidth + cellWidth;
        return LayoutBuilder(
          builder: (context, constraints) {
            final screenWidth = constraints.maxWidth;
            final needsScroll = totalWidth > screenWidth;

            return Stack(
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  controller: _rightHeaderScrollController,
                  physics: const ClampingScrollPhysics(),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                          width: cellWidth, child: _buildStrikeColumnHeader()),
                      ...columns.map((column) => _buildColumnHeader(column)),
                    ],
                  ),
                ),
                if (needsScroll)
                  Positioned(
                    left: 0,
                    child: Container(
                      width: cellWidth,
                      height: 56,
                      color: Theme.of(context).scaffoldBackgroundColor,
                      child: _buildStrikeColumnHeader(),
                    ),
                  ),
              ],
            );
          },
        );
      case OptionChainVisibility.both:
        final leftColumns = _getFilteredColumns(isLeftSide: true);
        final rightColumns = _getFilteredColumns(isLeftSide: false);
        return LayoutBuilder(
          builder: (context, constraints) {
            final screenWidth = constraints.maxWidth;
            final centerPosition = (screenWidth - cellWidth) / 2;
            final leftWidth = leftColumns.length * cellWidth;
            final rightWidth = rightColumns.length * cellWidth;
            final minTotalWidth = leftWidth + rightWidth + cellWidth;

            if (minTotalWidth <= screenWidth) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...leftColumns.map((column) => _buildColumnHeader(column)),
                  _buildStrikeColumnHeader(),
                  ...rightColumns.map((column) => _buildColumnHeader(column)),
                ],
              );
            }

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: centerPosition,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    controller: _leftHeaderScrollController,
                    physics: const ClampingScrollPhysics(),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: leftColumns
                          .map((column) => _buildColumnHeader(column))
                          .toList(),
                    ),
                  ),
                ),
                SizedBox(width: cellWidth, child: _buildStrikeColumnHeader()),
                SizedBox(
                  width: centerPosition,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    controller: _rightHeaderScrollController,
                    physics: const ClampingScrollPhysics(),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: rightColumns
                          .map((column) => _buildColumnHeader(column))
                          .toList(),
                    ),
                  ),
                ),
              ],
            );
          },
        );
    }
  }

  Widget _buildContentRow() {
    switch (widget.previewData.visibility) {
      case OptionChainVisibility.call:
        final columns = _getFilteredColumns();
        final totalWidth = columns.length * cellWidth + cellWidth;
        return LayoutBuilder(
          builder: (context, constraints) {
            final screenWidth = constraints.maxWidth;
            final needsScroll = totalWidth > screenWidth;

            return Stack(
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  controller: _leftContentScrollController,
                  physics: const ClampingScrollPhysics(),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...columns.map((column) => _buildColumnContent(
                          column, _leftContentScrollController)),
                      SizedBox(
                          width: cellWidth,
                          child: _buildStickyStrikeColumnContent()),
                    ],
                  ),
                ),
                if (needsScroll)
                  Positioned(
                    right: 0,
                    child: Container(
                      width: cellWidth,
                      height: widget.previewData.optionData.length * cellHeight,
                      color: Theme.of(context).scaffoldBackgroundColor,
                      child: _buildStickyStrikeColumnContent(),
                    ),
                  ),
              ],
            );
          },
        );
      case OptionChainVisibility.put:
        final columns = _getFilteredColumns();
        final totalWidth = columns.length * cellWidth + cellWidth;
        return LayoutBuilder(
          builder: (context, constraints) {
            final screenWidth = constraints.maxWidth;
            final needsScroll = totalWidth > screenWidth;

            return Stack(
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  controller: _rightContentScrollController,
                  physics: const ClampingScrollPhysics(),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                          width: cellWidth,
                          child: _buildStickyStrikeColumnContent()),
                      ...columns.map((column) => _buildColumnContent(
                          column, _rightContentScrollController)),
                    ],
                  ),
                ),
                if (needsScroll)
                  Positioned(
                    left: 0,
                    child: Container(
                      width: cellWidth,
                      height: widget.previewData.optionData.length * cellHeight,
                      color: Theme.of(context).scaffoldBackgroundColor,
                      child: _buildStickyStrikeColumnContent(),
                    ),
                  ),
              ],
            );
          },
        );
      case OptionChainVisibility.both:
        final leftColumns = _getFilteredColumns(isLeftSide: true);
        final rightColumns = _getFilteredColumns(isLeftSide: false);
        return LayoutBuilder(
          builder: (context, constraints) {
            final screenWidth = constraints.maxWidth;
            final centerPosition = (screenWidth - cellWidth) / 2;
            final leftWidth = leftColumns.length * cellWidth;
            final rightWidth = rightColumns.length * cellWidth;
            final minTotalWidth = leftWidth + rightWidth + cellWidth;

            if (minTotalWidth <= screenWidth) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...leftColumns.map((column) => _buildColumnContent(
                      column, _leftContentScrollController)),
                  _buildStickyStrikeColumnContent(),
                  ...rightColumns.map((column) => _buildColumnContent(
                      column, _rightContentScrollController)),
                ],
              );
            }

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: centerPosition,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    controller: _leftContentScrollController,
                    physics: const ClampingScrollPhysics(),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: leftColumns
                          .map((column) => _buildColumnContent(
                              column, _leftContentScrollController))
                          .toList(),
                    ),
                  ),
                ),
                SizedBox(
                    width: cellWidth, child: _buildStickyStrikeColumnContent()),
                SizedBox(
                  width: centerPosition,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    controller: _rightContentScrollController,
                    physics: const ClampingScrollPhysics(),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: rightColumns
                          .map((column) => _buildColumnContent(
                              column, _rightContentScrollController))
                          .toList(),
                    ),
                  ),
                ),
              ],
            );
          },
        );
    }
  }

  Widget _buildColumnHeader(ColumnConfig column) {
    final colors =
        TLW().themeData?.customColors ?? Theme.of(context).customColors;
    final textStyles =
        TLW().themeData?.customTextStyles ?? Theme.of(context).customTextStyles;

    return SizedBox(
      width: cellWidth,
      child: Container(
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
    );
  }

  Widget _buildStrikeColumnHeader() {
    final colors =
        TLW().themeData?.customColors ?? Theme.of(context).customColors;
    final textStyles =
        TLW().themeData?.customTextStyles ?? Theme.of(context).customTextStyles;

    final strikeColumn = widget.previewData.columns.firstWhere(
        (column) => column.columnType == ColumnType.strike,
        orElse: () => throw Exception("Strike column not found"));

    return Container(
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
    );
  }

  Widget _buildColumnContent(ColumnConfig column, ScrollController controller) {
    return SizedBox(
      width: cellWidth,
      child: SizedBox(
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
    );
  }

  Widget _buildStickyStrikeColumnContent() {
    return SizedBox(
      height: widget.previewData.optionData.length * cellHeight,
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: widget.previewData.optionData.length,
        itemBuilder: (context, rowIndex) {
          final data = widget.previewData.optionData[rowIndex];
          final cellContent =
              _buildCellContent(rowIndex, data, ColumnType.strike);
          final colors =
              TLW().themeData?.customColors ?? Theme.of(context).customColors;
          final strikeColumnIndex = _getStrikeColumnIndex();
          final selectionMode = widget.previewData.settings?.selectionMode ??
              SelectionMode.entireRow;

          Color? cellColor = _getCellColor(
            rowIndex: rowIndex,
            actualColumnIndex: strikeColumnIndex ?? 0,
            strikeColumnIndex: strikeColumnIndex,
            strikePrice: widget.previewData.strikePrice,
            currentRowStrike: data.strike,
            selectionMode: selectionMode,
          );

          cellColor ??= colors.strikePriceCellColor;

          return Container(
            height: cellHeight,
            alignment: Alignment.center,
            child: Container(
              width: cellWidth,
              margin: const EdgeInsets.only(bottom: 3, left: 2),
              decoration: BoxDecoration(
                color: cellColor,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: colors.axisColor, width: 1),
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

    if (column.columnType == ColumnType.strike && cellColor == null) {
      cellColor = colors.strikePriceHeaderColor;
    }

    bool isSelectable = _isCellSelectable(
      actualColumnIndex: actualColumnIndex,
      strikeColumnIndex: strikeColumnIndex,
      selectionMode: selectionMode,
    );

    return Center(
      child: Container(
        width: cellWidth,
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: cellColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: colors.optionChainStrokeColor, width: 1),
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

    if (selectionMode == SelectionMode.bucketRow && strikeColumnIndex != null) {
      if (actualColumnIndex < strikeColumnIndex) {
        if (callBuySelections[rowIndex] == true) {
          return colors.correctRowColor.withAlpha((0.2 * 255).round());
        } else if (callSellSelections[rowIndex] == true) {
          return colors.incorrectRowColor.withAlpha((0.2 * 255).round());
        }
      } else if (actualColumnIndex > strikeColumnIndex) {
        if (putBuySelections[rowIndex] == true) {
          return colors.correctRowColor.withAlpha((0.2 * 255).round());
        } else if (putSellSelections[rowIndex] == true) {
          return colors.incorrectRowColor.withAlpha((0.2 * 255).round());
        }
      }
    }

    if (strikePrice != null && strikeColumnIndex != null) {
      if (currentRowStrike < strikePrice &&
          actualColumnIndex < strikeColumnIndex) {
        cellColor = colors.selectedRowColor;
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
            cellColor = colors.selectedRowColor.withAlpha((0.4 * 255).round());
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
      final maxSelectedRows = widget.previewData.maxSelectableRows;

      if (maxSelectedRows == null || maxSelectedRows == 0) {
        if (!userSelectedIndex.contains(rowIndex)) {
          userSelectedIndex.add(rowIndex);
        }
      } else {
        if (userSelectedIndex.contains(rowIndex)) {
          userSelectedIndex.remove(rowIndex);
        } else if (userSelectedIndex.length < maxSelectedRows) {
          userSelectedIndex.add(rowIndex);
        }
      }
      _isChecked = true;
    });
  }

  Widget _buildCellContent(
      int rowIndex, OptionData data, ColumnType columnType) {
    final text = DataTransformer.getCellText(data, columnType);
    final textStyles =
        TLW().themeData?.customTextStyles ?? Theme.of(context).customTextStyles;
    final colors =
        TLW().themeData?.customColors ?? Theme.of(context).customColors;
    final strikeColumnIndex = _getStrikeColumnIndex();

    if (!widget.previewData.isEditorMode &&
        widget.previewData.settings?.isBuySellVisible == true &&
        (columnType == ColumnType.callPremium ||
            columnType == ColumnType.putPremium)) {
      final columnIndex = widget.previewData.columns
          .indexWhere((col) => col.columnType == columnType);

      final isCallSide =
          strikeColumnIndex != null && columnIndex < strikeColumnIndex;

      final buySelections = isCallSide ? callBuySelections : putBuySelections;
      final sellSelections =
          isCallSide ? callSellSelections : putSellSelections;

      final isBuySelected = buySelections[rowIndex] ?? false;
      final isSellSelected = sellSelections[rowIndex] ?? false;

      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 4),
              child: AutoSizeText(
                text,
                group: _textGroup,
                minFontSize: 8,
                maxFontSize: 16,
                maxLines: 1,
                style: textStyles.mediumNormal.copyWith(
                  color: colors.axisColor,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 4),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      if (isBuySelected) {
                        buySelections.remove(rowIndex);
                      } else {
                        buySelections[rowIndex] = true;
                        sellSelections.remove(rowIndex);
                        if (isCallSide) {
                          bucketCallSelections[rowIndex] = true;
                          bucketSelections[rowIndex] = true;
                        } else {
                          bucketPutSelections[rowIndex] = true;
                          bucketSelections[rowIndex] = true;
                        }
                      }
                      if (widget.onBuySellSelected != null) {
                        final optionLeg = OptionLeg(
                          symbol: "NIFTY",
                          strike: data.strike,
                          type: buySelections[rowIndex] == true
                              ? PositionType.buy
                              : PositionType.sell,
                          optionType:
                              isCallSide ? OptionType.call : OptionType.put,
                          expiry:
                              widget.previewData.expiryDate ?? DateTime.now(),
                          quantity: 1,
                          premium:
                              isCallSide ? data.callPremium : data.putPremium,
                        );
                        widget.onBuySellSelected!(optionLeg);
                      }
                    });
                  },
                  child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 2, horizontal: 8),
                      decoration: BoxDecoration(
                          color: isBuySelected
                              ? Colors.green
                              : Colors.green.shade200,
                          borderRadius: BorderRadius.circular(6)),
                      child: Text('B',
                          style: TextStyle(
                              fontSize: 10,
                              color: isBuySelected
                                  ? Colors.white
                                  : Colors.black))),
                ),
                const SizedBox(height: 6),
                InkWell(
                  onTap: () {
                    setState(() {
                      if (isSellSelected) {
                        sellSelections.remove(rowIndex);
                      } else {
                        sellSelections[rowIndex] = true;
                        buySelections.remove(rowIndex);
                        if (isCallSide) {
                          bucketCallSelections[rowIndex] = true;
                          bucketSelections[rowIndex] = true;
                        } else {
                          bucketPutSelections[rowIndex] = true;
                          bucketSelections[rowIndex] = true;
                        }
                      }
                      if (widget.onBuySellSelected != null) {
                        final optionLeg = OptionLeg(
                          symbol: "NIFTY",
                          strike: data.strike,
                          type: sellSelections[rowIndex] == true
                              ? PositionType.sell
                              : PositionType.buy,
                          optionType:
                              isCallSide ? OptionType.call : OptionType.put,
                          expiry:
                              widget.previewData.expiryDate ?? DateTime.now(),
                          quantity: 1,
                          premium:
                              isCallSide ? data.callPremium : data.putPremium,
                        );
                        widget.onBuySellSelected!(optionLeg);
                      }
                    });
                  },
                  child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 2, horizontal: 8),
                      decoration: BoxDecoration(
                          color:
                              isSellSelected ? Colors.red : Colors.red.shade200,
                          borderRadius: BorderRadius.circular(6)),
                      child: Text('S',
                          style: TextStyle(
                              fontSize: 10,
                              color: isSellSelected
                                  ? Colors.white
                                  : Colors.black))),
                ),
              ],
            ),
          ),
        ],
      );
    }
    return AutoSizeText(
      text,
      group: _textGroup,
      minFontSize: 8,
      maxFontSize: 16,
      maxLines: 1,
      style: textStyles.mediumNormal.copyWith(
          fontWeight: columnType == ColumnType.strike
              ? FontWeight.bold
              : FontWeight.normal,
          color: colors.axisColor),
    );
  }

  void _handleBucketCellTap(
      int rowIndex, int columnIndex, int? strikeColumnIndex) {
    if (strikeColumnIndex == null) return;

    setState(() {
      final maxSelectedRows = widget.previewData.maxSelectableRows;

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
          } else if (maxSelectedRows != null && maxSelectedRows > 1) {
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
          } else if (maxSelectedRows != null && maxSelectedRows > 1) {
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
      final maxSelectedRows = widget.previewData.maxSelectableRows;

      if (selectionMode == SelectionMode.bucketRow) {
        return;
      }

      if (maxSelectedRows == 1) {
        if (_selectedRowIndex.contains(rowIndex)) {
          _selectedRowIndex.remove(rowIndex);
        } else {
          _selectedRowIndex = [rowIndex];
        }
      } else if (maxSelectedRows != null && maxSelectedRows > 1) {
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

  void setBuySellSelections(List<OptionLeg> bucketRows) {
    setState(() {
      bucketCallSelections.clear();
      bucketPutSelections.clear();
      callBuySelections.clear();
      callSellSelections.clear();
      putBuySelections.clear();
      putSellSelections.clear();

      for (var bucketRow in bucketRows) {
        final rowIndex = bucketRow.rowIndex ?? 0;
        final side = bucketRow.side ?? 0;
        final isBuy = bucketRow.type == PositionType.buy;

        if (side == 0) {
          bucketCallSelections[rowIndex] = true;
          bucketSelections[rowIndex] = true;
          if (isBuy) {
            callBuySelections[rowIndex] = true;
          } else {
            callSellSelections[rowIndex] = true;
          }
        } else {
          bucketPutSelections[rowIndex] = true;
          bucketSelections[rowIndex] = true;
          if (isBuy) {
            putBuySelections[rowIndex] = true;
          } else {
            putSellSelections[rowIndex] = true;
          }
        }
      }

      correctBucketIndexes = bucketRows.map((e) => e.toLegacyFormat()).toList();
      _isChecked = true;
    });
  }

  void clearBucketSelections() {
    setState(() {
      bucketCallSelections.clear();
      bucketPutSelections.clear();
      callBuySelections.clear();
      callSellSelections.clear();
      putBuySelections.clear();
      putSellSelections.clear();
      bucketSelections.clear();
      correctBucketIndexes = [];
      _isChecked = false;
    });
  }
}
