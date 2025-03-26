import 'package:flutter/material.dart';

extension ListExtension on List {
  List<Widget> spacing({
    double? width,
    double? height,
    bool hasSpaceLastItem = true,
    bool hasSpaceFirstItem = true,
  }) {
    final List<Widget> list = [
      if (hasSpaceFirstItem)
        SizedBox(
          height: height,
          width: width,
        ),
      for (final Widget item in this) ...[
        item,
        SizedBox(
          width: width,
          height: height,
        ),
      ],
    ];
    if (!hasSpaceLastItem) list.removeLast();
    return list;
  }
}
