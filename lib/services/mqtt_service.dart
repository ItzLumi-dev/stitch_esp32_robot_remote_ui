import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import '../constants/mqtt_config.dart';
import '../models/terminal_log.dart';

enum MqttStatus { disconnected, connecting, connected, error }

enum TempStatus { normal, hangat, bahaya }

class MqttService extends ChangeNotifier {
  MqttServerClient? _client;
  StreamSubscription<List<MqttReceivedMessage<MqttMessage>>>? _updatesSub;
  MqttStatus _connectionStatus = MqttStatus.disconnected;

  // Telemetry state
  double _temperature = 32.5;
  final List<double> _tempHistory = [28.0, 29.5, 31.0, 32.0, 32.5];
  String _diagnosticStatus = 'SD:INIT,RTC:INIT';
  int _pingMs = 0;
  DateTime? _lastPingSentTime;
  Timer? _pingTimer;
  Timer? _reconnectTimer;

  // Motor & Drive state
  int _currentSpeed = 180;
  String _activeDriveCommand = 'STANDBY';
  String _gripperStatus = 'SIAP';
  double _gripperPitch = 24.5;
  bool _isHeatSimActive = false;
  Timer? _heatSimTimer;

  // Terminal Logs (max 18 lines)
  final List<TerminalLog> _terminalLogs = [];

  // Getters
  MqttStatus get connectionStatus => _connectionStatus;
  double get temperature => _temperature;
  List<double> get tempHistory => List.unmodifiable(_tempHistory);
  String get diagnosticStatus => _diagnosticStatus;
  int get pingMs => _pingMs;
  int get currentSpeed => _currentSpeed;
  String get activeDriveCommand => _activeDriveCommand;
  String get gripperStatus => _gripperStatus;
  double get gripperPitch => _gripperPitch;
  bool get isHeatSimActive => _isHeatSimActive;
  List<TerminalLog> get terminalLogs => List.unmodifiable(_terminalLogs);

  TempStatus get tempStatus {
    if (_temperature < 35.0) return TempStatus.normal;
    if (_temperature <= 40.0) return TempStatus.hangat;
    return TempStatus.bahaya;
  }

  String get tempStatusLabel {
    switch (tempStatus) {
      case TempStatus.normal:
        return 'Normal (< 35°C)';
      case TempStatus.hangat:
        return 'Hangat (35-40°C)';
      case TempStatus.bahaya:
        return 'Bahaya Panas (> 40°C)!';
    }
  }

  MqttService() {
    _addLog('SYS: Iris Remote Control initialized.', LogType.info);
    connect();
  }

  String _getTimeStr() {
    final now = DateTime.now();
    return DateFormat('HH:mm:ss.SSS').format(now);
  }

  void _addLog(String message, LogType type) {
    final log = TerminalLog(
      timestamp: '[${_getTimeStr()}]',
      message: message,
      type: type,
    );
    _terminalLogs.add(log);
    // User requirement: Max 18 lines, remove index 0 if length > 18
    while (_terminalLogs.length > 18) {
      _terminalLogs.removeAt(0);
    }
    notifyListeners();
  }

  void clearTerminal() {
    _terminalLogs.clear();
    _addLog('TERMINAL LOG CLEARED. SD RECORDING PERSISTS.', LogType.rx);
    notifyListeners();
  }

