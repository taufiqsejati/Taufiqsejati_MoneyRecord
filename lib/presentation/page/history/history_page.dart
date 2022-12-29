import 'package:money_record/library/library.dart';
import 'package:intl/intl.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({
    super.key,
  });

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final cHistory = Get.put(CHistory());
  final cUser = Get.put(CUser());
  final controllerSearch = TextEditingController();

  refresh() {
    cHistory.getList(cUser.data.idUser);
  }

  delete(BuildContext ctx, String idHistory) async {
    bool? yes = await DInfo.dialogConfirmation(
        context, 'Hapus', 'Yakin untuk menghapus history ini?',
        textNo: 'Batal', textYes: 'Ya');

    if (yes!) {
      bool success = await SourceHistory.delete(ctx, idHistory);
      if (success) refresh();
    }
  }

  @override
  void initState() {
    refresh();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text('Riwayat'),
            Expanded(
                child: Container(
              height: 40,
              margin: const EdgeInsets.all(16),
              child: TextField(
                controller: controllerSearch,
                onTap: () async {
                  DateTime? result = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2022, 01, 01),
                      lastDate: DateTime(DateTime.now().year + 1));

                  if (result != null) {
                    controllerSearch.text =
                        DateFormat('yyyy-MM-dd').format(result);
                  }
                },
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none),
                    filled: true,
                    fillColor: AppColor.chart.withOpacity(0.5),
                    suffixIcon: IconButton(
                      onPressed: () {
                        cHistory.search(
                            cUser.data.idUser, controllerSearch.text);
                      },
                      icon: const Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                    ),
                    hintText: '2022-06-01',
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 0, horizontal: 16)),
                textAlignVertical: TextAlignVertical.center,
                style: const TextStyle(color: Colors.white),
              ),
            ))
          ],
        ),
      ),
      body: SafeArea(
        child: GetBuilder<CHistory>(builder: (_) {
          if (_.loading) return DView.loadingCircle();
          if (_.list.isEmpty) return DView.empty('Kosong');
          return RefreshIndicator(
            onRefresh: () async => refresh(),
            child: ListView.builder(
              itemCount: _.list.length,
              itemBuilder: (context, index) {
                History history = _.list[index];
                return Card(
                  elevation: 4,
                  margin: EdgeInsets.fromLTRB(16, index == 0 ? 16 : 8, 16,
                      index == _.list.length - 1 ? 16 : 8),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(4),
                    onTap: () {
                      Get.to(() => DetailHistoryPage(
                            idUser: cUser.data.idUser!,
                            date: history.date!,
                            type: history.type!,
                          ));
                    },
                    child: Row(
                      children: [
                        DView.spaceWidth(),
                        if (history.type == 'Pemasukan')
                          Icon(
                            Icons.south_west,
                            color: Colors.green[300],
                          )
                        else
                          Icon(
                            Icons.north_east,
                            color: Colors.red[300],
                          ),
                        DView.spaceWidth(),
                        Text(
                          AppFormat.date(history.date!),
                          style: const TextStyle(
                              color: AppColor.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                        Expanded(
                            child: Text(
                          AppFormat.currency(history.total!),
                          style: const TextStyle(
                              color: AppColor.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                          textAlign: TextAlign.end,
                        )),
                        IconButton(
                            onPressed: () =>
                                delete(context, history.idHistory!),
                            icon: Icon(
                              Icons.delete_forever,
                              color: Colors.red[300],
                            ))
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        }),
      ),
    );
  }
}
