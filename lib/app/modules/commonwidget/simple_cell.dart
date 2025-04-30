import 'package:flutter/material.dart';

import '../../../common/comment_style.dart';

class SimpleCell extends StatelessWidget {
  final String? title;
  final String? subTitle;
  final VoidCallback? onPressed;
  final double? radius;
  final bool? isCheck;
  final bool? isShowRightArrow;

  const SimpleCell(
      {super.key,
      this.title,
      this.subTitle,
      this.onPressed,
      this.radius = 0,
      this.isCheck = false,
      this.isShowRightArrow = true});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius!),
          color: Theme.of(context).colorScheme.surfaceContainerLow,
        ),
        child: Row(
          children: [
            Text(title ?? ""),
            kSpaceMax(),
            Text(subTitle ?? ""),
            kSpaceW(4),
            if (isShowRightArrow!)
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
              )
            else if (isCheck!)
              Icon(
                Icons.check,
                size: 20,
              )
          ],
        ),
      ),
    );
  }
}
