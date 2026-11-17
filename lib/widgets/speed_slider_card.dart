import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../constants/app_styles.dart';
import '../services/mqtt_service.dart';

class SpeedSliderCard extends StatelessWidget {
  const SpeedSliderCard({super.key});

  @override
  Widget build(BuildContext context) {
    final mqttService = context.watch<MqttService>();
    final currentSpeed = mqttService.currentSpeed;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppStyles.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.speed_rounded,
                    color: AppColors.primary,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'KECEPATAN MOTOR (PWM)',
                    style: AppStyles.labelMd(
                      color: AppColors.onSurface,
                      weight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    '$currentSpeed',
                    style: AppStyles.headlineMd(color: AppColors.primary),
                  ),
                  const SizedBox(width: 3),
                  Text(
                    '/ 255 PWM',
                    style: AppStyles.labelSm(
                      color: AppColors.onSurfaceVariant,
                      weight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 4),

          // Slider Track & Thumb
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 6,
              activeTrackColor: AppColors.primary,
              inactiveTrackColor: AppColors.surfaceContainerHigh,
              thumbColor: AppColors.primary,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 9),
              overlayColor: AppColors.primary.withOpacity(0.15),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
            ),
            child: Slider(
              value: currentSpeed.toDouble(),
              min: 0,
              max: 255,
              onChanged: (val) {
                mqttService.setSpeed(val.round());
              },
            ),
          ),

          // Scale Labels
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('0 (0%)', style: AppStyles.labelSm()),
                Text('64 (25%)', style: AppStyles.labelSm()),
                Text('128 (50%)', style: AppStyles.labelSm()),
                Text('192 (75%)', style: AppStyles.labelSm()),
                Text('255 (MAX)', style: AppStyles.labelSm()),
              ],
            ),
          ),

          const SizedBox(height: 6),

          // Quick-Select Preset Pills (25%, 50%, 75%, MAX)
          Row(
            children: [
              _buildPresetButton(context, mqttService, '25%', 64, currentSpeed == 64),
              const SizedBox(width: 6),
              _buildPresetButton(context, mqttService, '50%', 128, currentSpeed == 128),
              const SizedBox(width: 6),
              _buildPresetButton(context, mqttService, '75%', 192, currentSpeed == 192),
              const SizedBox(width: 6),
              _buildPresetButton(context, mqttService, 'MAX', 255, currentSpeed == 255),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPresetButton(
    BuildContext context,
    MqttService mqtt,
    String label,
    int value,
    bool isSelected,
  ) {
    return Expanded(
      child: GestureDetector(
        onTap: () => mqtt.setSpeed(value),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(vertical: 5),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primary
                : AppColors.surfaceContainer,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              label,
              style: AppStyles.labelSm(
                color: isSelected ? AppColors.onPrimary : AppColors.onSurface,
                weight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
