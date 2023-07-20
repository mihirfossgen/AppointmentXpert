// ignore_for_file: avoid_print

import 'package:appointmentxpert/presentation/schedule_page/controller/schedule_controller.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../models/getAllApointments.dart';

// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// The file was extracted from GitHub: https://github.com/flutter/gallery
// Changes and modifications by Maxim Saplin, 2021

/// Keeps track of selected rows, feed the data into DesertsDataSource
class RestorableSelections extends RestorableProperty<Set<int>> {
  Set<int> _selections = {};

  /// Returns whether or not a dessert row is selected by index.
  bool isSelected(int index) => _selections.contains(index);

  /// Takes a list of [Appointments]s and saves the row indices of selected rows
  /// into a [Set].
  void setDessertSelections(List<AppointmentContent> contents) {
    final updatedSet = <int>{};
    for (var i = 0; i < contents.length; i += 1) {
      var content = contents[i];
      if (content.selected == true) {
        updatedSet.add(i);
      }
    }
    _selections = updatedSet;
    notifyListeners();
  }

  @override
  Set<int> createDefaultValue() => _selections;

  @override
  Set<int> fromPrimitives(Object? data) {
    final selectedItemIndices = data as List<dynamic>;
    _selections = {
      ...selectedItemIndices.map<int>((dynamic id) => id as int),
    };
    return _selections;
  }

  @override
  void initWithValue(Set<int> value) {
    _selections = value;
  }

  @override
  Object toPrimitives() => _selections.toList();
}

int _idCounter = 0;

/// Data source implementing standard Flutter's DataTableSource abstract class
/// which is part of DataTable and PaginatedDataTable synchronous data fecthin API.
/// This class uses static collection of deserts as a data store, projects it into
/// DataRows, keeps track of selected items, provides sprting capability
class DataSource extends DataTableSource {
  DataSource.empty(this.context) {
    contents = [];
    //scheduleController = ScheduleController();
  }

  DataSource(this.context,
      [sortedByDate = false,
      this.hasRowTaps = false,
      this.hasRowHeightOverrides = false,
      this.hasZebraStripes = false]) {
    contents;
    scheduleController;
    if (sortedByDate) {
      sort((d) => d.dateCreated ?? '', true);
    }
  }

  final BuildContext context;
  List<AppointmentContent> contents = [];
  ScheduleController? scheduleController;
  // Add row tap handlers and show snackbar
  bool hasRowTaps = false;
  // Override height values for certain rows
  bool hasRowHeightOverrides = false;
  // Color each Row by index's parity
  bool hasZebraStripes = false;

  void sort<T>(
      Comparable<T> Function(AppointmentContent d) getField, bool ascending) {
    contents.sort((a, b) {
      final aValue = getField(a);
      final bValue = getField(b);
      return ascending
          ? Comparable.compare(aValue, bValue)
          : Comparable.compare(bValue, aValue);
    });
    notifyListeners();
  }

  void updateSelectedAppointmentss(RestorableSelections selectedRows) {
    _selectedCount = 0;
    for (var i = 0; i < contents.length; i += 1) {
      var content = contents[i];
      if (selectedRows.isSelected(i)) {
        content.selected = true;
        _selectedCount += 1;
      } else {
        content.selected = false;
      }
    }
    notifyListeners();
  }

  @override
  DataRow getRow(int index, [Color? color]) {
    final format = NumberFormat.decimalPercentPattern(
      locale: 'en',
      decimalDigits: 0,
    );
    assert(index >= 0);
    if (index >= contents.length) throw 'index > _desserts.length';
    final content = contents[index];
    return DataRow2.byIndex(
      index: index,
      selected: content.selected ?? false,
      color: color != null
          ? MaterialStateProperty.all(color)
          : (hasZebraStripes && index.isEven
              ? MaterialStateProperty.all(Theme.of(context).highlightColor)
              : null),
      onSelectChanged: (value) {
        if (content.selected != value) {
          _selectedCount += value! ? 1 : -1;
          assert(_selectedCount >= 0);
          content.selected = value;
          notifyListeners();
        }
      },
      onTap: hasRowTaps
          ? () => _showSnackbar(context, 'Tapped on row ${content.id}')
          : null,
      // specificRowHeight:
      //     hasRowHeightOverrides && content.status >= 25 ? 100 : null,
      cells: [
        DataCell(Text(content.patient?.firstName.toString() ?? '')),
        DataCell(Text('${content.purpose}'),
            onTap: () => _showSnackbar(context,
                'Tapped on a cell with "${content.purpose}"', Colors.red)),
        DataCell(Text(content.status.toString())),
        DataCell(Text('${content.date}')),
      ],
    );
  }

