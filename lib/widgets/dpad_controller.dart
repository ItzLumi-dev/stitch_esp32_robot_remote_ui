import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../constants/app_styles.dart';
import '../constants/mqtt_config.dart';
import '../services/mqtt_service.dart';

class DPadController extends StatefulWidget {
  final double size;

  const DPadController({super.key, this.size = 200});

  @override
  State<DPadController> createState() => _DPadControllerState();
}

class _DPadControllerState extends State<DPadController> {
  String? _currentlyPressed;

  void _onPressDown(BuildContext context, String cmd) {
    setState(() => _currentlyPressed = cmd);
    context.read<MqttService>().sendDriveCommand(cmd);
  }

  void _onPressUp(BuildContext context) {
    if (_currentlyPressed != null) {
      setState(() => _currentlyPressed = null);
      context.read<MqttService>().releaseDriveCommand();
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.size;
    final btnSize = s * 0.33; // Button size relative to container
    final centerBtnSize = s * 0.28;

    return SizedBox(
      width: s,
      height: s,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // MAJU (TOP)
          Positioned(
            top: 0,
            child: _buildDirectionButton(
              context: context,
              cmd: MqttConfig.cmdMaju,
              icon: Icons.keyboard_arrow_up_rounded,
              label: 'MAJU',
              width: btnSize,
              height: btnSize,
              iconTop: true,
            ),
          ),

          // MUNDUR (BOTTOM)
          Positioned(
            bottom: 0,
            child: _buildDirectionButton(
              context: context,
              cmd: MqttConfig.cmdMundur,
              icon: Icons.keyboard_arrow_down_rounded,
              label: 'MUNDUR',
              width: btnSize,
              height: btnSize,
              iconTop: false,
            ),
          ),

          // KIRI (LEFT)
          Positioned(
            left: 0,
            child: _buildDirectionButton(
              context: context,
              cmd: MqttConfig.cmdKiri,
              icon: Icons.keyboard_arrow_left_rounded,
              label: 'KIRI',
              width: btnSize,
              height: btnSize,
              iconTop: true,
            ),
          ),

          // KANAN (RIGHT)
          Positioned(
            right: 0,
            child: _buildDirectionButton(
              context: context,
              cmd: MqttConfig.cmdKanan,
              icon: Icons.keyboard_arrow_right_rounded,
              label: 'KANAN',
              width: btnSize,
              height: btnSize,
              iconTop: true,
            ),
          ),

          // CENTER STOP BUTTON
          GestureDetector(
            onTap: () {
              context.read<MqttService>().releaseDriveCommand();
            },
            child: Container(
              width: centerBtnSize,
              height: centerBtnSize,
              decoration: BoxDecoration(
                color: AppColors.tertiary,
                shape: BoxShape.circle,
                boxShadow: const [
                  BoxShadow(
                    color: Color(0xFF930015),
                    offset: Offset(0, 3),
                    blurRadius: 0,
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.stop_rounded,
                    color: AppColors.onTertiary,
                    size: 20,
                  ),
                  Text(
                    'STOP',
                    style: AppStyles.labelSm(
                      color: AppColors.onTertiary,
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

  Widget _buildDirectionButton({
    required BuildContext context,
    required String cmd,
    required IconData icon,
    required String label,
    required double width,
    required double height,
    required bool iconTop,
  }) {
    final isPressed = _currentlyPressed == cmd;

    return Listener(
      onPointerDown: (_) => _onPressDown(context, cmd),
      onPointerUp: (_) => _onPressUp(context),
      onPointerCancel: (_) => _onPressUp(context),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 60),
        width: width,
        height: height,
        transform: Matrix4.translationValues(0, isPressed ? 2 : 0, 0),
        decoration: BoxDecoration(
          color: isPressed ? AppColors.surfaceContainerHigh : AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isPressed ? AppColors.primary : AppColors.primary.withOpacity(0.25),
            width: 2,
          ),
          boxShadow: isPressed
              ? []
              : const [
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
            if (iconTop) ...[
              Icon(icon, color: AppColors.primary, size: 28),
              Text(
                label,
                style: AppStyles.labelSm(
                  color: AppColors.primary,
                  weight: FontWeight.w700,
                ),
              ),
            ] else ...[
              Text(
                label,
                style: AppStyles.labelSm(
                  color: AppColors.primary,
                  weight: FontWeight.w700,
                ),
              ),
              Icon(icon, color: AppColors.primary, size: 28),
            ],
          ],
        ),
      ),
    );
  }
}
