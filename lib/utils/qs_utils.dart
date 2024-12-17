import 'package:flutter/material.dart';
import 'package:stock_notes/utils/qs_view.dart';

void setSystemNavigationBarColor(Color? color, Brightness? iconBrightness) {
  QsView.setSystemNavigationBarColor(color, iconBrightness);
}

void hideKeyboard() {
  QsView.hideKeyboard();
}
