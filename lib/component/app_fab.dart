import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AppFab extends ConsumerWidget {
  const AppFab({
    Key? key,
    required this.function,
  }) : super(key: key);
  final void Function()? function;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FloatingActionButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16), //角の丸み
      ),
      onPressed: function,
      backgroundColor: Colors.white,
      child: const Icon(
        Icons.edit_note,
        color: Color(0xFF933b75),
      ),
    );
  }
}
