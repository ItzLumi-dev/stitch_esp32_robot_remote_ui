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
                Icons.speed_rounded,
                color: AppColors.primary,
                size: 18,
              ),
              const SizedBox(width: 5),
              Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'KECEPATAN MOTOR (PWM)',
                    style: AppStyles.labelMd(
                      color: AppColors.onSurface,
                      weight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Row(
                mainAxisSize: MainAxisSize.min,
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

          const Spacer(),

          // Slider Track & Thumb
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 8,
              activeTrackColor: AppColors.primary,
              inactiveTrackColor: AppColors.surfaceContainerHigh,
              thumbColor: AppColors.primary,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 11),
              overlayColor: AppColors.primary.withOpacity(0.15),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 18),
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

          const SizedBox(height: 2),

          // Scale Labels (Guaranteed zero overlap)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('0 (0%)', style: AppStyles.labelSm()),
                  const SizedBox(width: 14),
                  Text('64 (25%)', style: AppStyles.labelSm()),
                  const SizedBox(width: 14),
                  Text('128 (50%)', style: AppStyles.labelSm()),
                  const SizedBox(width: 14),
                  Text('192 (75%)', style: AppStyles.labelSm()),
                  const SizedBox(width: 14),
                  Text('255 (MAX)', style: AppStyles.labelSm()),
                ],
              ),
            ),
          ),

          const Spacer(),

          // Quick-Select Preset Pills (25%, 50%, 75%, MAX)
          Row(
            children: [
              _buildPresetButton(context, mqttService, '25%', 64, currentSpeed == 64),
              const SizedBox(width: 8),
              _buildPresetButton(context, mqttService, '50%', 128, currentSpeed == 128),
              const SizedBox(width: 8),
              _buildPresetButton(context, mqttService, '75%', 192, currentSpeed == 192),
              const SizedBox(width: 8),
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
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primary
                : AppColors.surfaceContainer,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              label,
              style: AppStyles.labelMd(
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
