import 'package:flutter/cupertino.dart';

extension WidgetExtensions on Widget {
  Widget get wrap => _wrap();
  Widget _wrap() {
    return Padding(
      padding: EdgeInsets.all(12),
      child: this,
    );
  }
  Widget get mr => Padding(padding: EdgeInsets.only(right: 12),child: this);
}
