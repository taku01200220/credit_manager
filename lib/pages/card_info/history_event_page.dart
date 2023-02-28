import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:credit_manager/importer.dart';
import 'package:intl/intl.dart';

class HistoryEventPage extends HookConsumerWidget {
  // const HistoryEventPage({Key? key}) : super(key: key);
  const HistoryEventPage({
    required this.id,
    required this.cardName,
    required this.closingDate,
    required this.paymentDate,
    required this.labelColor,
    // required this.month,
    Key? key,
  }) : super(key: key);
  final String id;
  final String cardName;
  final String closingDate;
  final String paymentDate;
  final String labelColor;
  // final DateTime month;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final startDate =
        useState(DateTime(DateTime.now().year, DateTime.now().month - 2, 1));
    final endDate = useState(
        DateTime(DateTime.now().year, DateTime.now().month + 1, 1)
            .add(Duration(seconds: -1)));

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ご利用履歴',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: ListView(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            children: [
              Stack(
                children: [
                  Container(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(cardName),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            child: Row(
                              children: [
                                Text(
                                    '${startDate.value.year}年${startDate.value.month}月'),
                                Icon(Icons.arrow_drop_down),
                              ],
                            ),
                            onTap: () async {
                              await DatePicker.showPicker(
                                context,
                                showTitleActions: true,
                                pickerModel: YearMonthModel(
                                  currentTime: startDate.value,
                                  minTime: DateTime(2020),
                                  maxTime: DateTime(
                                      endDate.value.year, endDate.value.month),
                                  locale: LocaleType.jp,
                                ),
                                onConfirm: (date) {
                                  startDate.value = DateTime(
                                    date.year,
                                    date.month,
                                  );
                                  ref
                                      .read(historyEventListProvider.notifier)
                                      .fetchHistoryEventList(
                                        cardName,
                                        ref.watch(eventProvider),
                                        startDate.value,
                                        endDate.value,
                                      );
                                },
                              );
                            },
                          ),
                          Text('~'),
                          GestureDetector(
                            child: Row(
                              children: [
                                Text(
                                    '${endDate.value.year}年${endDate.value.month}月'),
                                Icon(Icons.arrow_drop_down),
                              ],
                            ),
                            onTap: () async {
                              await DatePicker.showPicker(
                                context,
                                showTitleActions: true,
                                pickerModel: YearMonthModel(
                                  currentTime: endDate.value,
                                  minTime: DateTime(startDate.value.year,
                                      startDate.value.month),
                                  maxTime: DateTime(DateTime.now().year,
                                      DateTime.now().month),
                                  locale: LocaleType.jp,
                                ),
                                onConfirm: (date) {
                                  endDate.value = DateTime(
                                    date.year,
                                    date.month + 1,
                                  ).add(Duration(seconds: -1));
                                  ref
                                      .read(historyEventListProvider.notifier)
                                      .fetchHistoryEventList(
                                        cardName,
                                        ref.watch(eventProvider),
                                        startDate.value,
                                        endDate.value,
                                      );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              // 直近のイベント（リスト）
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: ref.watch(historyEventListProvider).isEmpty ? 1 : ref.watch(historyEventListProvider).length,
                itemBuilder: (context, index) {
                  // 直近のイベントがない場合に表示するWidgetを追記
                  if (ref.watch(historyEventListProvider).isEmpty) {
                    return NoDataCase(
                      text: 'イベント',
                      height: 30.h,
                      actionIcon: Icons.edit_note,
                      logoImg: false,
                    );
                  }
                  return ListTile(
                    title:
                        Text(ref.watch(historyEventListProvider)[index].detail),
                    subtitle: Text(DateFormat.yMMMd('ja').format(ref
                        .watch(historyEventListProvider)[index]
                        .registerDate)),
                    trailing: Text(
                        '¥ ${ref.watch(historyEventListProvider)[index].price}'),
                    onTap: () => context.go('/cardInfoPage/$id/$cardName/$closingDate/$paymentDate/$labelColor/editEventPage/${ref.watch(eventSortProvider)[index].id}/${ref.watch(eventSortProvider)[index].price}/${ref.watch(eventSortProvider)[index].registerDate}/${ref.watch(eventSortProvider)[index].detail}'),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
