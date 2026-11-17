import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../constants/app_styles.dart';
import '../constants/mqtt_config.dart';
import '../services/mqtt_service.dart';

class TerminalCard extends StatelessWidget {
  const TerminalCard({super.key});

  @override
  Widget build(BuildContext context) {
    final mqttService = context.watch<MqttService>();
    final logs = mqttService.terminalLogs;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppStyles.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header Bar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 7,
                    height: 7,
                    decoration: const BoxDecoration(
                      color: AppColors.secondaryFixedDim,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'TERMINAL LOG MQTT & MICROSD',
                    style: AppStyles.labelMd(
                      color: AppColors.onSurface,
                      weight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  // Active SD Log Pill
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainer,
                      borderRadius: BorderRadius.circular(9999),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 5,
                          height: 5,
                          decoration: const BoxDecoration(
                            color: AppColors.tertiary,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '/LOG_0042.CSV',
                          style: AppStyles.labelSm(
                            color: AppColors.tertiary,
                            weight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(width: 3),
                        Text(
                          '[REC]',
                          style: AppStyles.labelSm(
                            color: AppColors.secondary,
                            weight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Clear button
                  GestureDetector(
                    onTap: () => mqttService.clearTerminal(),
                    child: Text(
                      'CLEAR',
                      style: AppStyles.labelSm(
                        color: AppColors.onSurfaceVariant,
                        weight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Embedded Dark Technical Terminal Screen
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.inverseSurface,
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x66000000),
                  blurRadius: 6,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Broker & Buffer Status sub-bar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'BROKER: ${MqttConfig.broker}:${MqttConfig.port} (WSS)',
                      style: AppStyles.labelSm(
                        color: AppColors.inverseOnSurface.withOpacity(0.6),
                      ),
                    ),
                    Text(
                      'BUFFER: ${logs.length}/18 LINES',
                      style: AppStyles.labelSm(
                        color: AppColors.inverseOnSurface.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Divider(
                  height: 1,
                  thickness: 1,
                  color: AppColors.inverseOnSurface.withOpacity(0.12),
                ),
                const SizedBox(height: 4),

                // Terminal lines (Max 18 lines)
                ConstrainedBox(
                  constraints: const BoxConstraints(minHeight: 80, maxHeight: 95),
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: logs.length,
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    itemBuilder: (context, index) {
                      final item = logs[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 1.0),
                        child: Text(
                          '${item.timestamp} ${item.message}',
                          style: AppStyles.labelSm(
                            color: item.color,
                            weight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 4),
                Divider(
                  height: 1,
                  thickness: 1,
                  color: AppColors.inverseOnSurface.withOpacity(0.12),
                ),
                const SizedBox(height: 4),

                // Prompt line
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          '> esp32_host: ',
                          style: AppStyles.labelSm(
                            color: AppColors.primaryFixedDim,
                            weight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          '_',
                          style: AppStyles.labelSm(
                            color: AppColors.primaryFixedDim,
                            weight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'AUTO-FLUSH INTERVAL: 100ms',
                      style: AppStyles.labelSm(
                        color: AppColors.inverseOnSurface.withOpacity(0.4),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Mini Telemetry Strip
          Row(
            children: [
              _buildMiniTelemetryItem(
                label: 'STATUS DIAG:',
                value: mqttService.diagnosticStatus,
                valueColor: AppColors.secondary,
              ),
              const SizedBox(width: 8),
              _buildMiniTelemetryItem(
                label: 'ROUND TRIP / PING:',
                value: '${mqttService.pingMs} ms',
                valueColor: AppColors.primary,
              ),
              const SizedBox(width: 8),
              _buildMiniTelemetryItem(
                label: 'SUHU PROBE:',
                value: '${mqttService.temperature.toStringAsFixed(1)}°C',
                valueColor: mqttService.tempStatus == TempStatus.bahaya
                    ? AppColors.tertiary
                    : AppColors.onSurface,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMiniTelemetryItem({
    required String label,
    required String value,
    required Color valueColor,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: AppStyles.labelSm(
                color: AppColors.onSurfaceVariant,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              value,
              style: AppStyles.labelSm(
                color: valueColor,
                weight: FontWeight.w700,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
