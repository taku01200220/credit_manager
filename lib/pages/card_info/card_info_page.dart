import 'package:credit_manager/importer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

class CardInfoPage extends HookConsumerWidget {
  const CardInfoPage({
    required this.id,
    required this.cardName,
    required this.closingDate,
    required this.paymentDate,
    required this.labelColor,
    Key? key,
  }) : super(key: key);

  final String id;
  final String cardName;
  final String closingDate;
  final String paymentDate;
  final String labelColor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    DateTime isConfirmDate(String closingDate) {
      late DateTime dt;
      if (int.parse((DateTime.now().day).toString()) <=
          int.parse(closingDate)) {
        final str =
            '${(DateTime.now().year).toString()}-${(DateTime.now().month).toString()}-$paymentDate';
        dt = DateFormat('yy-MM-dd').parse(str);
      } else if (int.parse((DateTime.now().day).toString()) >
          int.parse(closingDate)) {
        final str =
            '${(DateTime.now().year).toString()}-${(DateTime.now().month + 1).toString()}-$paymentDate';
        dt = DateFormat('yy-MM-dd').parse(str);
      }
      return dt;
    }

    DateTime isUnsettledDate(String closingDate) {
      late DateTime dt;
      if (int.parse((DateTime.now().day).toString()) <=
          int.parse(closingDate)) {
        final str =
            '${(DateTime.now().year).toString()}-${(DateTime.now().month + 1).toString()}-$paymentDate';
        dt = DateFormat('yy-MM-dd').parse(str);
      } else if (int.parse((DateTime.now().day).toString()) >
          int.parse(closingDate)) {
        final str =
            '${(DateTime.now().year).toString()}-${(DateTime.now().month + 2).toString()}-$paymentDate';
        dt = DateFormat('yy-MM-dd').parse(str);
      }
      return dt;
    }

    final selectedValue = useState('');
    final usStates = <String>['??????', '??????'];
    final unsettledDate = useState(isUnsettledDate(closingDate));
    final confirmDate = useState(isConfirmDate(closingDate));
    final detailEventListNotifier = ref.read(detailEventListProvider.notifier);
    final historyEventListNotifier =
        ref.read(historyEventListProvider.notifier);
    final eventState = ref.read(eventProvider);
    final cardListNotifier = ref.read(cardListProvider.notifier);
    final cardInfoListState = ref.watch(cardInfoListProvider);

