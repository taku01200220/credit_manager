import 'package:credit_manager/importer.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final routerProvider = Provider(
  (ref) => GoRouter(
    routes: <GoRoute>[
      GoRoute(
        path: '/',
        pageBuilder: (context, state) => _buildPageWithAnimation(
          const HomePage(),
        ),
        routes: <GoRoute>[
          GoRoute(
            path: 'settingPage',
            pageBuilder: (context, state) => _buildPageWithAnimation(
              const SettingPage(),
            ),
            routes: <GoRoute>[
              GoRoute(
                path: 'mailPage',
                builder: (context, state) => const MailPage(),
              ),
              GoRoute(
                path: 'passwordPage',
                builder: (context, state) => const PasswordPage(),
              ),
              GoRoute(
                path: 'notificationPage',
                builder: (context, state) => const NotificationPage(),
              ),
            ],
          ),
          GoRoute(
            path: 'mainCardPage',
            pageBuilder: (context, state) => _buildPageWithAnimation(
              const MainCardPage(),
            ),
          ),
          GoRoute(
            path:
                'cardInfoPage/:id/:cardName/:closingDate/:paymentDate/:labelColor',
            builder: (context, state) {
              return CardInfoPage(
                id: state.params['id']!,
                cardName: state.params['cardName']!,
                closingDate: state.params['closingDate']!,
                paymentDate: state.params['paymentDate']!,
                labelColor: state.params['labelColor']!,
              );
            },
            routes: <GoRoute>[
              GoRoute(
                path: 'editCardPage',
                builder: (context, state) {
                  return EditCardPage(
                    id: state.params['id']!,
                    cardName: state.params['cardName']!,
                    closingDate: state.params['closingDate']!,
                    paymentDate: state.params['paymentDate']!,
                    labelColor: state.params['labelColor']!,
                  );
                },
              ),
              GoRoute(
                path: 'historyEventPage',
                builder: (context, state) {
                  return HistoryEventPage(
                    id: state.params['id']!,
                    cardName: state.params['cardName']!,
                    closingDate: state.params['closingDate']!,
                    paymentDate: state.params['paymentDate']!,
                    labelColor: state.params['labelColor']!,
                  );
                },
              ),
              GoRoute(
                path: 'detailEventPage/:month',
                builder: (context, state) {
                  return DetailEventPage(
                    id: state.params['id']!,
                    cardName: state.params['cardName']!,
                    closingDate: state.params['closingDate']!,
                    paymentDate: state.params['paymentDate']!,
                    labelColor: state.params['labelColor']!,
                    month: DateTime.parse(state.params['month']!),
                  );
                },
              ),
              GoRoute(
                path: 'editEventPage/:eventId/:price/:registerDate/:detail',
                builder: (context, state) {
                  return EditEventPage(
                    id: state.params['id']!,
                    cardName: state.params['cardName']!,
                    closingDate: state.params['closingDate']!,
                    paymentDate: state.params['paymentDate']!,
                    labelColor: state.params['labelColor']!,
                    eventId: state.params['eventId']!,
                    price: int.parse(state.params['price']!),
                    registerDate: DateTime.parse(state.params['registerDate']!),
                    detail: state.params['detail']!,
                  );
                },
              ),
            ],
          ),
          GoRoute(
            path: 'addCardPage',
            pageBuilder: (context, state) => _buildPageWithAnimation(
              const AddCardPage(),
            ),
          ),
          GoRoute(
            path: 'addEventPage',
            pageBuilder: (context, state) => _buildPageWithAnimation(
              const AddEventPage(),
            ),
          ),
        ],
      ),
      GoRoute(
        path: '/loginPage',
        builder: (BuildContext context, GoRouterState state) =>
            const LoginPage(),
      ),
    ],
    redirect: (BuildContext context, GoRouterState state) {
      final loggedIn = ref.read(loginInfoProvider.notifier).loggedIn;
      final loggingIn = state.subloc == '/loginPage';

      if (!loggedIn) {
        return '/loginPage';
      }

      // ユーザーがログインしているにも関わらず、まだログイン画面にいる場合はホーム画面に誘導する
      if (loggingIn) {
        return '/';
      }
      // 一切リダイレクトが不要な場合
      return null;
    },
    refreshListenable: ref.read(loginInfoProvider),

    // 遷移ページがないなどのエラーが発生した時に、このページに行く
    errorBuilder: (BuildContext context, GoRouterState state) =>
        ErrorScreen(state.error!),
  ),
);

// フェードアニメーションで遷移
CustomTransitionPage<void> _buildPageWithAnimation(Widget page) {
  return CustomTransitionPage<void>(
    child: page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: CurveTween(curve: Curves.easeInOutCirc).animate(animation),
        child: child,
      );
    },
  );
}
