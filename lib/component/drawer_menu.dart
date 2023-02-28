import 'package:credit_manager/importer.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DrawerMenu extends ConsumerWidget {
  const DrawerMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cardInfoListState = ref.watch(cardInfoListProvider);

    return ClipRRect(
      // Drawerを角丸にしている
      borderRadius: const BorderRadius.only(
        topRight: Radius.circular(30),
        bottomRight: Radius.circular(30),
      ),
      child: Drawer(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 12, top: 60, bottom: 12),
              child: AppLogo(
                value: 'Drawer',
                iconSize: 28,
                textSize: 24,
              ),
            ),
            ListTile(
              leading: const Icon(
                Icons.credit_card,
              ),
              title: const Text('メインカード'),
              subtitle: Text(
                cardInfoListState.isEmpty
                    ? '未登録'
                    : cardInfoListState[0].cardName,
              ),
              onTap: () => context.go('/mainCardPage'),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(
                Icons.settings_outlined,
              ),
              title: const Text('設定'),
              onTap: () => context.go('/settingPage'),
            ),
          ],
        ),
      ),
    );
  }
}
