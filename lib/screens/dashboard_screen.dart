import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../widgets/header_bar.dart';
import '../widgets/footer_bar.dart';
import '../widgets/drive_control_card.dart';
import '../widgets/temperature_card.dart';
import '../widgets/speed_slider_card.dart';
import '../widgets/terminal_card.dart';
import '../widgets/actuator_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        top: false,
        bottom: false,
        child: Column(
          children: [
            // Top Tactical Header Bar
            const HeaderBar(),

            // Main Landscape Cockpit Hub (No-Scroll Fitted Layout)
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.topCenter,
                      child: SizedBox(
                        width: constraints.maxWidth > 800 ? constraints.maxWidth : 880,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 1. LEFT THUMB ZONE: DRIVE NAVIGATION (DPAD / JOYSTICK)
                            const SizedBox(
                              width: 235,
                              child: DriveControlCard(),
                            ),

                            const SizedBox(width: 10),

                            // 2. CENTER COMMAND & TELEMETRY HUB
                            const Expanded(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Top Row: Temperature & Speed Slider Cards
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(child: TemperatureCard()),
                                      SizedBox(width: 10),
                                      Expanded(child: SpeedSliderCard()),
                                    ],
                                  ),
                                  SizedBox(height: 8),
                                  // Bottom Row: MQTT & MicroSD Terminal Card
                                  TerminalCard(),
                                ],
                              ),
                            ),

                            const SizedBox(width: 10),

                            // 3. RIGHT THUMB ZONE: ACTUATOR / GRIPPER CLUSTER
                            const SizedBox(
                              width: 235,
                              child: ActuatorCard(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Bottom Handheld Status Ribbon
            const FooterBar(),
          ],
        ),
      ),
    );
  }
}
