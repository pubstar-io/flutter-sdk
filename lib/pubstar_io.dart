import 'pubstar_io_platform_interface.dart';

class PubstarIo {
  Future<String?> getPlatformVersion() {
    return PubstarIoPlatform.instance.getPlatformVersion();
  }

  Future<String?> testMethod() {
    return PubstarIoPlatform.instance.testMethod();
  }
}