  Future<void> connect() async {
    if (_connectionStatus == MqttStatus.connecting ||
        _connectionStatus == MqttStatus.connected) {
      return;
    }

    _connectionStatus = MqttStatus.connecting;
    final wssUrl = 'wss://${MqttConfig.broker}${MqttConfig.websocketPath}';
    _addLog('CON > Connecting to $wssUrl:${MqttConfig.port}...', LogType.info);
    notifyListeners();

    await _updatesSub?.cancel();
    _updatesSub = null;
    _client?.disconnect();

    final clientId = 'iris_remote_${Random().nextInt(999999)}';
    _client = MqttServerClient.withPort(
      wssUrl,
      clientId,
      MqttConfig.port,
    );

    // For WSS on MqttServerClient, useWebSocket = true with wss:// URI handles TLS automatically.
    // Do NOT set secure = true alongside useWebSocket = true.
    _client!.useWebSocket = true;
    _client!.websocketProtocols = MqttClientConstants.protocolsSingleDefault;
    _client!.keepAlivePeriod = 20;
    _client!.connectTimeoutPeriod = 10000;
    _client!.autoReconnect = true;
    _client!.resubscribeOnAutoReconnect = true;
    _client!.logging(on: false);

    _client!.onConnected = _onConnected;
    _client!.onDisconnected = _onDisconnected;
    _client!.onAutoReconnect = _onAutoReconnect;
    _client!.onAutoReconnected = _onAutoReconnected;

    final connMessage = MqttConnectMessage()
        .withClientIdentifier(clientId)
        .authenticateAs(MqttConfig.username, MqttConfig.password)
        .startClean()
        .withWillQos(MqttQos.atMostOnce);
    _client!.connectionMessage = connMessage;

    try {
      await _client!.connect(MqttConfig.username, MqttConfig.password);
      if (_client!.connectionStatus?.state != MqttConnectionState.connected) {
        final returnCode = _client!.connectionStatus?.returnCode;
        _connectionStatus = MqttStatus.error;
        _addLog('ERR > Broker rejected connection ($returnCode)', LogType.error);
        _client!.disconnect();
        notifyListeners();
        _scheduleReconnect();
      }
    } catch (e) {
      _connectionStatus = MqttStatus.error;
      _addLog('ERR > Connection failed: $e', LogType.error);
      _client?.disconnect();
      notifyListeners();
      _scheduleReconnect();
    }
  }

  void _onConnected() {
    _connectionStatus = MqttStatus.connected;
    _addLog('CON > MQTT WSS Connected successfully!', LogType.rx);

    // Subscribe to topics
    _subscribe(MqttConfig.topicTemperature);
    _subscribe(MqttConfig.topicDiagnostic);

    // Start listening to incoming messages (cancel previous listener first)
    _updatesSub?.cancel();
    _updatesSub = _client!.updates?.listen(_onMessageReceived);

    // Start 2-second periodic Ping timer
    _startPingTimer();
    notifyListeners();
  }

  void _onDisconnected() {
    _connectionStatus = MqttStatus.disconnected;
    _stopPingTimer();
    _addLog('CON > MQTT WSS Disconnected.', LogType.error);
    notifyListeners();
    _scheduleReconnect();
  }

  void _onAutoReconnect() {
    _connectionStatus = MqttStatus.connecting;
    _addLog('CON > Auto-reconnecting to MQTT Broker...', LogType.info);
    notifyListeners();
  }

  void _onAutoReconnected() {
    _connectionStatus = MqttStatus.connected;
    _addLog('CON > Auto-reconnected to MQTT Broker!', LogType.rx);
    _startPingTimer();
    notifyListeners();
  }

  void _scheduleReconnect() {
    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(const Duration(seconds: 4), () {
      if (_connectionStatus != MqttStatus.connected) {
        connect();
      }
    });
  }

  void _subscribe(String topic) {
    if (_client?.connectionStatus?.state == MqttConnectionState.connected) {
      _client!.subscribe(topic, MqttQos.atLeastOnce);
      _addLog('SUB < Subscribed to $topic', LogType.rx);
    }
  }

  void _onMessageReceived(List<MqttReceivedMessage<MqttMessage>> messages) {
    for (final message in messages) {
      final topic = message.topic;
      final pubMessage = message.payload as MqttPublishMessage;
      final payload = MqttPublishPayload.bytesToStringAsString(pubMessage.payload.message);

      _addLog('RX < $topic: $payload', LogType.rx);

      // Handle Temperature Topic
      if (topic == MqttConfig.topicTemperature) {
        final parsed = double.tryParse(payload.trim());
        if (parsed != null) {
          _temperature = parsed;
          _tempHistory.add(parsed);
          if (_tempHistory.length > 25) {
            _tempHistory.removeAt(0);
          }
          notifyListeners();
        }
      }

      // Handle Diagnostic Topic
      if (topic == MqttConfig.topicDiagnostic) {
        _diagnosticStatus = payload.trim();
        // Calculate latency from last ping
        if (_lastPingSentTime != null) {
          final now = DateTime.now();
          _pingMs = now.difference(_lastPingSentTime!).inMilliseconds;
        }
        notifyListeners();
      }
    }
  }

