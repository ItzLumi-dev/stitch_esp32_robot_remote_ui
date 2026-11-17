import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

enum LogType { tx, rx, info, error }

class TerminalLog {
  final String timestamp;
  final String message;
  final LogType type;

  TerminalLog({
    required this.timestamp,
    required this.message,
    this.type = LogType.info,
  });

  Color get color {
    switch (type) {
      case LogType.tx:
        return AppColors.primaryFixedDim;
      case LogType.rx:
        return AppColors.secondaryFixedDim;
      case LogType.error:
        return AppColors.tertiaryFixedDim;
      case LogType.info:
        return AppColors.inverseOnSurface;
    }
  }
}
