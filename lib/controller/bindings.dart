import 'package:get/get.dart';
import '../assets/asset_widgets.dart';
import 'cloud/auth/profile_controller.dart';
import 'db_controller.dart';
import 'time_controller.dart';

class ControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DbController(), fenix: true);
    Get.lazyPut(() => TimeController(), fenix: true);
    Get.lazyPut(() => MyWidgets(), fenix: true);
    Get.lazyPut(() => ProfileController(), fenix: true);
  }
}