  // Publish to topic
  void publish(String topic, String message, {bool isSilentPing = false}) {
    if (_client?.connectionStatus?.state != MqttConnectionState.connected) {
      if (!isSilentPing) {
        _addLog('WARN > Cannot send $message (MQTT offline)', LogType.error);
      }
      return;
    }

    final builder = MqttClientPayloadBuilder();
    builder.addString(message);
    _client!.publishMessage(topic, MqttQos.atLeastOnce, builder.payload!);

    if (!isSilentPing) {
      _addLog('TX > $topic: $message', LogType.tx);
    }
  }

  // Requirement 4: Periodic Ping every 2 seconds
  void _startPingTimer() {
    _pingTimer?.cancel();
    _pingTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (_connectionStatus == MqttStatus.connected) {
        _lastPingSentTime = DateTime.now();
        publish(MqttConfig.topicControl, MqttConfig.cmdPing);
      }
    });
  }

  void _stopPingTimer() {
    _pingTimer?.cancel();
    _pingTimer = null;
  }

  // Requirement 2: D-Pad / Joystick Drive Commands
  void sendDriveCommand(String cmd) {
    _activeDriveCommand = cmd;
    publish(MqttConfig.topicControl, cmd);
    notifyListeners();
  }

  void releaseDriveCommand() {
    _activeDriveCommand = 'STANDBY';
    publish(MqttConfig.topicControl, MqttConfig.cmdStop);
    notifyListeners();
  }

  // Emergency Stop
  void emergencyStop() {
    _activeDriveCommand = 'EMERGENCY_STOP';
    publish(MqttConfig.topicControl, MqttConfig.cmdStop);
    _addLog('SAFETY > EMERGENCY STOP TRIGGERED!', LogType.error);
    notifyListeners();
  }

  // Gripper Actuator commands
  void sendGripperCommand(String action) {
    if (action == MqttConfig.cmdCapitNaik) {
      _gripperPitch = min(90.0, _gripperPitch + 15.0);
      _gripperStatus = 'NAIK';
    } else if (action == MqttConfig.cmdCapitTurun) {
      _gripperPitch = max(-30.0, _gripperPitch - 15.0);
      _gripperStatus = 'TURUN';
    } else if (action == MqttConfig.cmdCapitBuka) {
      _gripperStatus = 'BUKA';
    } else if (action == MqttConfig.cmdCapitTutup) {
      _gripperStatus = 'JEPIT';
    }
    publish(MqttConfig.topicControl, action);
    notifyListeners();
  }

  // Speed PWM Slider commands
  void setSpeed(int speed) {
    final clamped = speed.clamp(0, 255);
    _currentSpeed = clamped;
    publish(MqttConfig.topicSpeed, clamped.toString());
    notifyListeners();
  }

  // Heat Simulation Toggle
  void toggleHeatSimulation() {
    _isHeatSimActive = !_isHeatSimActive;
    _heatSimTimer?.cancel();

    if (_isHeatSimActive) {
      _addLog('SIM > Temperature heat simulation active.', LogType.tx);
      _heatSimTimer = Timer.periodic(const Duration(milliseconds: 600), (_) {
        _temperature = double.parse((_temperature + 0.8).toStringAsFixed(1));
        _tempHistory.add(_temperature);
        if (_tempHistory.length > 25) _tempHistory.removeAt(0);

        if (_temperature >= 40.0) {
          _addLog('WARN > Core Temp ${_temperature}°C exceeds threshold 40.0°C!', LogType.error);
        }
        notifyListeners();
      });
    } else {
      _temperature = 32.5;
      _tempHistory.add(_temperature);
      if (_tempHistory.length > 25) _tempHistory.removeAt(0);
      _addLog('SIM > Temperature normalized to 32.5°C', LogType.info);
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _pingTimer?.cancel();
    _reconnectTimer?.cancel();
    _heatSimTimer?.cancel();
    _updatesSub?.cancel();
    _client?.disconnect();
    super.dispose();
  }
}
