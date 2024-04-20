part of 'scan_screen_cubit.dart';

class ScanScreenState extends Equatable {
  final LoadStatus loadDataStatus;
  final List<BluetoothDevice>? systemDevices;
  final List<ScanResult>? scanResults;
  final bool isScanning;

  const ScanScreenState({
    this.loadDataStatus = LoadStatus.initial,
    this.systemDevices,
    this.scanResults,
    this.isScanning = false,
  });

  @override
  List<Object?> get props => [
        loadDataStatus,
        systemDevices,
        scanResults,
        isScanning,
      ];

  ScanScreenState copyWith({
    LoadStatus? loadDataStatus,
    List<BluetoothDevice>? systemDevices,
    List<ScanResult>? scanResults,
    bool? isScanning,
  }) {
    return ScanScreenState(
      loadDataStatus: loadDataStatus ?? this.loadDataStatus,
      systemDevices: systemDevices ?? this.systemDevices,
      scanResults: scanResults ?? this.scanResults,
      isScanning: isScanning ?? this.isScanning,
    );
  }
}
