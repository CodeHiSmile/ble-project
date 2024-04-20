import 'dart:async';
import 'package:ble_project/utils/extra.dart';
import 'package:ble_project/widgets/service_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import 'device_info_cubit.dart';

class DeviceInfoArguments {
  final BluetoothDevice device;

  DeviceInfoArguments({
    required this.device,
  });
}

class DeviceInfoPage extends StatelessWidget {
  final DeviceInfoArguments arguments;

  const DeviceInfoPage({
    Key? key,
    required this.arguments,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return DeviceInfoCubit();
      },
      child: DeviceInfoChildPage(
        arguments: arguments,
      ),
    );
  }
}

class DeviceInfoChildPage extends StatefulWidget {
  final DeviceInfoArguments arguments;

  const DeviceInfoChildPage({
    Key? key,
    required this.arguments,
  }) : super(key: key);

  @override
  State<DeviceInfoChildPage> createState() => _DeviceInfoChildPageState();
}

class _DeviceInfoChildPageState extends State<DeviceInfoChildPage> {
  late final DeviceInfoCubit _cubit;
  late StreamSubscription<BluetoothConnectionState>
      _connectionStateSubscription;
  late StreamSubscription<bool> _isConnectingSubscription;
  late StreamSubscription<bool> _isDisconnectingSubscription;
  late StreamSubscription<int> _mtuSubscription;
  late BluetoothDevice device;

  @override
  void initState() {
    super.initState();
    _cubit = BlocProvider.of(context);
    device = widget.arguments.device;

    _connectionStateSubscription = device.connectionState.listen((state) async {
      _cubit.changeConnectState(state);

      if (state == BluetoothConnectionState.connected) {
        _cubit.getServices([]);
      }

      if (state == BluetoothConnectionState.connected &&
          _cubit.state.rssi == null) {
        final rssiValue = await device.readRssi();
        _cubit.saveRssi(rssiValue);
      }

      if (mounted) {
        setState(() {});
      }
    });

    _mtuSubscription = device.mtu.listen((value) {
      _cubit.changeMTUSizeValue(value);
    });

    _isConnectingSubscription = device.isConnecting.listen((value) {
      _cubit.connectSubscribe(value);
    });

    _isDisconnectingSubscription = device.isDisconnecting.listen((value) {
      _cubit.disConnectSubscribe(value);
    });
  }

  @override
  void dispose() {
    _connectionStateSubscription.cancel();
    _mtuSubscription.cancel();
    _isConnectingSubscription.cancel();
    _isDisconnectingSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DeviceInfoCubit, DeviceInfoState>(
      builder: (context, state) {
        String deviceState = state.connectionState.toString().split('.')[1];
        return Scaffold(
          appBar: AppBar(
            title: Text(device.platformName),
            leading: InkWell(
              onTap: () {
                if (state.isConnecting) {
                  onCancelPressed();
                } else {
                  if (state.isConnected) {
                    onDisconnectPressed();
                  } else {
                    onConnectPressed();
                  }
                }

                Navigator.of(context).pop();
              },
              child: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
            ),
            actions: [
              buildConnectButton(
                isConnecting: state.isConnecting,
                isConnected: state.isConnected,
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('DeviceId: ${device.remoteId}'),
                ListTile(
                  leading: buildRssiTile(
                    isConnected: state.isConnected,
                    rssi: state.rssi,
                  ),
                  title: Text('Device is $deviceState.'),
                  trailing: TextButton(
                    onPressed: onDiscoverServicesPressed,
                    child: const Text("Get Services"),
                  ),
                ),
                ListTile(
                  title: const Text('MTU Size'),
                  subtitle: Text('${state.mtuSize} bytes'),
                  trailing: IconButton(
                    icon: const Icon(Icons.change_circle_rounded),
                    onPressed: onRequestMtuPressed,
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: state.services?.length ?? 0,
                    itemBuilder: (context, index) {
                      final item = state.services![index];
                      return ServiceTile(
                        service: item,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  ///build Connect/Disconnect Button
  Future onCancelPressed() async {
    try {
      await device.disconnectAndUpdateStream(queue: false);
    } catch (e) {
      debugPrint("$e");
    }
  }

  Future onDisconnectPressed() async {
    try {
      await device.disconnectAndUpdateStream();
    } catch (e) {
      debugPrint("$e");
    }
  }

  Future onConnectPressed() async {
    try {
      await device.connectAndUpdateStream();
    } catch (e) {
      debugPrint("$e");
    }
  }

  Widget buildConnectButton({
    bool isConnecting = false,
    bool isConnected = false,
  }) {
    return TextButton(
      onPressed: () {
        if (isConnecting) {
          onCancelPressed();
        } else {
          if (isConnected) {
            onDisconnectPressed();
          } else {
            onConnectPressed();
          }
        }
      },
      child: Text(
        isConnecting ? "CANCEL" : (isConnected ? "DISCONNECT" : "CONNECT"),
        style: const TextStyle(
          fontSize: 14,
          color: Colors.white,
        ),
      ),
    );
  }

  ///build Bluetooth Device Info
  Widget buildRssiTile({
    bool isConnected = false,
    int? rssi,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        isConnected
            ? const Icon(Icons.bluetooth_connected)
            : const Icon(Icons.bluetooth_disabled),
        Text(
          ((isConnected && rssi != null) ? '$rssi dBm' : ''),
          style: Theme.of(context).textTheme.bodySmall,
        )
      ],
    );
  }

  Future onDiscoverServicesPressed() async {
    try {
      final devices = await device.discoverServices();
      _cubit.getServices(devices);
      // Snackbar.show(ABC.c, "Discover Services: Success", success: true);
    } catch (e) {
      debugPrint("$e");
    }
  }

  ///change MTU Size
  Future onRequestMtuPressed() async {
    try {
      await device.requestMtu(223, predelay: 0);
      // Snackbar.show(ABC.c, "Request Mtu: Success", success: true);
    } catch (e) {
      debugPrint("$e");
    }
  }
}
