import 'dart:async';
import 'dart:math';

import 'package:ble_project/screens/logs/logs_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import "../utils/snackbar.dart";

import "descriptor_tile.dart";

class CharacteristicTile extends StatefulWidget {
  final BluetoothCharacteristic characteristic;

  const CharacteristicTile({
    Key? key,
    required this.characteristic,
  }) : super(key: key);

  @override
  State<CharacteristicTile> createState() => _CharacteristicTileState();
}

class _CharacteristicTileState extends State<CharacteristicTile> {
  List<int> _value = [];

  late StreamSubscription<List<int>> _lastValueSubscription;

  BluetoothCharacteristic get characteristic => widget.characteristic;

  @override
  void initState() {
    super.initState();
    _lastValueSubscription =
        widget.characteristic.lastValueStream.listen((value) {
      _value = value;
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _lastValueSubscription.cancel();
    super.dispose();
  }

  List<int> _getRandomBytes() {
    final math = Random();
    return [
      math.nextInt(255),
      math.nextInt(255),
      math.nextInt(255),
      math.nextInt(255)
    ];
  }

  Future onReadPressed() async {
    try {
      await characteristic.read();
      Snackbar.show(ABC.c, "Read: Success", success: true);
    } catch (e) {
      Snackbar.show(ABC.c, prettyException("Read Error:", e), success: false);
    }
  }

  Future onWritePressed() async {
    try {
      await characteristic.write(_getRandomBytes(),
          withoutResponse: characteristic.properties.writeWithoutResponse);
      Snackbar.show(ABC.c, "Write: Success", success: true);
      if (characteristic.properties.read) {
        await characteristic.read();
      }
    } catch (e) {
      Snackbar.show(ABC.c, prettyException("Write Error:", e), success: false);
    }
  }

  Future onSubscribePressed() async {
    try {
      String op =
          characteristic.isNotifying == false ? "Subscribe" : "Unubscribe";
      await characteristic.setNotifyValue(characteristic.isNotifying == false);
      Snackbar.show(ABC.c, "$op : Success", success: true);

      if (characteristic.properties.read) {
        await characteristic.read();
      }
      if (mounted) {
        setState(() {});
      }

      if (mounted) {
        onNavigateToLogsScreen();
      }
    } catch (e) {
      Snackbar.show(ABC.c, prettyException("Subscribe Error:", e),
          success: false);
    }
  }

  Widget buildUuid(BuildContext context) {
    String uuid = 'UUID: ${widget.characteristic.uuid.str.toUpperCase()}';
    return Text(uuid, style: const TextStyle(fontSize: 13));
  }

  Widget buildValue(BuildContext context) {
    String data = _value.isNotEmpty ? _value.toString() : '';
    if (data.isNotEmpty) {
      return Text(
        data,
        style: const TextStyle(
          fontSize: 13,
          color: Colors.grey,
        ),
      );
    }
    return const SizedBox();
  }

  Widget buildReadButton(BuildContext context) {
    return TextButton(
      child: const Text("Read"),
      onPressed: () async {
        await onReadPressed();
        if (mounted) {
          setState(() {});
        }
      },
    );
  }

  Widget buildWriteButton(BuildContext context) {
    bool withoutResp = widget.characteristic.properties.writeWithoutResponse;
    return TextButton(
      child: Text(withoutResp ? "WriteNoResp" : "Write"),
      onPressed: () async {
        await onWritePressed();
        if (mounted) {
          setState(() {});
        }
      },
    );
  }

  Widget buildSubscribeButton(BuildContext context) {
    bool isNotifying = widget.characteristic.isNotifying;
    return TextButton(
      child: Text(isNotifying ? "Unsubscribe" : "Subscribe"),
      onPressed: () async {
        await onSubscribePressed();
        if (mounted) {
          setState(() {});
        }
      },
    );
  }

  Widget buildButtonRow() {
    bool read = widget.characteristic.properties.read;
    bool write = widget.characteristic.properties.write;
    bool notify = widget.characteristic.properties.notify;
    bool indicate = widget.characteristic.properties.indicate;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (read) buildReadButton(context),
        if (write) buildWriteButton(context),
        if (notify || indicate) buildSubscribeButton(context),
      ],
    );
  }

  void onNavigateToLogsScreen() {
    MaterialPageRoute route = MaterialPageRoute(
      builder: (context) => LogsPage(
        arguments: LogsArguments(
          characteristic: characteristic,
        ),
      ),
      settings: const RouteSettings(
        name: '/LogScreen',
      ),
    );

    Navigator.of(context).push(route);
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: ListTile(
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: [
                const Text('Characteristic'),
                const Spacer(),
                buildButtonRow(),
              ],
            ),
            buildUuid(context),
            // buildValue(context),
          ],
        ),
        contentPadding: const EdgeInsets.all(0),
      ),
      children: characteristic.descriptors
          .map((d) => DescriptorTile(descriptor: d))
          .toList(),
    );
  }
}
