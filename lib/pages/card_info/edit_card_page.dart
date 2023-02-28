import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:credit_manager/importer.dart';

class EditCardPage extends HookConsumerWidget {
  const EditCardPage({
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
    final eventSortNotifier = ref.read(eventSortProvider.notifier);
    final confirmPriceNotifier = ref.read(confirmPriceProvider.notifier);
    final unsettledPriceNotifier = ref.read(unsettledPriceProvider.notifier);

    final name = useState(cardName);
    final closing = useState(closingDate);
    final payment = useState(paymentDate);
    final color = useState(labelColor);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'カードを編集',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            // カード名
            const Padding(
              padding: EdgeInsets.only(left: 16, top: 8, right: 16),
              child: SizedBox(
                width: double.infinity,
                child: Text('カード名'),
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
                  title: TextFormField(
                    initialValue: name.value,
                    decoration: const InputDecoration(
                      hintText: 'カード名',
                      border: InputBorder.none,
                    ),
                    onChanged: (value) => name.value = value,
                  ),
                ),
              ),
            ),

            // 締日
            const Padding(
              padding: EdgeInsets.only(left: 16, top: 8, right: 16),
              child: SizedBox(
                width: double.infinity,
                child: Text('締日'),
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
                  title: TextFormField(
                    initialValue: closing.value,
                    decoration: const InputDecoration(
                      hintText: '0',
                      border: InputBorder.none,
                    ),
                    onChanged: (value) => closing.value = value,
                  ),
                  trailing: const Text('日'),
                ),
              ),
            ),

            // 支払日
            const Padding(
              padding: EdgeInsets.only(left: 16, top: 8, right: 16),
              child: SizedBox(
                width: double.infinity,
                child: Text('支払日'),
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
                  title: TextFormField(
                    initialValue: payment.value,
                    decoration: const InputDecoration(
                      hintText: '0',
                      border: InputBorder.none,
                    ),
                    onChanged: (value) => payment.value = value,
                  ),
                  trailing: const Text('日'),
                ),
              ),
            ),

            // ラベルカラー
            const Padding(
              padding: EdgeInsets.only(left: 16, top: 8, right: 16),
              child: SizedBox(
                width: double.infinity,
                child: Text('ラベルカラー'),
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
                  leading: Icon(
                    Icons.circle,
                    color: stringifiedColorToColor(color.value),
                  ),
                  title: DropdownButton<String>(
                    underline: Container(),
                    isExpanded: true,
                    value: color.value,
                    onChanged: (String? value) {
                      color.value = value!;
                    },
                    items: LabelColor.labelcolor
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(
                            color: stringifiedColorToColor(value),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: TextButton(
                child: const Text('カードを更新'),
                onPressed: () async {
                  if (name.value != cardName) {
                    await EventFire()
                        .updateCardWithEventFire(cardName, name.value);
                  }
                  await CardFire().updateCardFire(
                    id,
                    name.value,
                    closing.value,
                    payment.value,
                    color.value,
                  );
                  ref.invalidate(futureHomeProvider);
                  await ref.read(eventProvider.notifier).fetchEvent();
                  // cardInfoPageに表示する直近４件のイベントをリスト化
                  // eventSortNotifier.fetchRecentlyEvent(
                  //   name.value,
                  //   ref.read(eventProvider),
                  // );
                  // // 確定分のPriceを計算
                  // confirmPriceNotifier.calcConfirmPrice(
                  //   ref.read(eventProvider),
                  //   name.value,
                  //   closing.value,
                  // );
                  // // 未確定分のPriceを計算
                  // unsettledPriceNotifier.calcUnsettledPrice(
                  //   ref.read(eventProvider),
                  //   name.value,
                  //   closing.value,
                  // );
                  // ignore: use_build_context_synchronously
                  // context.go(
                  //   '/cardInfoPage/$id/${name.value}/${closing.value}/${payment.value}/${color.value}',
                  // );
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
