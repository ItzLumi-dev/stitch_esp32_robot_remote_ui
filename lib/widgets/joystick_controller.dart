import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../constants/app_styles.dart';
import '../constants/mqtt_config.dart';
import '../services/mqtt_service.dart';

class JoystickController extends StatefulWidget {
  final double size;

  const JoystickController({super.key, this.size = 200});

  @override
  State<JoystickController> createState() => _JoystickControllerState();
}

class _JoystickControllerState extends State<JoystickController> {
  Offset _dragOffset = Offset.zero;
  String _lastSentCommand = MqttConfig.cmdStop;

  void _onPanUpdate(DragUpdateDetails details, double maxRadius, MqttService mqtt) {
    final newOffset = _dragOffset + details.delta;
    final distance = newOffset.distance;

    Offset clampedOffset = newOffset;
    if (distance > maxRadius) {
      clampedOffset = Offset.fromDirection(newOffset.direction, maxRadius);
    }

    setState(() {
      _dragOffset = clampedOffset;
    });

    // Determine direction command based on vector angle
    final threshold = maxRadius * 0.35;
    if (clampedOffset.distance > threshold) {
      final angle = clampedOffset.direction * (180 / pi); // -180 to 180
      String command;
      // angle: 0 is right, 90 is down, -90 is up, 180/-180 is left
      if (angle >= -135 && angle <= -45) {
        command = MqttConfig.cmdMaju;
      } else if (angle >= 45 && angle <= 135) {
        command = MqttConfig.cmdMundur;
      } else if (angle > 135 || angle < -135) {
        command = MqttConfig.cmdKiri;
      } else {
        command = MqttConfig.cmdKanan;
      }

      if (_lastSentCommand != command) {
        _lastSentCommand = command;
        mqtt.sendDriveCommand(command);
      }
    } else {
      if (_lastSentCommand != MqttConfig.cmdStop) {
        _lastSentCommand = MqttConfig.cmdStop;
        mqtt.releaseDriveCommand();
      }
    }
  }

  void _onPanEnd(MqttService mqtt) {
    setState(() {
      _dragOffset = Offset.zero;
    });
    if (_lastSentCommand != MqttConfig.cmdStop) {
      _lastSentCommand = MqttConfig.cmdStop;
      mqtt.releaseDriveCommand();
    }
  }

  void _recenter(MqttService mqtt) {
    setState(() {
      _dragOffset = Offset.zero;
    });
    _lastSentCommand = MqttConfig.cmdStop;
    mqtt.releaseDriveCommand();
  }

  @override
  Widget build(BuildContext context) {
    final mqtt = context.read<MqttService>();
    final s = widget.size;
    final knobSize = s * 0.32;
    final maxRadius = (s - knobSize) / 2;

    return SizedBox(
      width: s,
      height: s,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer Radial Boundary Ring with Angle Markings & Crosshairs
          Container(
            width: s,
            height: s,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.surfaceContainerLow,
              border: Border.all(
                color: AppColors.primary.withOpacity(0.25),
                width: 2,
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x0F000000),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Outer ring guide
                Container(
                  width: s * 0.72,
                  height: s * 0.72,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.primary.withOpacity(0.15),
                      width: 1,
                    ),
                  ),
                ),
                // Inner dashed-like ring
                Container(
                  width: s * 0.44,
                  height: s * 0.44,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.primary.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                ),
                // Horizontal crosshair
                Container(
                  width: s,
                  height: 1,
                  color: AppColors.primary.withOpacity(0.2),
                ),
                // Vertical crosshair
                Container(
                  width: 1,
                  height: s,
                  color: AppColors.primary.withOpacity(0.2),
                ),

                // Cardinal Heading Labels
                Positioned(
                  top: 4,
                  child: Text(
                    '0° / MAJU',
                    style: AppStyles.labelSm(
                      color: AppColors.primary.withOpacity(0.75),
                      weight: FontWeight.w700,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 4,
                  child: Text(
                    '180° / MUNDUR',
                    style: AppStyles.labelSm(
                      color: AppColors.primary.withOpacity(0.75),
                      weight: FontWeight.w700,
                    ),
                  ),
                ),
                Positioned(
                  left: 4,
                  child: Text(
                    '270°',
                    style: AppStyles.labelSm(
                      color: AppColors.primary.withOpacity(0.75),
                      weight: FontWeight.w700,
                    ),
                  ),
                ),
                Positioned(
                  right: 4,
                  child: Text(
                    '90°',
                    style: AppStyles.labelSm(
                      color: AppColors.primary.withOpacity(0.75),
                      weight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Tactile Draggable Thumbstick Knob
          Transform.translate(
            offset: _dragOffset,
            child: GestureDetector(
              onPanUpdate: (details) => _onPanUpdate(details, maxRadius, mqtt),
              onPanEnd: (_) => _onPanEnd(mqtt),
              onPanCancel: () => _onPanEnd(mqtt),
              child: Container(
                width: knobSize,
                height: knobSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.surfaceContainerLowest,
                  border: Border.all(color: AppColors.primary, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.22),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                    const BoxShadow(
                      color: Color(0x1F0F172A),
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: Container(
                    width: knobSize * 0.68,
                    height: knobSize * 0.68,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.surfaceContainer.withOpacity(0.7),
                      border: Border.all(
                        color: AppColors.primary.withOpacity(0.25),
                        width: 1,
                      ),
                    ),
                    child: Center(
                      child: Container(
                        width: knobSize * 0.44,
                        height: knobSize * 0.44,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primary.withOpacity(0.12),
                          border: Border.all(
                            color: AppColors.primary.withOpacity(0.4),
                            width: 1,
                          ),
                        ),
                        child: const Icon(
                          Icons.radio_button_checked,
                          size: 16,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Recenter Button
          Positioned(
            bottom: 4,
            right: 4,
            child: GestureDetector(
              onTap: () => _recenter(mqtt),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLowest.withOpacity(0.95),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: AppColors.chassisBorder),
                ),
                child: Text(
                  'RECENTER',
                  style: AppStyles.labelSm(
                    color: AppColors.onSurfaceVariant,
                    weight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
