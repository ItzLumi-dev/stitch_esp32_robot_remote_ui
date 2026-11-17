import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../constants/app_styles.dart';
import '../constants/mqtt_config.dart';
import '../services/mqtt_service.dart';

class ActuatorCard extends StatelessWidget {
  const ActuatorCard({super.key});

  @override
  Widget build(BuildContext context) {
    final mqttService = context.watch<MqttService>();

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
              const Icon(
                Icons.precision_manufacturing_rounded,
                color: AppColors.primary,
                size: 20,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'KONTROL LENGAN & CAPIT',
                    style: AppStyles.labelMd(
                      color: AppColors.onSurface,
                      weight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.secondaryContainer,
                  borderRadius: BorderRadius.circular(9999),
                ),
                child: Text(
                  'AKTIF',
                  style: AppStyles.labelSm(
                    color: AppColors.onSecondaryContainer,
                    weight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),
          Divider(height: 1, color: AppColors.chassisBorder),
          const SizedBox(height: 14),

          // Section 1: Lengan Robot (Arm Pitch)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.vertical_align_center_rounded,
                    size: 17,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    'LENGAN ROBOT',
                    style: AppStyles.labelMd(
                      color: AppColors.onSurface,
                      weight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              Text(
                '${mqttService.gripperPitch.toStringAsFixed(1)}°',
                style: AppStyles.labelMd(
                  color: AppColors.secondary,
                  weight: FontWeight.w700,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Lengan Buttons Grid (NAIK / TURUN)
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: _buildTactileActionButton(
                    context: context,
                    label: 'NAIK',
                    icon: Icons.arrow_upward_rounded,
                    color: AppColors.primary,
                    onTap: () => mqttService.sendGripperCommand(MqttConfig.cmdCapitNaik),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildTactileActionButton(
                    context: context,
                    label: 'TURUN',
                    icon: Icons.arrow_downward_rounded,
                    color: AppColors.primary,
                    onTap: () => mqttService.sendGripperCommand(MqttConfig.cmdCapitTurun),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          // Section 2: Capit Robot (Gripper Clamp)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.front_hand_rounded,
                    size: 17,
                    color: AppColors.secondary,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    'CAPIT ROBOT',
                    style: AppStyles.labelMd(
                      color: AppColors.onSurface,
                      weight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              Text(
                mqttService.gripperStatus,
                style: AppStyles.labelMd(
                  color: AppColors.secondary,
                  weight: FontWeight.w700,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Capit Buttons Grid (BUKA / JEPIT)
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: _buildTactileActionButton(
                    context: context,
                    label: 'BUKA',
                    icon: Icons.open_in_full_rounded,
                    color: AppColors.secondary,
                    onTap: () => mqttService.sendGripperCommand(MqttConfig.cmdCapitBuka),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildTactileActionButton(
                    context: context,
                    label: 'JEPIT',
                    icon: Icons.close_fullscreen_rounded,
                    color: AppColors.tertiary,
                    onTap: () => mqttService.sendGripperCommand(MqttConfig.cmdCapitTutup),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTactileActionButton({
    required BuildContext context,
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: color.withOpacity(0.25),
            width: 2,
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0xFFCBD5E1),
              offset: Offset(0, 3),
              blurRadius: 0,
            ),
            BoxShadow(
              color: Color(0x0F0F172A),
              offset: Offset(0, 4),
              blurRadius: 8,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 6),
            Text(
              label,
              style: AppStyles.labelLg(
                color: color,
                weight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
