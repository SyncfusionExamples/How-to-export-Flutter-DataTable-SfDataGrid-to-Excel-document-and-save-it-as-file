// Package imports
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_datagrid_export/export.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart'
    hide Alignment, Column, Row;

// Local import
import 'helper/save_file_mobile_desktop.dart'
    if (dart.library.html) 'helper/save_file_web.dart' as helper;

void main() {
  runApp(MyApp());
}

/// The application that contains datagrid on it.
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Syncfusion DataGrid Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MyHomePage(),
    );
  }
}

/// The home page of the application which hosts the datagrid.
class MyHomePage extends StatefulWidget {
  /// Creates the home page.
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Employee> employees = <Employee>[];
  late EmployeeDataGridSource employeeDataGridSource;

  final GlobalKey<SfDataGridState> _key = GlobalKey<SfDataGridState>();

  @override
  void initState() {
    super.initState();
    employees = getEmployeeData();
    employeeDataGridSource = EmployeeDataGridSource(employeeData: employees);
  }

  Future<void> exportDataGridToExcel() async {
    final Workbook workbook = _key.currentState!.exportToExcelWorkbook();

    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();

    await helper.saveAndLaunchFile(bytes, 'DataGrid.xlsx');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Syncfusion Flutter DataGrid Export')),
        body: Column(children: <Widget>[
          Container(
              margin: const EdgeInsets.all(12.0),
              child: Row(children: <Widget>[
                SizedBox(
                    height: 40.0,
                    width: 150.0,
                    child: MaterialButton(
                        color: Colors.blue,
                        child: const Center(
                            child: Text('Export to Excel',
                                style: TextStyle(color: Colors.white))),
                        onPressed: exportDataGridToExcel))
              ])),
          Expanded(
              child: SfDataGrid(
                  key: _key,
                  source: employeeDataGridSource,
                  columns: <GridColumn>[
                GridColumn(
                    columnName: 'ID',
                    label: Container(
                        padding: const EdgeInsets.all(16.0),
                        alignment: Alignment.center,
                        child: const Text('ID'))),
                GridColumn(
                    columnName: 'Name',
                    label: Container(
                        padding: const EdgeInsets.all(8.0),
                        alignment: Alignment.center,
                        child: const Text('Name'))),
                GridColumn(
                    columnName: 'Designation',
                    label: Container(
                        padding: const EdgeInsets.all(8.0),
                        alignment: Alignment.center,
                        child: const Text('Designation',
                            overflow: TextOverflow.ellipsis))),
                GridColumn(
                    columnName: 'Salary',
                    label: Container(
                        padding: const EdgeInsets.all(8.0),
                        alignment: Alignment.center,
                        child: const Text('Salary')))
              ]))
        ]));
  }

  List<Employee> getEmployeeData() {
    return <Employee>[
      Employee(10001, 'James', 'Project Lead', 20000),
      Employee(10002, 'Kathryn', 'Manager', 30000),
      Employee(10003, 'Lara', 'Developer', 15000),
      Employee(10004, 'Michael', 'Designer', 15000),
      Employee(10005, 'Martin', 'Developer', 15000),
      Employee(10006, 'Newberry', 'Developer', 15000),
      Employee(10007, 'Balnc', 'Developer', 15000),
      Employee(10008, 'Perry', 'Developer', 15000),
      Employee(10009, 'Gable', 'Developer', 15000),
      Employee(10010, 'Grimes', 'Developer', 15000)
    ];
  }
}

/// Custom business object class which contains properties to hold the detailed
/// information about the employee which will be rendered in datagrid.
class Employee {
  /// Creates the employee class with required details.
  Employee(this.id, this.name, this.designation, this.salary);

  /// Id of an employee.
  final int id;

  /// Name of an employee.
  final String name;

  /// Designation of an employee.
  final String designation;

  /// Salary of an employee.
  final int salary;
}

/// An object to set the employee collection data source to the datagrid. This
/// is used to map the employee data to the datagrid widget.
class EmployeeDataGridSource extends DataGridSource {
  /// Creates the employee data source class with required details.
  EmployeeDataGridSource({required List<Employee> employeeData}) {
    _employeeData = employeeData
        .map<DataGridRow>((Employee dataGridRow) =>
            DataGridRow(cells: <DataGridCell>[
              DataGridCell<int>(columnName: 'ID', value: dataGridRow.id),
              DataGridCell<String>(columnName: 'Name', value: dataGridRow.name),
              DataGridCell<String>(
                  columnName: 'Designation', value: dataGridRow.designation),
              DataGridCell<int>(
                  columnName: 'Salary', value: dataGridRow.salary),
            ]))
        .toList();
  }

  List<DataGridRow> _employeeData = <DataGridRow>[];

  @override
  List<DataGridRow> get rows => _employeeData;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((DataGridCell cell) {
      return Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8.0),
        child: Text(cell.value.toString()),
      );
    }).toList());
  }
}
