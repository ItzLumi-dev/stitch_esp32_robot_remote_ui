import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../constants/app_styles.dart';
import '../services/mqtt_service.dart';

class TemperatureCard extends StatelessWidget {
  const TemperatureCard({super.key});

  @override
  Widget build(BuildContext context) {
    final mqttService = context.watch<MqttService>();
    final temp = mqttService.temperature;
    final status = mqttService.tempStatus;

    Color badgeBg;
    Color badgeText;
    Color sparklineColor;

    switch (status) {
      case TempStatus.normal:
        badgeBg = AppColors.surfaceContainer;
        badgeText = AppColors.secondary;
        sparklineColor = AppColors.primary;
        break;
      case TempStatus.hangat:
        badgeBg = const Color(0xFFFFECC8);
        badgeText = const Color(0xFFB45309);
        sparklineColor = const Color(0xFFD97706);
        break;
      case TempStatus.bahaya:
        badgeBg = AppColors.tertiary;
        badgeText = AppColors.onTertiary;
        sparklineColor = AppColors.tertiary;
        break;
    }

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(18),
        boxShadow: AppStyles.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Row
          Row(
            children: [
              const Icon(
                Icons.device_thermostat_rounded,
                color: AppColors.primary,
                size: 18,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'DS18B20 PROBE',
                    style: AppStyles.labelMd(
                      color: AppColors.onSurface,
                      weight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                  decoration: BoxDecoration(
                    color: badgeBg,
                    borderRadius: BorderRadius.circular(9999),
                  ),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      mqttService.tempStatusLabel,
                      style: AppStyles.labelSm(
                        color: badgeText,
                        weight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),

          // Big Temperature Readout & Threshold
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    temp.toStringAsFixed(1),
                    style: AppStyles.headlineXl(
                      color: status == TempStatus.bahaya
                          ? AppColors.tertiary
                          : AppColors.onSurface,
                    ),
                  ),
                  const SizedBox(width: 3),
                  Text(
                    '°C',
                    style: AppStyles.headlineMd(
                      color: status == TempStatus.bahaya
                          ? AppColors.tertiary
                          : AppColors.primary,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'THRESHOLD',
                    style: AppStyles.labelSm(color: AppColors.onSurfaceVariant),
                  ),
                  Text(
                    'Limit 40.0°C',
                    style: AppStyles.labelMd(
                      color: AppColors.tertiary,
                      weight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 6),

          // Dynamic Sparkline Graph (flexes cleanly into available height)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: CustomPaint(
                size: Size.infinite,
                painter: SparklinePainter(
                  data: mqttService.tempHistory,
                  lineColor: sparklineColor,
                ),
              ),
            ),
          ),

          const SizedBox(height: 8),

          // Interactive Heat Simulation Button
          GestureDetector(
            onTap: () => mqttService.toggleHeatSimulation(),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 7),
              decoration: BoxDecoration(
                color: mqttService.isHeatSimActive
                    ? AppColors.tertiaryContainer
                    : AppColors.surfaceContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.local_fire_department_rounded,
                    size: 16,
                    color: mqttService.isHeatSimActive
                        ? AppColors.onTertiaryContainer
                        : AppColors.tertiary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    mqttService.isHeatSimActive
                        ? 'Stop Simulasi Panas'
                        : 'Simulasi Panas',
                    style: AppStyles.labelMd(
                      color: mqttService.isHeatSimActive
                          ? AppColors.onTertiaryContainer
                          : AppColors.onSurface,
                      weight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SparklinePainter extends CustomPainter {
  final List<double> data;
  final Color lineColor;

  SparklinePainter({required this.data, required this.lineColor});

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty || size.width <= 0 || size.height <= 0) return;

    final paint = Paint()
      ..color = lineColor
      ..strokeWidth = 2.4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          lineColor.withOpacity(0.20),
          lineColor.withOpacity(0.01),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    double minVal = data.reduce((a, b) => a < b ? a : b);
    double maxVal = data.reduce((a, b) => a > b ? a : b);

    // Keep margin so it doesn't clip
    minVal = minVal - 2.0;
    maxVal = maxVal + 2.0;
    if (maxVal <= minVal) maxVal = minVal + 5.0;

    final path = Path();
    final fillPath = Path();

    final dx = size.width / (data.length - 1 <= 0 ? 1 : data.length - 1);

    for (int i = 0; i < data.length; i++) {
      final x = i * dx;
      final normalized = (data[i] - minVal) / (maxVal - minVal);
      final y = size.height - (normalized * size.height).clamp(0.0, size.height);

      if (i == 0) {
        path.moveTo(x, y);
        fillPath.moveTo(x, size.height);
        fillPath.lineTo(x, y);
      } else {
        final prevX = (i - 1) * dx;
        final prevNorm = (data[i - 1] - minVal) / (maxVal - minVal);
        final prevY = size.height - (prevNorm * size.height).clamp(0.0, size.height);

        final controlX1 = prevX + dx / 2;
        final controlY1 = prevY;
        final controlX2 = prevX + dx / 2;
        final controlY2 = y;

        path.cubicTo(controlX1, controlY1, controlX2, controlY2, x, y);
        fillPath.cubicTo(controlX1, controlY1, controlX2, controlY2, x, y);
      }
    }

    fillPath.lineTo(size.width, size.height);
    fillPath.close();

    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant SparklinePainter oldDelegate) {
    return oldDelegate.data != data || oldDelegate.lineColor != lineColor;
  }
}
