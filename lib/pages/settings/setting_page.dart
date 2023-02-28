import 'package:credit_manager/importer.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SettingPage extends HookConsumerWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '設定',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            ListTile(
              leading: Icon(Icons.mail),
              title: Text('メールアドレス'),
              onTap: () => context.go('/settingPage/mailPage'),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.key),
              title: Text('パスワード'),
              onTap: () => context.go('/settingPage/passwordPage'),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.notifications),
              title: Text('通知'),
              onTap: () => context.go('/settingPage/notificationPage'),
            ),
            const Divider(),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('ログアウト'),
              onTap: () async {
                // ログアウトの処理（routerでrefreshListenableさせるため、logout()を呼び出し）
                await AuthFire().logoutFire();
                ref.read(loginInfoProvider.notifier).logout();
              },
            ),
            const Divider(),
            ListTile(
              leading: Icon(Icons.person_remove_alt_1_rounded, color: Colors.red,),
              title: Text(
                'アカウントを削除',
                style: TextStyle(color: Colors.red),
              ),
              onTap: () async {
                // アカウント削除とログアウトの処理（routerでrefreshListenableさせるため、logout()を呼び出し）
                await AuthFire().deleteAccountFire();
                ref.read(loginInfoProvider.notifier).logout();
              },
            ),
          ],
        ),
      ),
    );
  }
}