    return Scaffold(
      appBar: AppBar(
        actions: [
          PopupMenuButton<String>(
            onSelected: (String s) {
              selectedValue.value = s;
              if (selectedValue.value == '??????') {
                context.go(
                  '/cardInfoPage/$id/$cardName/$closingDate/$paymentDate/$labelColor/editCardPage',
                );
              } else if (selectedValue.value == '??????') {
                EventFire().deleteCardWithEventFire(cardName);
                CardFire().deleteCardFire(id);
                ref.invalidate(futureHomeProvider);
                context.go('/');
              }
            },
            itemBuilder: (BuildContext context) {
              return usStates.map((String s) {
                return PopupMenuItem(
                  value: s,
                  child: Text(
                    s,
                    style:
                        TextStyle(color: s == '??????' ? Colors.red : Colors.black),
                  ),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Container(
                // ??????????????????????????????1??1.58???
                margin: const EdgeInsets.only(left: 30, right: 30),
                height: 200.h,
                width: 316.h,
                child: Card(
                  color: Colors.white, // Card????????????
                  elevation: 8, // ??????????????????
                  shadowColor: Colors.black, // ?????????
                  shape: RoundedRectangleBorder(
                    // ????????????????????????
                    borderRadius: BorderRadius.circular(10),
                  ),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: Column(
                    children: [
                      // card???labelColor
                      SizedBox(
                        height: 30.h,
                        width: 324.h,
                        child: Container(
                          color: stringifiedColorToColor(
                            labelColor,
                          ),
                        ),
                      ),

                      // ??????
                      SizedBox(
                        height: 10.h,
                      ),

                      // card?????????
                      ListTile(
                        leading: SvgPicture.asset(
                          'assets/icon/ic_chip.svg',
                          color: Colors.amber,
                          width: 32.h,
                          height: 32.h,
                        ),
                        title: Text(
                          cardName,
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      // ?????????????????????
                      InkWell(
                        onTap: () {
                          detailEventListNotifier.fetchDetailEventList(
                            eventState,
                            cardName,
                            DateTime(
                              DateTime.now().year,
                              unsettledDate.value.month,
                            ),
                            closingDate,
                          );
                          context.go(
                            '/cardInfoPage/$id/$cardName/$closingDate/$paymentDate/$labelColor/detailEventPage/${DateTime(DateTime.now().year, unsettledDate.value.month)}',
                          );
                        },
                        child: Stack(
                          children: [
                            SizedBox(
                              width: 428.h,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 12),
                                child: Row(
                                  children: [
                                    Text(
                                      DateFormat.MMMd('ja')
                                          .format(unsettledDate.value),
                                      style: TextStyle(fontSize: 20.sp),
                                    ),
                                    Text(
                                      ' ?????????',
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.centerRight,
                              width: 428.h,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 12),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      '?? ${ref.watch(unsettledPriceProvider)}',
                                      style: TextStyle(fontSize: 20.sp),
                                    ),
                                    const Icon(Icons.chevron_right),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // ??????
                      SizedBox(
                        height: 10.h,
                      ),

                      // ??????????????????
                      InkWell(
                        onTap: () {
                          detailEventListNotifier.fetchDetailEventList(
                            eventState,
                            cardName,
                            DateTime(
                              DateTime.now().year,
                              confirmDate.value.month,
                            ),
                            closingDate,
                          );
                          context.go(
                            '/cardInfoPage/$id/$cardName/$closingDate/$paymentDate/$labelColor/detailEventPage/${DateTime(DateTime.now().year, confirmDate.value.month)}',
                          );
                        },
                        child: Stack(
                          children: [
                            SizedBox(
                              width: 428.h,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 12),
                                child: Row(
                                  children: [
                                    Text(
                                      DateFormat.MMMd('ja')
                                          .format(confirmDate.value),
                                      style: TextStyle(fontSize: 20.sp),
                                    ),
                                    Text(
                                      ' ??????',
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.centerRight,
                              width: 428.h,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 12),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      '?? ${ref.watch(confirmPriceProvider)}',
                                      style: TextStyle(fontSize: 20.sp),
                                    ),
                                    const Icon(Icons.chevron_right),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ??????
              SizedBox(
                height: 16.h,
              ),

              // ???????????????????????????????????????
              SizedBox(
                width: 360.w,
                child: const Text(
                  '???????????????',
                  style: TextStyle(color: Colors.black),
                ),
              ),

              // ????????????????????????????????????
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: ref.watch(eventSortProvider).isEmpty
                    ? 1
                    : ref.watch(eventSortProvider).length,
                itemBuilder: (context, index) {
                  // ???????????????????????????????????????????????????Widget
                  if (ref.watch(eventSortProvider).isEmpty) {
                    return NoDataCase(
                      text: '????????????',
                      height: 30.h,
                      actionIcon: Icons.edit_note,
                      logoImg: false,
                    );
                  }
                  return ListTile(
                    title: Text(ref.watch(eventSortProvider)[index].detail),
                    subtitle: Text(
                      DateFormat.MMMEd('ja').format(
                        ref.watch(eventSortProvider)[index].registerDate,
                      ),
                    ),
                    trailing:
                        Text('?? ${ref.watch(eventSortProvider)[index].price}'),
                    onTap: () {
                      cardListNotifier.fetchCardList(cardInfoListState);
                      context.go(
                        '/cardInfoPage/$id/$cardName/$closingDate/$paymentDate/$labelColor/editEventPage/${ref.watch(eventSortProvider)[index].id}/${ref.watch(eventSortProvider)[index].price}/${ref.watch(eventSortProvider)[index].registerDate}/${ref.watch(eventSortProvider)[index].detail}',
                      );
                    },
                  );
                },
              ),
              Visibility(
                // ignore: avoid_bool_literals_in_conditional_expressions
                visible: ref.watch(eventSortProvider).isEmpty ? false : true,
                child: TextButton(
                  onPressed: () {
                    historyEventListNotifier.fetchHistoryEventList(
                      cardName,
                      eventState,
                      DateTime(DateTime.now().year, DateTime.now().month - 2),
                      DateTime(DateTime.now().year, DateTime.now().month + 1)
                          .add(const Duration(seconds: -1)),
                    );
                    context.go(
                      '/cardInfoPage/$id/$cardName/$closingDate/$paymentDate/$labelColor/historyEventPage',
                    );
                  },
                  child: const Text('??????'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
