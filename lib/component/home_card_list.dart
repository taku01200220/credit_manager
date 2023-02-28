import 'package:credit_manager/importer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class HomeCardList extends StatelessWidget {
  const HomeCardList({
    required this.labelColor,
    required this.cardName,
    required this.function,
    Key? key,
  }) : super(key: key);
  final String labelColor;
  final String cardName;
  final void Function()? function;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        left: 30,
        top: 15,
        right: 30,
        bottom: 15,
      ),
      // クレカの縦横比規格（1×1.58）
      height: 200.h,
      width: 316.h,
      child: Card(
        color: Colors.white, // Card自体の色
        elevation: 8, // 影の離れ具合
        shadowColor: Colors.black, // 影の色
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // 角丸の枠線
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer, // card内のWidgetを角丸に合わせる
        child: InkWell(
          onTap: function,
          child: Column(
            children: [
              SizedBox(
                height: 30.h,
                width: 324.h,
                child: Container(
                  color: stringifiedColorToColor(
                    labelColor,
                  ),
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              ListTile(
                leading: SvgPicture.asset(
                  'assets/icon/ic_chip.svg',
                  color: Colors.amber,
                  width: 32.h,
                  height: 32.h,
                ),
                title: Text(
                  cardName,
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                trailing: const Icon(Icons.chevron_right),
              ),
              ListTile(
                title: Text(
                  '                  ■ ■ ■ ■   ■ ■ ■ ■   ■ ■ ■ ■   ■ ■ ■ ■',
                  style: TextStyle(fontSize: 10.sp),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
