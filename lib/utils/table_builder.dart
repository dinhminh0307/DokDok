import 'package:flutter/material.dart';

class TableBuilder extends StatelessWidget {
  final List<String> columns;
  final List<Map<String, dynamic>> data;

  const TableBuilder({
    super.key,
    required this.columns,
    required this.data,
  });

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
          children: columns
              .map(
                (col) => Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    col[0].toUpperCase() + col.substring(1),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
              .toList(),
        ),
        // Table rows
        ...data.map(
          (row) => TableRow(
            children: columns
                .map(
                  (col) => Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      row[col].toString(),
                      style: const TextStyle(fontSize: 15),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}