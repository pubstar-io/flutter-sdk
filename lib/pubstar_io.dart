import 'pubstar_io_platform_interface.dart';

class PubstarIo {
  Future<String?> getPlatformVersion() {
    return PubstarIoPlatform.instance.getPlatformVersion();
  }

  Future<bool?> init() async {
    return await PubstarIoPlatform.instance.init();
  }
}
