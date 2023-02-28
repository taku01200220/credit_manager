import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NoDataCase extends StatelessWidget {
  const NoDataCase({
    required this.text,
    required this.height,
    required this.actionIcon,
    required this.logoImg,
    Key? key,
  }) : super(key: key);
  final String text;
  final double height;
  final IconData actionIcon;
  final bool logoImg;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: height),
        Visibility(
          visible: logoImg,
          child: SizedBox(
            height: 100.h,
            child: Image.asset('assets/icon/c_logo_grey.png'),
          ),
        ),
        SizedBox(height: 15.h),
        Text(
          '$textが登録されていません',
          style: logoImg
              ? const TextStyle(fontWeight: FontWeight.bold)
              : const TextStyle(color: Colors.grey),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '「',
              style: TextStyle(color: Colors.grey),
            ),
            Icon(
              actionIcon,
              size: 16,
              color: Colors.grey,
            ),
            Text(
              '」から$textを追加してください',
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ],
    );
  }
}
