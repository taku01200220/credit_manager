import 'package:credit_manager/importer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

class EditEventPage extends HookConsumerWidget {
  // const EditEventPage({Key? key}) : super(key: key);
  const EditEventPage({
    required this.id,
    required this.cardName,
    required this.closingDate,
    required this.paymentDate,
    required this.labelColor,
    required this.eventId,
    required this.price,
    required this.registerDate,
    required this.detail,
    Key? key,
  }) : super(key: key);
  final String id;
  final String cardName;
  final String closingDate;
  final String paymentDate;
  final String labelColor;
  final String eventId;
  final int price;
  final DateTime registerDate;
  final String detail;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cardListState = ref.watch(cardListProvider);
    final eventSortNotifier = ref.read(eventSortProvider.notifier);
    final confirmPriceNotifier = ref.read(confirmPriceProvider.notifier);
    final unsettledPriceNotifier = ref.read(unsettledPriceProvider.notifier);

    // final itemValue = useState('au pay');
    final eventPrice = useState(price);
    final eventCardName = useState(cardName);
    final eventRegisterDate = useState(registerDate);
    final eventDetail = useState(detail);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '支払いを編集',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.delete,
              color: Colors.red,
            ),
            onPressed: () async {
              await EventFire().deleteEventFire(eventId);
              await ref.read(eventProvider.notifier).fetchEvent();
              // cardInfoPageに表示する直近４件のイベントをリスト化
              await eventSortNotifier.fetchRecentlyEvent(
                cardName,
                ref.read(eventProvider),
              );
              // 確定分のPriceを計算
              confirmPriceNotifier.calcConfirmPrice(
                ref.read(eventProvider),
                cardName,
                closingDate,
              );
              // 未確定分のPriceを計算
              unsettledPriceNotifier.calcUnsettledPrice(
                ref.read(eventProvider),
                cardName,
                closingDate,
              );
              context.pop();
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16, top: 8, right: 16),
              child: Container(
                width: double.infinity,
                child: Text('金額'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: ListTile(
                  leading: Icon(Icons.currency_yen),
                  title: TextFormField(
                    initialValue: eventPrice.value.toString(),
                    decoration: const InputDecoration(
                      hintText: '1,000',
                      border: InputBorder.none,
                    ),
                    onChanged: (value) => eventPrice.value = int.parse(value),
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
                    value: eventCardName.value,
                    onChanged: (String? value) {
                      eventCardName.value = value!;
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
                    DateFormat.MMMEd('ja').format(eventRegisterDate.value),
                  ),
                  onTap: () {
                    DatePicker.showDatePicker(
                      context,
                      minTime: DateTime(2020),
                      maxTime: DateTime(2040, 12, 31),
                      onConfirm: (date) {
                        eventRegisterDate.value = DateTime(
                          date.year,
                          date.month,
                          date.day,
                          DateTime.now().hour,
                          DateTime.now().minute,
                          DateTime.now().second,
                        );
                      },
                      currentTime: eventRegisterDate.value,
                      locale: LocaleType.jp,
                    );
                  },
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(left: 16, top: 8, right: 16),
              child: Container(
                width: double.infinity,
                child: Text('詳細'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: ListTile(
                  leading: Icon(
                    Icons.edit_note,
                    // color: Colors.red,
                  ),
                  title: TextFormField(
                    initialValue: eventDetail.value,
                    decoration: const InputDecoration(
                      hintText: '例）コンビニ',
                      border: InputBorder.none,
                    ),
                    onChanged: (value) => eventDetail.value = value,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: TextButton(
                child: Text('支払いを更新'),
                onPressed: () async {
                  await EventFire().updateEventFire(
                    eventId,
                    eventPrice.value,
                    eventCardName.value,
                    eventRegisterDate.value,
                    eventDetail.value,
                  );
                  await ref.read(eventProvider.notifier).fetchEvent();
                  // cardInfoPageに表示する直近４件のイベントをリスト化
                  await eventSortNotifier.fetchRecentlyEvent(
                    cardName,
                    ref.read(eventProvider),
                  );
                  // 確定分のPriceを計算
                  confirmPriceNotifier.calcConfirmPrice(
                    ref.read(eventProvider),
                    cardName,
                    closingDate,
                  );
                  // 未確定分のPriceを計算
                  unsettledPriceNotifier.calcUnsettledPrice(
                    ref.read(eventProvider),
                    cardName,
                    closingDate,
                  );
                  // ignore: use_build_context_synchronously
                  context.pop();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
