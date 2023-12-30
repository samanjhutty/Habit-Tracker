import 'package:get/get.dart';
import '../assets/assets.dart';
import 'cloud/profile_controller.dart';
import 'local/db_controller.dart';
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
