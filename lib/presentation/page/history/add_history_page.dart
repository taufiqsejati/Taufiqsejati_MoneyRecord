import 'package:money_record/library/library.dart';
import 'package:d_input/d_input.dart';
import 'package:intl/intl.dart';

class AddHistoryPage extends StatefulWidget {
  AddHistoryPage({super.key});

  @override
  State<AddHistoryPage> createState() => _AddHistoryPageState();
}

class _AddHistoryPageState extends State<AddHistoryPage> {
  final cAddHistory = Get.put(CAddHistory());

  final cUser = Get.put(CUser());

  final controllerName = TextEditingController();

  final controllerPrice = TextEditingController();

  addHistory() async {
    bool success = await SourceHistory.add(
        context,
        cUser.data.idUser!,
        cAddHistory.date,
        cAddHistory.type,
        jsonEncode(cAddHistory.items),
        cAddHistory.total.toString());

    if (success) {
      Future.delayed(const Duration(milliseconds: 3000), () {
        Get.back(result: true);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DView.appBarLeft('Tambah Baru'),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text(
              'Tanggal',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                Obx(() {
                  return Text(cAddHistory.date);
                }),
                DView.spaceWidth(),
                ElevatedButton.icon(
                  onPressed: () async {
                    var result = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(
                          2022,
                          01,
                          01,
                        ),
                        lastDate: DateTime(DateTime.now().year + 1));
                    if (result != null) {
                      cAddHistory
                          .setDate(DateFormat('yyyy-MM-dd').format(result));
                    }
                  },
                  icon: const Icon(
                    Icons.event,
                  ),
                  label: const Text('Pilih'),
                )
              ],
            ),
            DView.spaceHeight(),
            const Text(
              'Tipe',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            DView.spaceHeight(4),
            DropdownButtonFormField(
              value: cAddHistory.type,
              items: ['Pemasukan', 'Pengeluaran'].map((e) {
                return DropdownMenuItem(
                  child: Text(e),
                  value: e,
                );
              }).toList(),
              onChanged: (value) {
                cAddHistory.setType(value);
              },
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), isDense: true),
            ),
            DView.spaceHeight(),
            DInput(
              controller: controllerName,
              hint: 'Jualan',
              title: 'Sumber/Objek',
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
                  cAddHistory.addItem({
                    'name': controllerName.text,
                    'price': controllerPrice.text,
                  });
                  controllerName.clear();
                  controllerPrice.clear();
                },
                child: const Text('Tambah ke Items')),
            DView.spaceHeight(),
            Center(
              child: Container(
                height: 5,
                width: 80,
                decoration: BoxDecoration(
                    color: AppColor.bg,
                    borderRadius: BorderRadius.circular(30)),
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
                  border: Border.all(
                    color: Colors.grey,
                  ),
                  borderRadius: BorderRadius.circular(8)),
              child: GetBuilder<CAddHistory>(builder: (_) {
                return Wrap(
                    runSpacing: 0,
                    spacing: 8,
                    children: List.generate(_.items.length, (index) {
                      return Chip(
                        label: Text(_.items[index]['name']),
                        deleteIcon: const Icon(Icons.clear),
                        onDeleted: () => _.deleteItem(index),
                      );
                    }));
              }),
            ),
            DView.spaceHeight(),
            Row(
              children: [
                Text(
                  'Total :',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                DView.spaceWidth(8),
                Obx(() {
                  return Text(
                    AppFormat.currency(cAddHistory.total.toString()),
                    style: Theme.of(context).textTheme.headline5!.copyWith(
                        fontWeight: FontWeight.bold, color: AppColor.primary),
                  );
                }),
              ],
            ),
            DView.spaceHeight(30),
            Material(
              color: AppColor.primary,
              borderRadius: BorderRadius.circular(8),
              child: InkWell(
                onTap: () => addHistory(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Center(
                    child: Text(
                      'Submit',
                      style: Theme.of(context).textTheme.headline5!.copyWith(
                          fontWeight: FontWeight.bold, color: Colors.white),
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
