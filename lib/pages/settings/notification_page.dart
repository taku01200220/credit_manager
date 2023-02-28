import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class NotificationPage extends HookConsumerWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationValue = useState(true);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '通知の設定',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            ListTile(
              leading: null,
              title: Text('通知のオン／オフ'),
              trailing: CupertinoSwitch(
                value: notificationValue.value,
                onChanged: (bool value) {
                  notificationValue.value = value;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
