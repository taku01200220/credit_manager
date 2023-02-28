import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:credit_manager/importer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MainCardPage extends HookConsumerWidget {
  const MainCardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cardInfoListState = ref.watch(cardInfoListProvider);
    final selectedIndex = useState(0);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'メインカードの選択',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            // カードのリスト
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount:
                  cardInfoListState.isEmpty ? 1 : cardInfoListState.length,
              itemBuilder: (context, index) {
                // 直近のイベントがない場合に表示するWidgetを追記
                if (ref.watch(cardInfoListProvider).isEmpty) {
                  return NoDataCase(
                    text: 'カード',
                    height: 180.h,
                    actionIcon: Icons.add_circle_outline,
                    logoImg: true,
                  );
                }
                return RadioListTile(
                  title: Row(
                    children: [
                      Icon(
                        Icons.credit_card,
                        color: stringifiedColorToColor(
                          cardInfoListState[index].labelColor,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Text(cardInfoListState[index].cardName),
                    ],
                  ),
                  value: index,
                  groupValue: selectedIndex.value,
                  onChanged: (int? value) {
                    //ラジオボタンが変更された場合に選択されたindexを渡す
                    selectedIndex.value = index;
                  },
                );
              },
            ),
            Visibility(
              // ignore: avoid_bool_literals_in_conditional_expressions
              visible: cardInfoListState.isEmpty ? false : true,
              child: TextButton(
                child: const Text('メインカードに設定'),
                onPressed: () async {
                  final uid = FirebaseAuth.instance.currentUser?.uid;
                  // indexが[0]のmainCardをfalse
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(uid)
                      .collection('cardInfo')
                      .doc(cardInfoListState[0].id)
                      .update({
                    'mainCard': false,
                  });
                  // indexが[selectedIndex]のmainCardをtrue
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(uid)
                      .collection('cardInfo')
                      .doc(cardInfoListState[selectedIndex.value].id)
                      .update({
                    'mainCard': true,
                  });
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
