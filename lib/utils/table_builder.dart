import 'package:dokdok/shared/constant/const_var/table.dart';
import 'package:flutter/material.dart';

class TableBuilder extends StatefulWidget {
  final List<String> columns;
  final List<Map<String, dynamic>> data;
  final bool isActionEnabled;

  const TableBuilder({
    super.key,
    required this.columns,
    required this.data,
    this.isActionEnabled = false,
  });

  @override
  State<TableBuilder> createState() => _TableBuilderState();

}

class _TableBuilderState extends State<TableBuilder> {

  @override
  void initState() {
    super.initState();
    widget.columns.add(ACTION_COL);
  }

  List<Widget> _fetchColumnWidget() {
    List<Widget> columnWidgets = [];
    for(var col in widget.columns) {
      if(col == ACTION_COL) {
        break;
      }
      columnWidgets.add(
        Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                col[0].toUpperCase() + col.substring(1),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.deepPurple,
                ),
                textAlign: TextAlign.center,
              ),
            )
      );
    }
    return columnWidgets;
  }

  List<TableRow> _fetchRowsWidget() {
    List<TableRow> rowWidgets = [];
    List<Widget> rowCells = [];
    for(var row in widget.data) {
      rowCells.clear();
      for(var col in widget.columns) {
        if(col == ACTION_COL) {
          break;
        }
        rowCells.add(
          Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      row[col].toString(),
                      style: const TextStyle(fontSize: 15),
                      textAlign: TextAlign.center,
                    ),
                  )
        );
      }
      rowWidgets.add(
        TableRow(
            children: rowCells,
          )
      );
    }

    return rowWidgets;
  }


  @override
  Widget build(BuildContext context) {
    return Table(
      border: TableBorder.all(color: Colors.grey, width: 1),
      defaultVerticalAlignment: TableCellVerticalAlignment.top,
      columnWidths: const {
        0: FixedColumnWidth(120),
        1: FixedColumnWidth(100),
        2: FixedColumnWidth(100),
        3: FixedColumnWidth(140),
      },
      children: [
        // Table header
        TableRow(
          decoration: const BoxDecoration(color: Color(0xFFEDE7F6)),
          children: _fetchColumnWidget(),
        ),
        // Table rows
        ..._fetchRowsWidget(),
      ],
    );
  }
  
}