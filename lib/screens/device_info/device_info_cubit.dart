import 'package:ble_project/models/enums/load_status.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

part 'device_info_state.dart';

class DeviceInfoCubit extends Cubit<DeviceInfoState> {
  DeviceInfoCubit() : super(const DeviceInfoState());

  void changeMTUSizeValue(int value) {
    emit(state.copyWith(
      mtuSize: value,
    ));
  }

  void connectSubscribe(bool status) {
    emit(state.copyWith(
      isConnecting: status,
    ));
  }

  void disConnectSubscribe(bool status) {
    emit(state.copyWith(
      isDisconnecting: status,
    ));
  }

  void saveRssi(int value) {
    emit(state.copyWith(
      rssi: value,
    ));
  }

  void changeConnectState(BluetoothConnectionState connectionState) {
    emit(state.copyWith(
      connectionState: connectionState,
    ));
  }

  void getServices(List<BluetoothService> services) {
    emit(state.copyWith(
      services: services,
    ));
  }
}
