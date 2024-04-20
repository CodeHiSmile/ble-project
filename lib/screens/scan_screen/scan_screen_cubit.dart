import 'package:ble_project/models/enums/load_status.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

part 'scan_screen_state.dart';

class ScanScreenCubit extends Cubit<ScanScreenState> {
  ScanScreenCubit() : super(const ScanScreenState());

  void listenDeviceState(List<ScanResult> devices) {
    emit(state.copyWith(
      scanResults: devices,
    ));
  }

  void listenBluetoothState(List<BluetoothDevice> systemDevices) {
    emit(state.copyWith(
      systemDevices: systemDevices,
    ));
  }

  void changeScanDeviceStatus(bool status) {
    emit(state.copyWith(
      isScanning: status,
    ));
  }
}
