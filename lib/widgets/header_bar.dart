import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../constants/app_styles.dart';
import '../services/mqtt_service.dart';

class HeaderBar extends StatelessWidget {
  const HeaderBar({super.key});

  @override
  Widget build(BuildContext context) {
    final mqttService = context.watch<MqttService>();

    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.surface.withOpacity(0.95),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left Status Clusters
          Row(
            children: [
              // MQTT Status Pill
              _buildMqttStatusPill(mqttService.connectionStatus),
              const SizedBox(width: 8),

              // Ping Telemetry Pill
              _buildPingPill(mqttService.pingMs),
              const SizedBox(width: 8),

              // ESP32 Diagnostic Status Pill
              _buildDiagPill(mqttService.diagnosticStatus),
              const SizedBox(width: 8),

              // MicroSD Recording Indicator Pill
              _buildSdRecordPill(),
            ],
          ),

          // Right Action Cluster
          Row(
            children: [
              // E-STOP Button
              _buildEmergencyStopButton(context, mqttService),
              const SizedBox(width: 10),

              // Operator Profile Avatar
              Container(
                width: 34,
                height: 34,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x1F000000),
                      blurRadius: 4,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.person,
                  color: AppColors.onPrimary,
                  size: 18,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMqttStatusPill(MqttStatus status) {
    Color dotColor;
    String text;
    Color textColor;

    switch (status) {
      case MqttStatus.connected:
        dotColor = AppColors.secondaryFixedDim;
        text = 'ONLINE';
        textColor = AppColors.secondary;
        break;
      case MqttStatus.connecting:
        dotColor = Colors.orangeAccent;
        text = 'CONNECTING';
        textColor = Colors.orange.shade800;
        break;
      case MqttStatus.disconnected:
      case MqttStatus.error:
        dotColor = AppColors.error;
        text = 'OFFLINE';
        textColor = AppColors.error;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(9999),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A0F172A),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(
              color: dotColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            'MQTT',
            style: AppStyles.labelSm(
              color: AppColors.onSurface,
              weight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: AppStyles.labelSm(
              color: textColor,
              weight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPingPill(int pingMs) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(9999),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A0F172A),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.wifi, size: 13, color: AppColors.primary),
          const SizedBox(width: 5),
          Text(
            'WIFI HP:',
            style: AppStyles.labelSm(color: AppColors.onSurfaceVariant),
          ),
          const SizedBox(width: 4),
          Text(
            'Lab-Robotics_5G',
            style: AppStyles.labelSm(
              color: AppColors.onSurface,
              weight: FontWeight.w700,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            '(${pingMs > 0 ? '$pingMs ms' : '--'})',
            style: AppStyles.labelSm(
              color: AppColors.primary,
              weight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDiagPill(String diag) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(9999),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A0F172A),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.wifi_tethering, size: 13, color: AppColors.secondary),
          const SizedBox(width: 5),
          Text(
            'ESP32:',
            style: AppStyles.labelSm(color: AppColors.onSurfaceVariant),
          ),
          const SizedBox(width: 4),
          Text(
            diag,
            style: AppStyles.labelSm(
              color: AppColors.secondary,
              weight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSdRecordPill() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(9999),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A0F172A),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: AppColors.tertiary,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            '/LOG_0042.CSV',
            style: AppStyles.labelSm(color: AppColors.onSurfaceVariant),
          ),
          const SizedBox(width: 4),
          Text(
            '[REC]',
            style: AppStyles.labelSm(
              color: AppColors.tertiary,
              weight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmergencyStopButton(BuildContext context, MqttService mqttService) {
    return GestureDetector(
      onTap: () {
        mqttService.emergencyStop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('EMERGENCY STOP (STOP) DIKIRIM KE ROBOT!'),
            backgroundColor: AppColors.tertiary,
            duration: Duration(seconds: 1),
          ),
        );
      },
      child: Container(
        height: 34,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: AppColors.tertiaryContainer,
          borderRadius: BorderRadius.circular(9999),
          boxShadow: const [
            BoxShadow(
              color: Color(0xFF930015),
              offset: Offset(0, 3),
              blurRadius: 0,
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.warning_amber_rounded,
              color: AppColors.onTertiaryContainer,
              size: 16,
            ),
            const SizedBox(width: 6),
            Text(
              'E-STOP',
              style: AppStyles.labelMd(
                color: AppColors.onTertiaryContainer,
                weight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
