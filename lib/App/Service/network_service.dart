import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

class NetworkService extends GetxService {
  final Connectivity _connectivity = Connectivity();

  RxString networkType = 'wifi'.obs;

  StreamSubscription? _subscription;

  @override
  void onInit() {
    super.onInit();

    _subscription = _connectivity.onConnectivityChanged.listen((result) {
      if (result.contains(ConnectivityResult.mobile)) {
        networkType.value = 'mobile';
      } else if (result.contains(ConnectivityResult.wifi)) {
        networkType.value = 'wifi';
      } else {
        networkType.value = 'none';
      }
    });
  }

  bool get isSlowNetwork => networkType.value == 'mobile';

  @override
  void onClose() {
    _subscription?.cancel();
    super.onClose();
  }
}
