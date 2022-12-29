import 'package:d_input/d_input.dart';
import 'package:intl/intl.dart';
import 'package:money_record/library/library.dart';

class UpdateHistoryPage extends StatefulWidget {
  const UpdateHistoryPage(
      {super.key,
      required this.date,
      required this.idHistory,
      required this.type});
  final String date;
  final String idHistory;
  final String type;

  @override
  State<UpdateHistoryPage> createState() => _UpdateHistoryPageState();
}

class _UpdateHistoryPageState extends State<UpdateHistoryPage> {
  final cUpdateHistory = Get.put(CUpdateHistory());
  final cUser = Get.put(CUser());
  final controllerName = TextEditingController();
  final controllerPrice = TextEditingController();

  updateHistory() async {
    bool success = await SourceHistory.update(
        context,
        widget.idHistory,
        cUser.data.idUser!,
        cUpdateHistory.date,
        cUpdateHistory.type,
        jsonEncode(cUpdateHistory.items),
        cUpdateHistory.total.toString());

    if (success) {
      Future.delayed(const Duration(milliseconds: 3000), () {
        Get.back(result: true);
      });
    }
  }

  @override
  void initState() {
    debugPrint('test2: ${widget.idHistory} ${cUpdateHistory.type}');
    cUpdateHistory.init(
      cUser.data.idUser,
      widget.date,
      widget.type,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DView.appBarLeft('Update'),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              'Tanggal',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                Obx(() {
                  return Text(cUpdateHistory.date);
                }),
                DView.spaceWidth(),
                ElevatedButton.icon(
                  onPressed: () async {
                    DateTime? result = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2022, 01, 01),
                      lastDate: DateTime(DateTime.now().year + 1),
                    );
                    if (result != null) {
                      cUpdateHistory
                          .setDate(DateFormat('yyyy-MM-dd').format(result));
                    }
                  },
                  icon: const Icon(Icons.event),
                  label: const Text('Pilih'),
                ),
              ],
            ),
            DView.spaceHeight(),
            const Text(
              'Tipe',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            DView.spaceHeight(4),
            Obx(() {
              return DropdownButtonFormField(
                value: cUpdateHistory.type,
                items: ['Pemasukan', 'Pengeluaran'].map((e) {
                  return DropdownMenuItem(
                    value: e,
                    child: Text(e),
                  );
                }).toList(),
                onChanged: (value) {
                  cUpdateHistory.setType(value);
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
              );
            }),
            DView.spaceHeight(),
            DInput(
              controller: controllerName,
              hint: 'Jualan',
              title: 'Sumber/Objek Pengeluaran',
            ),
            DView.spaceHeight(),
            DInput(
              controller: controllerPrice,
              hint: '30000',
              title: 'Harga',
              inputType: TextInputType.number,
            ),
            DView.spaceHeight(),
            ElevatedButton(
              onPressed: () {
                cUpdateHistory.addItem({
                  'name': controllerName.text,
                  'price': controllerPrice.text,
                });
                controllerName.clear();
                controllerPrice.clear();
              },
              child: const Text('Tambah ke Items'),
            ),
            DView.spaceHeight(),
            Center(
              child: Container(
                height: 5,
                width: 80,
                decoration: BoxDecoration(
                  color: AppColor.bg,
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
            DView.spaceHeight(),
            const Text(
              'Items',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            DView.spaceHeight(8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey),
              ),
              child: GetBuilder<CUpdateHistory>(builder: (_) {
                return Wrap(
                  runSpacing: 0,
                  spacing: 8,
                  children: List.generate(_.items.length, (index) {
                    return Chip(
                      label: Text(_.items[index]['name']),
                      deleteIcon: const Icon(Icons.clear),
                      onDeleted: () => _.deleteItem(index),
                    );
                  }),
                );
              }),
            ),
            DView.spaceHeight(),
            Row(
              children: [
                const Text(
                  'Total:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                DView.spaceWidth(8),
                Obx(() {
                  return Text(
                    AppFormat.currency(cUpdateHistory.total.toString()),
                    style: Theme.of(context).textTheme.headline5!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColor.primary,
                        ),
                  );
                }),
              ],
            ),
            DView.spaceHeight(30),
            Material(
              color: AppColor.primary,
              borderRadius: BorderRadius.circular(8),
              child: InkWell(
                onTap: () => updateHistory(),
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Center(
                    child: Text(
                      'SUBMIT',
                      style: Theme.of(context).textTheme.headline6!.copyWith(
                            color: Colors.white,
                          ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