  @override
  int get rowCount => contents.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => _selectedCount;
}

/// Async datasource for AsynPaginatedDataTabke2 example. Based on AsyncDataTableSource which
/// is an extension to FLutter's DataTableSource and aimed at solving
/// saync data fetching scenarious by paginated table (such as using Web API)
class DataSourceAsync extends AsyncDataTableSource {
  DataSourceAsync() {
    print('DessertDataSourceAsync created');
  }

  DataSourceAsync.empty() {
    _empty = true;
    print('DessertDataSourceAsync.empty created');
  }

  DataSourceAsync.error() {
    _errorCounter = 0;
    print('DessertDataSourceAsync.error created');
  }

  bool _empty = false;
  int? _errorCounter;
  ScheduleController? scheduleController;
  RangeValues? _caloriesFilter;

  RangeValues? get caloriesFilter => _caloriesFilter;
  set caloriesFilter(RangeValues? calories) {
    _caloriesFilter = calories;
    refreshDatasource();
  }

  String _sortColumn = "name";
  bool _sortAscending = true;

  void sort(String columnName, bool ascending) {
    _sortColumn = columnName;
    _sortAscending = ascending;
    refreshDatasource();
  }

  Future<int> getTotalRecords() {
    return Future<int>.delayed(
        const Duration(milliseconds: 0), () => _empty ? 0 : 0
        //_dessertsX3.length
        );
  }

  @override
  Future<AsyncRowsResponse> getRows(int start, int end) async {
    print('getRows($start, $end)');
    if (_errorCounter != null) {
      _errorCounter = _errorCounter! + 1;

      if (_errorCounter! % 2 == 1) {
        await Future.delayed(const Duration(milliseconds: 1000));
        throw 'Error #${((_errorCounter! - 1) / 2).round() + 1} has occured';
      }
    }

    var index = start;
    final format = NumberFormat.decimalPercentPattern(
      locale: 'en',
      decimalDigits: 0,
    );
    assert(index >= 0);

    // List returned will be empty is there're fewer items than startingAt
    var x = _empty
        ? await scheduleController?.callGetAllAppointments(index, end)
        : [];
    AppointmentsServiceResponse response = AppointmentsServiceResponse(
        scheduleController?.model.totalElements ?? 0,
        scheduleController?.model.content?.toList() ?? []);
    var r = AsyncRowsResponse(
        response.totalRecords,
        response.data.map((appointment) {
          return DataRow(
            key: ValueKey<int>(appointment.id ?? 0),
            selected: appointment.selected ?? false,
            onSelectChanged: (value) {
              if (value != null) {
                setRowSelection(ValueKey<int>(appointment.id ?? 0), value);
              }
            },
            cells: [
              DataCell(Text(appointment.patient?.firstName ?? '')),
              DataCell(Text('${appointment.patient?.lastName}')),
              DataCell(
                Text(appointment.note ?? ''),
                // DataCell(Text('${appointment..carbs}')),
                // DataCell(Text(dessert.protein.toStringAsFixed(1))),
                // DataCell(Text('${dessert.sodium}')),
                // DataCell(Text(format.format(dessert.calcium / 100))),
                // DataCell(Text(format.format(dessert.iron / 100))),
              )
            ],
          );
        }).toList());

    return r;
  }
}

class AppointmentsServiceResponse {
  AppointmentsServiceResponse(this.totalRecords, this.data);

  /// THe total ammount of records on the server, e.g. 100
  final int totalRecords;

  /// One page, e.g. 10 reocrds
  final List<AppointmentContent> data;
}

int _selectedCount = 0;

_showSnackbar(BuildContext context, String text, [Color? color]) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    backgroundColor: color,
    duration: const Duration(seconds: 1),
    content: Text(text),
  ));
}
