import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class TapController extends GetxController {
  int _tapCount = 0;

  void onTap() {
    _tapCount++;
    update(['tapCount']);
    // update(['tapCount']);
  }

  int get tapCount => _tapCount;
}
