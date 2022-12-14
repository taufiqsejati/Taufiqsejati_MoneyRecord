import 'package:get/get.dart';
import 'package:money_record/data/source/source_history.dart';

class CHome extends GetxController {
  final _today = 0.0.obs;
  double get today => _today.value;

  final _todayPercent = '0'.obs;
  String get todayPercent => _todayPercent.value;

  final _week = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0].obs;
  List<double> get week => _week.value;

  getAnalysis(String idUser) async {
    Map data = await SourceHistory.analysis(idUser);

    // today outcome
    _today.value = data['today'].toDouble();
    double yesterday = data['yesterday'].toDouble();
    double different = (today - yesterday).abs();
    bool isSame = today.isEqual(yesterday);
    bool isPlus = today.isGreaterThan(yesterday);
    double dividerToday = (today + yesterday) == 0 ? 1 : (today + yesterday);
    double percent = (different / dividerToday) * 100;
    _todayPercent.value = isSame
        ? '100% sama dengan kemarin'
        : isPlus
            ? '+${percent.toStringAsFixed(1)}% dibanding kemarin'
            : '-${percent.toStringAsFixed(1)}% dibanding kemarin';

    _week.value = data['yesterday'].map((e) => e.toDouble()).toList();
  }
}
