import 'package:money_record/library/library.dart';

class CDetailHistory extends GetxController {
  final _data = History().obs;
  History get data => _data.value;

  getData(idUser, date, type) async {
    History? history = await SourceHistory.detail(idUser, date, type);
    _data.value = history ?? History();
    update();
  }
}
