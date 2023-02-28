import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PasswordPage extends HookConsumerWidget {
  const PasswordPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'パスワードの設定',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16, top: 8, right: 16),
              child: Container(
                width: double.infinity,
                child: Text('変更後のパスワード'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: ListTile(
                  title: TextFormField(
                    decoration: const InputDecoration(
                      hintText: '入力',
                      border: InputBorder.none,
                    ),
                  ),
                  trailing: Icon(Icons.visibility_off),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16, top: 8, right: 16),
              child: Container(
                width: double.infinity,
                child: Text('変更後のパスワード（確認用）'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: ListTile(
                  title: TextFormField(
                    decoration: const InputDecoration(
                      hintText: '入力',
                      border: InputBorder.none,
                    ),
                  ),
                  trailing: Icon(Icons.visibility_off),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: TextButton(
                child: Text('パスワードを変更'),
                onPressed: () => context.pop(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
