import 'dart:io';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';

class ExportService {
  Future<File> exportCsv(List<Map<String, dynamic>> rows) async {
    final csv = const ListToCsvConverter().convert([
      ['Title','Amount','Date','Category'],
      ...rows.map((r)=>[r['title'], r['amount'], r['date'], r['category']]),
    ]);
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/expenses.csv');
    return file.writeAsString(csv);
  }

  Future<File> exportPdf(List<Map<String, dynamic>> rows) async {
    final pdf = pw.Document();
    pdf.addPage(pw.Page(build: (ctx) {
      return pw.Table.fromTextArray(
        headers: ['Title','Amount','Date','Category'],
        data: rows.map((r)=>[r['title'], r['amount'].toString(), r['date'], r['category']]).toList(),
      );
    }));
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/expenses.pdf');
    await file.writeAsBytes(await pdf.save());
    return file;
  }

  Future<void> shareFile(File file) => Share.shareXFiles([XFile(file.path)]);
}
