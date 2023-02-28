import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({
    Key? key,
    required this.value,
    required this.iconSize,
    required this.textSize,
  }) : super(key: key);
  final String value;
  final int iconSize;
  final int textSize;

  bool isPosition(String value) {
    var isValue = true;
    if (value == 'Appbar') {
      isValue = true;
    } else if (value == 'Drawer') {
      isValue = false;
    }
    return isValue;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isPosition(value) == true
          ? MainAxisAlignment.center
          : MainAxisAlignment.start,
      children: [
        SizedBox(
          height: iconSize.h,
          width: iconSize.h,
          child: Image.asset('assets/icon/c_logo.png'),
        ),
        Text(
          '.Mgr',
          style: TextStyle(
            fontSize: textSize.h,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
