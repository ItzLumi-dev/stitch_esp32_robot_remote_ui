import 'dart:math';
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
        // Top & bottom bars are hidden via SystemUiMode.immersiveSticky;
        // left & right SafeArea protects against landscape camera punch-hole/notch.
        top: false,
        bottom: false,
        left: true,
        right: true,
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Virtual cockpit minimum logical canvas matching Google Stitch code.html
            // 12-column grid (3 : 6 : 3). Dynamically preserves exact phone aspect ratio
            // so the UI fills 100% edge-to-edge on 16:9, 19.5:9, 20:9, 21:9 & tablets
            // with ZERO scrolling, ZERO empty margins, and ZERO clipped text.
            const double minVirtualWidth = 1340.0;
            const double minVirtualHeight = 620.0;

            final double safeMaxW = max(constraints.maxWidth, 320.0);
            final double safeMaxH = max(constraints.maxHeight, 200.0);

            final double scale = min(
              safeMaxW / minVirtualWidth,
              safeMaxH / minVirtualHeight,
            );

            final double virtualWidth = safeMaxW / scale;
            final double virtualHeight = safeMaxH / scale;

            return FittedBox(
              fit: BoxFit.contain,
              alignment: Alignment.center,
              child: SizedBox(
                width: virtualWidth,
                height: virtualHeight,
                child: Column(
                  children: [
                    // 1. Top Tactical Header Bar
                    const HeaderBar(),

                    // 2. Main 3-Column Dual-Thumb Cockpit (No-Scroll Full Height)
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: const [
                            // LEFT THUMB ZONE: DRIVE NAVIGATION (xl:col-span-3)
                            Expanded(
                              flex: 3,
                              child: DriveControlCard(),
                            ),

                            SizedBox(width: 14),

                            // CENTER COMMAND & TELEMETRY HUB (xl:col-span-6)
                            Expanded(
                              flex: 6,
                              child: Column(
                                children: [
                                  // Top Row: DS18B20 Temperature & PWM Speed Slider
                                  Expanded(
                                    flex: 43,
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children: [
                                        Expanded(child: TemperatureCard()),
                                        SizedBox(width: 14),
                                        Expanded(child: SpeedSliderCard()),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 12),
                                  // Bottom Row: Live MQTT & MicroSD Terminal
                                  Expanded(
                                    flex: 57,
                                    child: TerminalCard(),
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(width: 14),

                            // RIGHT THUMB ZONE: ACTUATOR / GRIPPER CLUSTER (xl:col-span-3)
                            Expanded(
                              flex: 3,
                              child: ActuatorCard(),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // 3. Bottom Handheld Status Ribbon
                    const FooterBar(),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
