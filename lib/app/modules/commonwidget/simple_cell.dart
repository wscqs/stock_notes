import 'package:flutter/material.dart';

import '../../../common/comment_style.dart';

class SimpleCell extends StatelessWidget {
  final String? title;
  final String? subTitle;
  final String? bottomSubTitle; // 标题下方的说明文字（小字灰色）
  final VoidCallback? onPressed;
  final double radius;
  final bool isCheck;
  final bool isShowRightArrow;
  final Widget? rightWidget;

  const SimpleCell(
      {super.key,
      this.title,
      this.subTitle,
      this.bottomSubTitle,
      this.onPressed,
      this.radius = 0,
      this.isCheck = false,
      this.isShowRightArrow = true,
      this.rightWidget});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          color: Theme.of(context).colorScheme.surfaceContainerLow,
        ),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title ?? ""),
                if (bottomSubTitle != null)
                  Text(
                    bottomSubTitle!,
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
              ],
            ),
            kSpaceMax(),
            Text(subTitle ?? ""),
            kSpaceW(4),
            if (rightWidget != null)
              rightWidget!
            else if (isShowRightArrow)
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
              )
            else if (isCheck)
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
