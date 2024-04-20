import 'dart:async';

import 'package:ble_project/screens/device_info/device_info_page.dart';
import 'package:ble_project/utils/extra.dart';
import 'package:ble_project/utils/isar_storage_util.dart';
import 'package:ble_project/utils/snackbar.dart';
import 'package:ble_project/widgets/scan_result_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import 'scan_screen_cubit.dart';

class ScanScreenPage extends StatelessWidget {
  const ScanScreenPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return ScanScreenCubit();
      },
      child: const ScanScreenChildPage(),
    );
  }
}

class ScanScreenChildPage extends StatefulWidget {
  const ScanScreenChildPage({Key? key}) : super(key: key);

  @override
  State<ScanScreenChildPage> createState() => _ScanScreenChildPageState();
}

class _ScanScreenChildPageState extends State<ScanScreenChildPage> {
  late final ScanScreenCubit _cubit;
  late StreamSubscription<List<ScanResult>> _scanResultsSubscription;
  late StreamSubscription<bool> _isScanningSubscription;

  @override
  void initState() {
    super.initState();
    _cubit = BlocProvider.of(context);
    _scanResultsSubscription = FlutterBluePlus.scanResults.listen((results) {
      _cubit.listenDeviceState(results);
    }, onError: (e) {
      // Snackbar.show(
      //   ABC.b,
      //   prettyException("Scan Error:", e),
      //   success: false,
      // );
    });

    _isScanningSubscription = FlutterBluePlus.isScanning.listen((state) {
      _cubit.changeScanDeviceStatus(state);
    });

    onScanPressed();
  }

  @override
  void dispose() {
    _scanResultsSubscription.cancel();
    _isScanningSubscription.cancel();
    _cubit.close();
    super.dispose();
  }

  Future<void> onRefresh() async {
    if (_cubit.state.isScanning == false) {
      FlutterBluePlus.startScan(timeout: const Duration(seconds: 15));
    }
  }

  Future onScanPressed() async {
    try {
      final result = await FlutterBluePlus.systemDevices;
      _cubit.listenBluetoothState(result);

      await FlutterBluePlus.startScan(timeout: const Duration(seconds: 15));
    } catch (e) {
      // Snackbar.show(
      //   ABC.b,
      //   prettyException("System Devices Error:", e),
      //   success: false,
      // );
    }
  }

  Future onStopPressed() async {
    try {
      FlutterBluePlus.stopScan();
    } catch (e) {
      // Snackbar.show(
      //   ABC.b,
      //   prettyException("Stop Scan Error:", e),
      //   success: false,
      // );
    }
  }

  Widget buildScanButton() {
    if (FlutterBluePlus.isScanningNow) {
      return FloatingActionButton(
        onPressed: onStopPressed,
        backgroundColor: Colors.red,
        child: const Icon(Icons.stop),
      );
    } else {
      return FloatingActionButton(
        onPressed: () {
          // saveLogs();
          onScanPressed();
        },
        child: const Text("SCAN"),
      );
    }
  }

  void onConnectPressed(BluetoothDevice device) {
    device.connectAndUpdateStream().catchError((e) {
      Snackbar.show(
        ABC.c,
        prettyException("Connect Error:", e),
        success: false,
      );
    });

    MaterialPageRoute route = MaterialPageRoute(
      builder: (context) => DeviceInfoPage(
        arguments: DeviceInfoArguments(
          device: device,
        ),
      ),
      settings: const RouteSettings(
        name: '/DeviceScreen',
      ),
    );

    Navigator.of(context).push(route);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Kết nối thiết bị',
        ),
        actions: [
          InkWell(
            onTap: () {
              final isarStorage = IsarStorageUtil();
              isarStorage.deleteAll();
            },
            child: const Icon(
              Icons.delete,
            ),
          )
        ],
      ),
      body: BlocBuilder<ScanScreenCubit, ScanScreenState>(
        builder: (context, state) {
          return RefreshIndicator(
            onRefresh: onRefresh,
            child: ListView.builder(
              itemCount: state.scanResults?.length ?? 0,
              itemBuilder: (context, index) {
                final item = state.scanResults![index];

                return ScanResultTile(
                  result: item,
                  onTap: () {
                    onConnectPressed(item.device);
                  },
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: buildScanButton(),
    );
  }
}
