class AppIdSingleton {
  AppIdSingleton._privateConstructor();

  static final AppIdSingleton _instance = AppIdSingleton._privateConstructor();
  static AppIdSingleton get instance => _instance;

  String? appId;

  void setAppId(String value) {
    appId = value;
  }

  String? getAppId() {
    return appId;
  }
}
