import 'package:credit_manager/importer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

class AddEventPage extends HookConsumerWidget {
  const AddEventPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cardInfoListState = ref.watch(cardInfoListProvider);
    final cardListState = ref.watch(cardListProvider);
    final eventNotifier = ref.read(eventProvider.notifier);

    final price = useState(0);
    final cardName = useState(cardInfoListState[0].cardName);
    final registerDate = useState(DateTime.now());
    final detail = useState('');

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '支払いを追加',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            // 金額を入力
            const Padding(
              padding: EdgeInsets.only(left: 16, top: 8, right: 16),
              child: SizedBox(
                width: double.infinity,
                child: Text('金額'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: ListTile(
                  leading: const Icon(Icons.currency_yen),
                  title: TextFormField(
                    decoration: const InputDecoration(
                      hintText: '0',
                      border: InputBorder.none,
                    ),
                    onChanged: (value) => price.value = int.parse(value),
                  ),
                ),
              ),
            ),

            // カードの選択
            const Padding(
              padding: EdgeInsets.only(left: 16, top: 8, right: 16),
              child: SizedBox(
                width: double.infinity,
                child: Text('カード'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: ListTile(
                  leading: const Icon(Icons.credit_card),
                  title: DropdownButton<String>(
                    underline: Container(),
                    isExpanded: true,
                    value: cardName.value,
                    onChanged: (String? value) {
                      cardName.value = value!;
                    },
                    items: cardListState
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),

            // 日付の選択
            const Padding(
              padding: EdgeInsets.only(left: 16, top: 8, right: 16),
              child: SizedBox(
                width: double.infinity,
                child: Text('日付'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: ListTile(
                  leading: const Icon(Icons.today),
                  title: Text(
                    DateFormat.MMMEd('ja').format(registerDate.value),
                  ),
                  onTap: () {
                    DatePicker.showDatePicker(
                      context,
                      minTime: DateTime(2020),
                      maxTime: DateTime(2040, 12, 31),
                      onConfirm: (date) {
                        registerDate.value = DateTime(
                          date.year,
                          date.month,
                          date.day,
                          DateTime.now().hour,
                          DateTime.now().minute,
                          DateTime.now().second,
                        );
                      },
                      currentTime: registerDate.value,
                      locale: LocaleType.jp,
                    );
                  },
                ),
              ),
            ),

            // 支払いの詳細
            const Padding(
              padding: EdgeInsets.only(left: 16, top: 8, right: 16),
              child: SizedBox(
                width: double.infinity,
                child: Text('詳細'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: ListTile(
                  leading: const Icon(Icons.edit_note),
                  title: TextFormField(
                    decoration: const InputDecoration(
                      hintText: '例）コンビニ',
                      border: InputBorder.none,
                    ),
                    onChanged: (value) => detail.value = value,
                  ),
                ),
              ),
            ),

            // イベントの追加ボタン
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: TextButton(
                child: const Text('支払いを追加'),
                onPressed: () {
                  EventFire().addEventFire(
                    price.value,
                    cardName.value,
                    registerDate.value,
                    detail.value,
                  );
                  // 毎回firebaseから全て読み込むのは効率悪いので、
                  // stateにaddすることでviewを更新したほうがいいかも
                  eventNotifier.fetchEvent();
                  context.go('/');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
