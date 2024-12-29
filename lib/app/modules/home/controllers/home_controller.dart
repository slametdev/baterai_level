import 'dart:async';

import 'package:battery_plus/battery_plus.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final bateraiPercentage = 0.obs;
  final bateraiImage = "assets/images/battery/battery_level_1.png".obs;
  final batteryLevel = 0.obs;
  final bateraiStatus = "".obs;

  var battery = Battery();

  StreamSubscription<BatteryState>? batteryStateSubscription;

  Timer? timerCharge;

  @override
  void onInit() {
    setupMonitorBateraiLevel();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    batteryStateSubscription?.cancel();
    timerCharge?.cancel();
    super.onClose();
  }

  setupMonitorBateraiLevel() {
    fetchBatteryLevel();
    batteryStateSubscription = battery.onBatteryStateChanged.listen((state) {
      switch (state) {
        case BatteryState.charging:
          chargeIndikator();
          break;
        default:
          fetchBatteryLevel();
          break;
      }
    });
  }

  fetchBatteryLevel() async {
    timerCharge?.cancel();
    bateraiPercentage.value = await battery.batteryLevel;
    print(bateraiPercentage.value);
    if (bateraiPercentage.value == 100) {
      batteryLevel.value = 6;
    } else if (bateraiPercentage.value >= 80) {
      batteryLevel.value = 5;
    } else if (bateraiPercentage.value >= 60) {
      batteryLevel.value = 4;
    } else if (bateraiPercentage.value >= 40) {
      batteryLevel.value = 3;
    } else if (bateraiPercentage.value >= 20) {
      batteryLevel.value = 2;
    } else if (bateraiPercentage.value >= 0) {
      batteryLevel.value = 1;
    }
    bateraiImage.value =
        "assets/images/battery/battery_level_${batteryLevel.value}.png";
  }

  chargeIndikator() {
    if (timerCharge != null && timerCharge!.isActive) {
      return;
    }
    timerCharge = Timer.periodic(Duration(seconds: 1), (timer) async {
      if (batteryLevel.value + 1 > 6) {
        batteryLevel.value = 1;
      } else {
        batteryLevel.value++;
      }
      bateraiImage.value =
          "assets/images/battery/battery_level_${batteryLevel.value}.png";
    });
  }
}
