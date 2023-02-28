import 'package:credit_manager/importer.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// cardInfoのリストを取得
final futureHomeProvider = FutureProvider<List<CardInfo>>((ref) async {
  await ref.read(cardInfoListProvider.notifier).fetchCardInfoList();
  return ref.read(cardInfoListProvider);
});

class HomePage extends HookConsumerWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncValue = ref.watch(futureHomeProvider);
    final cardInfoListState = ref.watch(cardInfoListProvider);
    final eventSortNotifier = ref.read(eventSortProvider.notifier);
    final confirmPriceNotifier = ref.read(confirmPriceProvider.notifier);
    final unsettledPriceNotifier = ref.read(unsettledPriceProvider.notifier);
    final cardListNotifier = ref.read(cardListProvider.notifier);

    useEffect(
      () {
        // 初回ビルド時にイベントの一覧を取得
        ref.read(eventProvider.notifier).fetchEvent();
        return null;
      },
      [],
    );

    return Scaffold(
      appBar: AppBar(
        title: const AppLogo(
          value: 'AppBar',
          iconSize: 24,
          textSize: 20,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: () => context.go('/addCardPage'),
          ),
        ],
      ),
      drawer: const DrawerMenu(),
      body: SingleChildScrollView(
        child: Center(
          child: asyncValue.when(
            // data取得完了時
            data: (List<CardInfo> data) => ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: data.isEmpty ? 1 : data.length,
              itemBuilder: (context, index) {
                // cardInfoがなかった場合に表示
                if (data.isEmpty) {
                  return NoDataCase(
                    text: 'カード',
                    height: 180.h,
                    actionIcon: Icons.add_circle_outline,
                    logoImg: true,
                  );
                }
                return HomeCardList(
                  labelColor: data[index].labelColor,
                  cardName: data[index].cardName,
                  function: () {
                    // cardInfoPageに表示する直近４件のイベントをリスト化
                    eventSortNotifier.fetchRecentlyEvent(
                      data[index].cardName,
                      ref.read(eventProvider),
                    );
                    // 確定分のPriceを計算
                    confirmPriceNotifier.calcConfirmPrice(
                      ref.read(eventProvider),
                      data[index].cardName,
                      data[index].closingDate,
                    );
                    // 未確定分のPriceを計算
                    unsettledPriceNotifier.calcUnsettledPrice(
                      ref.read(eventProvider),
                      data[index].cardName,
                      data[index].closingDate,
                    );
                    // 画面遷移（値渡し）
                    context.go(
                      '/cardInfoPage/${data[index].id}/${data[index].cardName}/${data[index].closingDate}/${data[index].paymentDate}/${data[index].labelColor}',
                    );
                  },
                );
              },
            ),
            //エラー時
            error: (err, _) => Text(err.toString()),
            //読み込み時
            loading: () => const CircularProgressIndicator(),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Visibility(
        // ignore: avoid_bool_literals_in_conditional_expressions
        visible: cardInfoListState.isEmpty ? false : true,
        child: AppFab(
          function: () async {
            // FCM の通知権限リクエスト
            // final messaging = FirebaseMessaging.instance;
            // await messaging.requestPermission(
            //   alert: true,
            //   announcement: false,
            //   badge: true,
            //   carPlay: false,
            //   criticalAlert: false,
            //   provisional: false,
            //   sound: true,
            // );

            // final token = await messaging.getToken();
            // print('🐯 FCM TOKEN: $token');
            cardListNotifier.fetchCardList(cardInfoListState);
            context.go('/addEventPage');
          },
        ),
      ),
    );
  }
}
