import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../constants/app_styles.dart';
import '../services/mqtt_service.dart';

class FooterBar extends StatelessWidget {
  const FooterBar({super.key});

  @override
  Widget build(BuildContext context) {
    final mqttService = context.watch<MqttService>();

    return Container(
      height: 28,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest.withOpacity(0.95),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left Info
          Row(
            children: [
              Text(
                'REMOTE MODE:',
                style: AppStyles.labelSm(color: AppColors.onSurfaceVariant),
              ),
              const SizedBox(width: 4),
              Text(
                'DUAL THUMBSTICK (MODE 2)',
                style: AppStyles.labelSm(
                  color: AppColors.primary,
                  weight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 14),
              Text(
                'RATE: 100 Hz WSS',
                style: AppStyles.labelSm(color: AppColors.onSurfaceVariant),
              ),
            ],
          ),

          // Right Info
          Row(
            children: [
              Text(
                'CORE TEMP:',
                style: AppStyles.labelSm(color: AppColors.onSurfaceVariant),
              ),
              const SizedBox(width: 4),
              Text(
                '${mqttService.temperature.toStringAsFixed(1)}°C',
                style: AppStyles.labelSm(
                  color: mqttService.tempStatus == TempStatus.bahaya
                      ? AppColors.tertiary
                      : AppColors.onSurface,
                  weight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 14),
              Container(
                width: 5,
                height: 5,
                decoration: const BoxDecoration(
                  color: AppColors.secondaryFixedDim,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                mqttService.connectionStatus == MqttStatus.connected
                    ? 'BUS SYNC OK'
                    : 'OFFLINE',
                style: AppStyles.labelSm(
                  color: mqttService.connectionStatus == MqttStatus.connected
                      ? AppColors.secondary
                      : AppColors.error,
                  weight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
