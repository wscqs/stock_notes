import 'package:flutter/material.dart';

class QsEmptyView extends StatelessWidget {
  final String message;
  final IconData icon;
  final double iconSize;
  final Color iconColor;
  final TextStyle? textStyle;

  const QsEmptyView({
    Key? key,
    this.message = '暂无数据',
    this.icon = Icons.inbox,
    this.iconSize = 80,
    this.iconColor = Colors.grey,
    this.textStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: iconSize, color: iconColor),
          const SizedBox(height: 16),
          Text(
            message,
            style: textStyle ??
                TextStyle(
                  fontSize: 18,
                  color: Colors.grey[600],
                ),
          ),
        ],
      ),
    );
  }
}
