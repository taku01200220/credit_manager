import 'package:credit_manager/importer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AddCardPage extends HookConsumerWidget {
  const AddCardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cardInfoListState = ref.read(cardInfoListProvider);
    final cardName = useState('');
    final closingDate = useState('');
    final paymentDate = useState('');
    final labelColor = useState('red');
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'カードを追加',
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
                    decoration: const InputDecoration(
                      hintText: 'カード名',
                      border: InputBorder.none,
                    ),
                    onChanged: (value) => cardName.value = value,
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
                    decoration: const InputDecoration(
                      hintText: '0',
                      border: InputBorder.none,
                    ),
                    onChanged: (value) => closingDate.value = value,
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
                    decoration: const InputDecoration(
                      hintText: '0',
                      border: InputBorder.none,
                    ),
                    onChanged: (value) => paymentDate.value = value,
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
                    color: stringifiedColorToColor(labelColor.value),
                  ),
                  title: DropdownButton<String>(
                    underline: Container(),
                    isExpanded: true,
                    value: labelColor.value,
                    onChanged: (String? value) {
                      labelColor.value = value!;
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

            // カードの追加ボタン
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: TextButton(
                child: const Text('カードを追加'),
                onPressed: () {
                  CardFire().addCardFire(
                    cardName.value,
                    closingDate.value,
                    paymentDate.value,
                    labelColor.value,
                    // ignore: avoid_bool_literals_in_conditional_expressions
                    cardInfoListState.isEmpty ? true : false,
                  );
                  ref.invalidate(futureHomeProvider);
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
