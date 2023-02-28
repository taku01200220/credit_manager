import 'package:credit_manager/importer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

class YearMonthModel extends DatePickerModel {
  YearMonthModel({
    required DateTime currentTime,
    required DateTime minTime,
    required DateTime maxTime,
    required LocaleType locale,
  }) : super(
          locale: locale,
          minTime: minTime,
          maxTime: maxTime,
          currentTime: currentTime,
        );

  @override
  List<int> layoutProportions() {
    return [1, 1, 0];
  }
}

class DetailEventPage extends HookConsumerWidget {
  const DetailEventPage({
    required this.id,
    required this.cardName,
    required this.closingDate,
    required this.paymentDate,
    required this.labelColor,
    required this.month,
    Key? key,
  }) : super(key: key);
  final String id;
  final String cardName;
  final String closingDate;
  final String paymentDate;
  final String labelColor;
  final DateTime month;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectMonth = useState(month);
    final detailEventListNotifier = ref.read(detailEventListProvider.notifier);
    final eventState = ref.read(eventProvider);

    int calcPrice(List<Event> events) {
      var price = 0;
      for (var i = 0; i < events.length; i++) {
        price += events[i].price;
      }
      return price;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ご利用明細',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: ListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              Stack(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(cardName),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: GestureDetector(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                                '${selectMonth.value.year}年${selectMonth.value.month}月ご請求分'),
                            const Icon(Icons.arrow_drop_down),
                          ],
                        ),
                        onTap: () async {
                          await DatePicker.showPicker(
                            context,
                            // showTitleActions: true,
                            pickerModel: YearMonthModel(
                              currentTime: selectMonth.value,
                              minTime: DateTime(2020),
                              maxTime: DateTime(
                                DateTime.now().year,
                                DateTime.now().month + 2,
                              ),
                              locale: LocaleType.jp,
                            ),
                            onConfirm: (date) {
                              selectMonth.value = DateTime(
                                date.year,
                                date.month,
                                // date.day,
                                // DateTime.now().hour,
                                // DateTime.now().minute,
                                // DateTime.now().second,
                              );
                              detailEventListNotifier.fetchDetailEventList(
                                eventState,
                                cardName,
                                DateTime(
                                  selectMonth.value.year,
                                  selectMonth.value.month,
                                ),
                                closingDate,
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
              ListTile(
                tileColor: Colors.white,
                title: const Text('ご請求額'),
                trailing: Text('¥ ${calcPrice(ref.watch(detailEventListProvider))}', style: TextStyle(fontWeight: FontWeight.bold),),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: ref.watch(detailEventListProvider).isEmpty
                    ? 1
                    : ref.watch(detailEventListProvider).length,
                itemBuilder: (context, index) {
                  // イベントがない場合のWidgetを追記
                  if (ref.watch(detailEventListProvider).isEmpty) {
                    return NoDataCase(
                      text: 'イベント',
                      height: 30.h,
                      actionIcon: Icons.edit_note,
                      logoImg: false,
                    );
                  }
                  return ListTile(
                    title:
                        Text(ref.watch(detailEventListProvider)[index].detail),
                    subtitle: Text(
                      DateFormat.MMMEd('ja').format(ref
                          .watch(detailEventListProvider)[index]
                          .registerDate),
                    ),
                    trailing: Text(
                      '¥ ${ref.watch(detailEventListProvider)[index].price}',
                    ),
                    onTap: () => context.go(
                      '/cardInfoPage/$id/$cardName/$closingDate/$paymentDate/$labelColor/editEventPage/${ref.watch(eventSortProvider)[index].id}/${ref.watch(eventSortProvider)[index].price}/${ref.watch(eventSortProvider)[index].registerDate}/${ref.watch(eventSortProvider)[index].detail}',
                    ),
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
