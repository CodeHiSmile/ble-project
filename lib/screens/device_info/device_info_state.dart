part of 'device_info_cubit.dart';

class DeviceInfoState extends Equatable {
  final LoadStatus loadDataStatus;
  final int? rssi;
  final int? mtuSize;
  final BluetoothConnectionState connectionState;
  final List<BluetoothService>? services;
  final bool isConnecting;
  final bool isDisconnecting;

  const DeviceInfoState({
    this.loadDataStatus = LoadStatus.initial,
    this.connectionState = BluetoothConnectionState.disconnected,
    this.isConnecting = false,
    this.isDisconnecting = false,
    this.mtuSize,
    this.rssi,
    this.services,
  });

  @override
  List<Object?> get props => [
        loadDataStatus,
        rssi,
        mtuSize,
        connectionState,
        services,
        isConnecting,
        isDisconnecting,
      ];

  DeviceInfoState copyWith({
    LoadStatus? loadDataStatus,
    int? rssi,
    int? mtuSize,
    BluetoothConnectionState? connectionState,
    List<BluetoothService>? services,
    bool? isConnecting,
    bool? isDisconnecting,
  }) {
    return DeviceInfoState(
      loadDataStatus: loadDataStatus ?? this.loadDataStatus,
      rssi: rssi ?? this.rssi,
      mtuSize: mtuSize ?? this.mtuSize,
      connectionState: connectionState ?? this.connectionState,
      services: services ?? this.services,
      isConnecting: isConnecting ?? this.isConnecting,
      isDisconnecting: isDisconnecting ?? this.isDisconnecting,
    );
  }

  bool get isConnected {
    return connectionState == BluetoothConnectionState.connected;
  }
}
