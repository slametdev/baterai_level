import 'dart:async';

import 'package:battery_plus/battery_plus.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  //TODO: Implement HomeController

  var battery = Battery();
  final batteryStatus = "".obs;
  final percentage = 0.obs;
  StreamSubscription<BatteryState>? batteryStateSubscription;
  var imageBatteryLevel = 1.obs;

  Timer? timerCharge;

  @override
  void onInit() {
    setupMonitorBaterailevel();
    super.onInit();
  }

  @override
  void onReady() async {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
    batteryStateSubscription?.cancel();
  }

  void setupMonitorBaterailevel() {
    _fetchBatteryLevel();
    batteryStateSubscription = battery.onBatteryStateChanged.listen((state) {
      switch (state) {
        case BatteryState.full:
          batteryStatus.value = "Fully Charged";
          _fetchBatteryLevel();
          break;
        case BatteryState.charging:
          batteryStatus.value = "Charging";
          chargeIndikator();
          break;
        case BatteryState.discharging:
          batteryStatus.value = "Discharging";
          _fetchBatteryLevel();
          break;
        default:
          batteryStatus.value = "Unknown Status";
          _fetchBatteryLevel();
          break;
      }
    });
  }

  void _fetchBatteryLevel() async {
    timerCharge?.cancel();
    percentage.value = await battery.batteryLevel;
    if (percentage.value == 100) {
      imageBatteryLevel.value = 6;
    } else if (percentage.value >= 80) {
      imageBatteryLevel.value = 5;
    } else if (percentage.value >= 60) {
      imageBatteryLevel.value = 4;
    } else if (percentage.value >= 40) {
      imageBatteryLevel.value = 3;
    } else if (percentage.value >= 20) {
      imageBatteryLevel.value = 2;
    } else if (percentage.value >= 0) {
      imageBatteryLevel.value = 1;
    }
  }

  void chargeIndikator() {
    if (timerCharge != null && timerCharge!.isActive) {
      return;
    }
    timerCharge = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (imageBatteryLevel.value + 1 > 6) {
        imageBatteryLevel.value = 1;
      } else {
        imageBatteryLevel.value++;
      }
    });
  }
}
