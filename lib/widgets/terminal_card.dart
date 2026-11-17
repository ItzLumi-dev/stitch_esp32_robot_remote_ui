import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../constants/app_styles.dart';
import '../constants/mqtt_config.dart';
import '../services/mqtt_service.dart';

class TerminalCard extends StatefulWidget {
  const TerminalCard({super.key});

  @override
  State<TerminalCard> createState() => _TerminalCardState();
}

class _TerminalCardState extends State<TerminalCard> {
  final ScrollController _scrollController = ScrollController();
  int _lastLogCount = 0;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final mqttService = context.watch<MqttService>();
    final logs = mqttService.terminalLogs;

    if (logs.length != _lastLogCount || logs.length == 18) {
      _lastLogCount = logs.length;
      _scrollToBottom();
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
          // Header Bar
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppColors.secondaryFixedDim,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 7),
              Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'TERMINAL LOG MQTT & MICROSD',
                    style: AppStyles.labelMd(
                      color: AppColors.onSurface,
                      weight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Active SD Log Pill
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainer,
                  borderRadius: BorderRadius.circular(9999),
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
                    const SizedBox(width: 5),
                    Text(
                      '/LOG_0042.CSV',
                      style: AppStyles.labelSm(
                        color: AppColors.tertiary,
                        weight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: 4),
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
              const SizedBox(width: 10),
              // Clear button
              GestureDetector(
                onTap: () => mqttService.clearTerminal(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  child: Text(
                    'CLEAR',
                    style: AppStyles.labelSm(
                      color: AppColors.onSurfaceVariant,
                      weight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Embedded Dark Technical Terminal Screen (Expanded to fill available height!)
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.inverseSurface,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x55000000),
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Broker & Buffer Status sub-bar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          'BROKER: ${MqttConfig.broker}:${MqttConfig.port} (WSS)',
                          style: AppStyles.labelSm(
                            color: AppColors.inverseOnSurface.withOpacity(0.65),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'BUFFER: ${logs.length}/18 LINES',
                        style: AppStyles.labelSm(
                          color: AppColors.inverseOnSurface.withOpacity(0.65),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Divider(
                    height: 1,
                    thickness: 1,
                    color: AppColors.inverseOnSurface.withOpacity(0.14),
                  ),
                  const SizedBox(height: 5),

                  // Terminal lines (Max 18 lines FIFO)
                  Expanded(
                    child: ListView.builder(
                      controller: _scrollController,
                      padding: EdgeInsets.zero,
                      itemCount: logs.length,
                      physics: const ClampingScrollPhysics(),
                      itemBuilder: (context, index) {
                        final item = logs[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 1.5),
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

                  const SizedBox(height: 5),
                  Divider(
                    height: 1,
                    thickness: 1,
                    color: AppColors.inverseOnSurface.withOpacity(0.14),
                  ),
                  const SizedBox(height: 5),

                  // Prompt line
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
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
                          color: AppColors.inverseOnSurface.withOpacity(0.45),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
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
              const SizedBox(width: 10),
              _buildMiniTelemetryItem(
                label: 'PING (MS):',
                value: '${mqttService.pingMs} ms',
                valueColor: AppColors.primary,
              ),
              const SizedBox(width: 10),
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
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: AppStyles.labelSm(
                color: AppColors.onSurfaceVariant,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                value,
                style: AppStyles.labelMd(
                  color: valueColor,
                  weight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
