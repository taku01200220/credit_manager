import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PasswordResetPage extends HookConsumerWidget {
  const PasswordResetPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        // title: const Text(
        //   'Password',
        //   style: TextStyle(color: Colors.black),
        // ),
      ),
      body: Center(
        child: Column(
          children: [
            // SizedBox(height: 40.h),
            SizedBox(
              height: 120.h,
              width: 120.h,
              child: Image.asset('assets/icon/c_logo.png'),
            ),
            SizedBox(height: 40.h),
            Padding(
              padding: const EdgeInsets.only(left: 32, top: 16, right: 32),
              child: Container(
                width: double.infinity,
                child: Text('メールアドレス'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 32, right: 32),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: ListTile(
                  // leading: Icon(Icons.currency_yen),
                  title: TextFormField(
                    decoration: const InputDecoration(
                      hintText: '',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.only(left: 32, top: 16, right: 32),
            //   child: Container(
            //     width: double.infinity,
            //     child: Text('パスワード'),
            //   ),
            // ),
            // Padding(
            //   padding: const EdgeInsets.only(left: 32, right: 32),
            //   child: Container(
            //     decoration: BoxDecoration(
            //       color: Colors.white,
            //       borderRadius: BorderRadius.circular(5),
            //     ),
            //     child: ListTile(
            //       // leading: Icon(Icons.currency_yen),
            //       title: TextFormField(
            //         decoration: const InputDecoration(
            //           hintText: '',
            //           border: InputBorder.none,
            //         ),
            //       ),
            //       trailing: Icon(Icons.visibility_off),
            //     ),
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.only(left: 32, top: 32, right: 32),
              child: ElevatedButton(
                onPressed: () {},
                child: Ink(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFFC62D70), Color(0xFF644777)],
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Container(
                    alignment: Alignment.center,
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                    child: const Text('パスワード再設定メールを送信'),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero,
                ),
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.only(top: 16),
            //   child: TextButton(
            //     child: Text('既にアカウントをお持ちの場合'),
            //     onPressed: () {},
            //   ),
            // ),
            // Divider(
            //   indent: 32,
            //   endIndent: 32,
            // ),
            // TextButton(
            //   child: Text('新規登録'),
            //   onPressed: () {},
            // ),
          ],
        ),
      ),
    );
  }
}
