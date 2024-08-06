import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_core/theme.dart';

class CustomDataSource extends DataGridSource {
  CustomDataSource({
    required this.columns,
    required this.data,
    required this.onEdit,
    required this.onDelete,
  });

  final List<String> columns;
  final List<Map<String, String>> data;
  final Function(String) onEdit;
  final Function(String) onDelete;

  List<DataGridCell> _getRows(value) {
    final temp = columns.map((column) => DataGridCell(columnName: column, value: value[column])).toList(growable: true);
    temp.add(DataGridCell(columnName: 'Actions', value: value["_id"]));
    return temp;
  }

  @override
  List<DataGridRow> get rows => data.map((value) => DataGridRow(cells: _getRows(value))).toList();

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((dataCell) {
      if (dataCell.columnName == "Actions") {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          alignment: Alignment.center,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: () {
                  onEdit(dataCell.value.toString());
                },
                icon: Icon(Icons.edit),
              ),
              SizedBox(width: 10),
              IconButton(
                onPressed: () {
                  onDelete(dataCell.value.toString());
                },
                icon: Icon(Icons.delete),
              ),
            ],
          ),
        );
      } else {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          alignment: Alignment.centerLeft,
          child: Text(
            dataCell.value.toString(),
          ),
        );
      }
    }).toList());
  }
}

class CustomTable extends StatelessWidget {
  const CustomTable({super.key, required this.columns, required this.data, required this.onEdit, required this.onDelete});

  final List<String> columns;
  final List<Map<String, String>> data;
  final Function(String) onEdit;
  final Function(String) onDelete;

  List<GridColumn> _getColumns() {
    GridColumn getCell(String name) {
      return GridColumn(
        autoFitPadding: EdgeInsets.symmetric(horizontal: 20.0),
        columnName: name,
        label: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          alignment: Alignment.center,
          child: Text(
            name,
            style: TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
    }

    final temp = columns.map((column) => getCell(column)).toList();
    temp.add(getCell("Actions"));
    return temp;
  }

  @override
  Widget build(BuildContext context) {
    final DataGridSource source = CustomDataSource(columns: columns, data: data, onEdit: onEdit, onDelete: onDelete);

    return SfDataGridTheme(
      data: SfDataGridThemeData(
        headerColor: Theme.of(context).colorScheme.secondaryContainer,
        gridLineColor: Theme.of(context).colorScheme.onSecondaryContainer,
        gridLineStrokeWidth: 1,
      ),
      child: SfDataGrid(
        source: source,
        columnWidthMode: ColumnWidthMode.auto,
        gridLinesVisibility: GridLinesVisibility.both,
        isScrollbarAlwaysShown: true,
        columns: _getColumns(),
      ),
    );
  }
}
