abstract class AppConfig {
  static const isAdminApp = String.fromEnvironment('appType') == 'admin';
}
