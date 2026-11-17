/// MQTT Configuration and Topics Definition
class MqttConfig {
  MqttConfig._();

  // Connection
  static const String broker = 'lf96fe6f.ala.asia-southeast1.emqxsl.com';
  static const int port = 8084;
  static const String username = 'IoTIris';
  static const String password = 'IoTIris123';
  static const bool useWss = true;
  static const String websocketPath = '/mqtt';

  // Publish Topics
  static const String topicControl = 'garuda/iot_iris_ab5c9/kendali';
  static const String topicSpeed = 'garuda/iot_iris_ab5c9/kendali/speed';

  // Subscribe Topics
  static const String topicTemperature = 'garuda/iot_iris_ab5c9/sensor/suhu';
  static const String topicDiagnostic = 'garuda/iot_iris_ab5c9/status/diag';

  // Commands
  static const String cmdMaju = 'MAJU';
  static const String cmdMundur = 'MUNDUR';
  static const String cmdKiri = 'KIRI';
  static const String cmdKanan = 'KANAN';
  static const String cmdStop = 'STOP';

  static const String cmdCapitNaik = 'CAPIT_NAIK';
  static const String cmdCapitTurun = 'CAPIT_TURUN';
  static const String cmdCapitBuka = 'CAPIT_BUKA';
  static const String cmdCapitTutup = 'CAPIT_TUTUP';

  static const String cmdPing = 'PING';
}
