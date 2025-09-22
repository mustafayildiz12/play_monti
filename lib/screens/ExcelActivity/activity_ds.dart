import 'package:flutter/material.dart';
import 'package:play_monti/models/final_activity_model.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

/// --- DATA SOURCE ---
class ActivitiesDataSource extends DataGridSource {
  final List<String> columns;
  final List<FinalActivityModel> original; // tam liste
  List<FinalActivityModel> _view; // arama/sıralama sonrası görüntü
  List<DataGridRow> _rows = [];

  ActivitiesDataSource({
    required this.columns,
    required this.original,
  }) : _view = List.of(original) {
    _buildRows();
  }

  void _buildRows() {
    _rows = _view.map((m) {
      final map = _mapFromModel(m);
      return DataGridRow(
        cells: columns
            .map((c) => DataGridCell<String>(
                  columnName: c,
                  value: _string(map[c]),
                ))
            .toList(),
      );
    }).toList();
    notifyListeners();
  }

  /// Arama
  void filter(String query) {
    if (query.isEmpty) {
      _view = List.of(original);
    } else {
      final q = query.toLowerCase();
      _view = original.where((m) {
        final map = _mapFromModel(m);
        return columns.any((c) => _string(map[c]).toLowerCase().contains(q));
      }).toList();
    }
    _buildRows();
  }

  @override
  List<DataGridRow> get rows => _rows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map((cell) {
        return Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Text(
            _truncate(cell.value?.toString() ?? ''),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        );
      }).toList(),
    );
  }

  // --- yardımcılar ---
  static Map<String, dynamic> _mapFromModel(FinalActivityModel m) {
    // Eğer modelinde toJson yoksa burayı düzenle. Örn:
    // return {
    //   'id': m.id,
    //   'title': m.title,
    //   'category': m.category,
    //   'difficulty': m.difficulty,
    //   'duration': m.duration,
    //   'age': m.ageRange,
    //   'language': m.lang,
    // };
    return m.toJson();
  }

  static String _string(dynamic v) => v?.toString() ?? '';

  static String _truncate(String s, {int max = 60}) {
    if (s.length <= max) return s;
    return '${s.substring(0, max - 1)}…';
  }
}
