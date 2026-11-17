import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../constants/app_styles.dart';
import '../services/mqtt_service.dart';
import 'dpad_controller.dart';
import 'joystick_controller.dart';

enum DriveMode { dpad, joystick }

class DriveControlCard extends StatefulWidget {
  const DriveControlCard({super.key});

  @override
  State<DriveControlCard> createState() => _DriveControlCardState();
}

class _DriveControlCardState extends State<DriveControlCard> {
  DriveMode _mode = DriveMode.dpad;

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
          // Header & Mode Switcher
          Row(
            children: [
              const Icon(
                Icons.sports_esports_rounded,
                color: AppColors.primary,
                size: 20,
              ),
              const SizedBox(width: 5),
              Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'KONTROL PENGGERAK',
                    style: AppStyles.labelMd(
                      color: AppColors.onSurface,
                      weight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 6),
              // Segmented Toggle
              Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainer,
                  borderRadius: BorderRadius.circular(9999),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildModeButton(
                      label: 'D-PAD',
                      isSelected: _mode == DriveMode.dpad,
                      onTap: () => setState(() => _mode = DriveMode.dpad),
                    ),
                    _buildModeButton(
                      label: 'JOYSTICK 360°',
                      isSelected: _mode == DriveMode.joystick,
                      onTap: () => setState(() => _mode = DriveMode.joystick),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Dynamic Controller Area (Auto-fits available vertical & horizontal space cleanly)
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final side = min(constraints.maxWidth, constraints.maxHeight);
                final controllerSize = min(side * 0.94, 270.0).clamp(140.0, 270.0);

                return Center(
                  child: _mode == DriveMode.dpad
                      ? DPadController(size: controllerSize)
                      : JoystickController(size: controllerSize),
                );
              },
            ),
          ),

          const SizedBox(height: 10),

          // Bottom Direction Status Pill
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'STATUS ARAH:',
                  style: AppStyles.labelSm(
                    color: AppColors.onSurfaceVariant,
                    weight: FontWeight.w700,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLowest,
                    borderRadius: BorderRadius.circular(9999),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x0A0F172A),
                        blurRadius: 4,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Text(
                    mqttService.activeDriveCommand,
                    style: AppStyles.labelMd(
                      color: mqttService.activeDriveCommand == 'EMERGENCY_STOP'
                          ? AppColors.tertiary
                          : AppColors.primary,
                      weight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModeButton({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.surfaceContainerLowest : Colors.transparent,
          borderRadius: BorderRadius.circular(9999),
          boxShadow: isSelected
              ? const [
                  BoxShadow(
                    color: Color(0x0F0F172A),
                    blurRadius: 3,
                    offset: Offset(0, 1),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: AppStyles.labelSm(
            color: isSelected ? AppColors.primary : AppColors.onSurfaceVariant,
            weight: isSelected ? FontWeight.w700 : FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
