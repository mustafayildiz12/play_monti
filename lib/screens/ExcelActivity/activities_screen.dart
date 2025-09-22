import 'package:flutter/material.dart';
import 'package:play_monti/screens/ExcelActivity/activity_ds.dart';
import 'package:play_monti/service/activty_service.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

/// --- SAYFA ---
class ActivitiesTablePage extends StatefulWidget {
  const ActivitiesTablePage({super.key});

  @override
  State<ActivitiesTablePage> createState() => _ActivitiesTablePageState();
}

class _ActivitiesTablePageState extends State<ActivitiesTablePage> {
  // Dropdown verileri
  static const List<String> ageOptions = [
    '18-24',
    '24-36',
    '36-48',
    '48-60',
  ];
  static const List<String> langOptions = ['tr', 'en'];

  String? selectedAge;
  String? selectedLang;

  // UI
  final TextEditingController _searchCtrl = TextEditingController();
  bool isLoading = false;
  String? errorText;

  // DataGrid
  final int rowsPerPage = 20;
  ActivitiesDataSource? dataSource;
  List<String> columns = [
    // Düzenlenebilir: model kolonlarını burada belirtiyoruz.
    // Modelin toJson'undan geliyor; yoksa dataSource._mapFromModel'i güncelle.
    'day'
        'activity_name'
        'age_group'
        'activity_type'
        'improvement_area'
        'materials'
        'step_by_step'
        'clue'
        'emoji'
        'warning_text'
        'apothegm'
  ];

  // Veri yükleme
  Future<void> _load() async {
    if (selectedAge == null || selectedLang == null) return;
    setState(() {
      isLoading = true;
      errorText = null;
    });
    try {
      // --- Senin mevcut fonksiyonunu burada çağır ---
      final list = await activityService.getAllActivities(
          age: selectedAge ?? "18-24", language: selectedLang ?? "tr");

      // Kolonları dinamik tespit etmek istersen (opsiyonel):
      if (list.isNotEmpty) {
        list.sort((a, b) => a.day.compareTo(b.day));
        final keys = list.first.toJson().keys.toList();
        // En fazla 8 kolonla sınırla, id/title varsa öne al
        keys.sort((a, b) {
          int score(String k) =>
              (k == 'id') ? 0 : (k.toLowerCase().contains('title') ? 1 : 2);
          return score(a).compareTo(score(b));
        });
        columns = keys.take(11).toList(growable: false);
      }

      dataSource = ActivitiesDataSource(columns: columns, original: list);
      // Arama kutusu doluysa mevcut filtreyi uygula
      if (_searchCtrl.text.isNotEmpty) {
        dataSource!.filter(_searchCtrl.text);
      }
    } catch (e) {
      errorText = 'Veri yüklenirken hata oluştu: $e';
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final canFetch = selectedAge != null && selectedLang != null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Activities'),
      ),
      body: Column(
        children: [
          // Filtre bar
          Padding(
            padding: const EdgeInsets.all(12),
            child: Wrap(
              spacing: 12,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                // Age dropdown
                SizedBox(
                  width: 180,
                  child: DropdownButtonFormField<String>(
                    initialValue: selectedAge,
                    decoration: const InputDecoration(
                      labelText: 'Age',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    items: [
                      const DropdownMenuItem(value: null, child: Text('')),
                      ...ageOptions.map(
                          (e) => DropdownMenuItem(value: e, child: Text(e))),
                    ],
                    onChanged: (v) async {
                      setState(() => selectedAge = v);
                      if (selectedLang != null && v != null) {
                        await _load();
                      }
                    },
                  ),
                ),
                // Language dropdown
                SizedBox(
                  width: 140,
                  child: DropdownButtonFormField<String>(
                    initialValue: selectedLang,
                    decoration: const InputDecoration(
                      labelText: 'Language',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    items: [
                      const DropdownMenuItem(value: null, child: Text('')),
                      ...langOptions.map((e) => DropdownMenuItem(
                          value: e, child: Text(e.toUpperCase()))),
                    ],
                    onChanged: (v) async {
                      setState(() => selectedLang = v);
                      if (selectedAge != null && v != null) {
                        await _load();
                      }
                    },
                  ),
                ),
                // Yenile
                ElevatedButton.icon(
                  onPressed: canFetch && !isLoading ? _load : null,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Yenile'),
                ),
                // Temizle
                TextButton.icon(
                  onPressed: () {
                    setState(() {
                      selectedAge = null;
                      selectedLang = null;
                      dataSource = null;
                      _searchCtrl.clear();
                    });
                  },
                  icon: const Icon(Icons.clear),
                  label: const Text('Temizle'),
                ),
                // Arama
                SizedBox(
                  width: 260,
                  child: TextField(
                    controller: _searchCtrl,
                    enabled: dataSource != null && !isLoading,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      hintText: 'Ara...',
                      isDense: true,
                      border: const OutlineInputBorder(),
                      suffixIcon: _searchCtrl.text.isEmpty
                          ? null
                          : IconButton(
                              onPressed: () {
                                _searchCtrl.clear();
                                dataSource?.filter('');
                                setState(() {});
                              },
                              icon: const Icon(Icons.close),
                            ),
                    ),
                    onChanged: (t) => dataSource?.filter(t),
                  ),
                ),
                if (isLoading)
                  const Padding(
                    padding: EdgeInsets.only(left: 8),
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
              ],
            ),
          ),
          if (errorText != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  errorText!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            ),

          // Tablo + Pager
          Expanded(
            child: dataSource == null
                ? Center(
                    child: Text(
                      canFetch
                          ? (isLoading
                              ? 'Yükleniyor...'
                              : 'Filtre seçildiğinde veri yüklenecek')
                          : 'Lütfen Age ve Language seçin',
                    ),
                  )
                : Column(
                    children: [
                      Expanded(
                        child: SfDataGridTheme(
                          data: SfDataGridThemeData(
                            headerColor: Theme.of(context)
                                .colorScheme
                                .surfaceContainerHighest,
                          ),
                          child: SfDataGrid(
                            source: dataSource!,
                            allowSorting: true,
                            columnWidthMode: ColumnWidthMode.fill,
                            gridLinesVisibility: GridLinesVisibility.horizontal,
                            headerGridLinesVisibility:
                                GridLinesVisibility.horizontal,
                            columns: columns
                                .map(
                                  (c) => GridColumn(
                                    columnName: c,
                                    allowSorting: true,
                                    width: 250,
                                    columnWidthMode: ColumnWidthMode.fill,
                                    label: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12),
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        c.toUpperCase(),
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

/// DataPager ile DataGridSource'u bağlamak için küçük bir delegate.
/// (DataGridSource satırları zaten tutuyor; burada yalnızca "view"u sayfalıyoruz.)
class _PagerDelegate extends DataPagerDelegate {
  final ActivitiesDataSource dataSource;
  final int rowsPerPage;

  _PagerDelegate(this.dataSource, {required this.rowsPerPage});

  int _startRowIndex = 0;

  @override
  int get rowCount => dataSource.rows.length;

  @override
  List<DataGridRow> provideRows(int startIndex, int endIndex) {
    _startRowIndex = startIndex;
    return dataSource.rows.getRange(startIndex, endIndex).toList();
  }
}
