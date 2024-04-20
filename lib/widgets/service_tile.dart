import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import "characteristic_tile.dart";

class ServiceTile extends StatelessWidget {
  final BluetoothService service;

  const ServiceTile({
    Key? key,
    required this.service,
  }) : super(key: key);

  Widget buildUuid(BuildContext context) {
    String uuid = 'UUID: ${service.uuid.str.toUpperCase()}';
    return Text(uuid, style: const TextStyle(fontSize: 13));
  }

  @override
  Widget build(BuildContext context) {
    return service.characteristics.isNotEmpty
        ? ExpansionTile(
            title: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  'Service',
                  style: TextStyle(
                    color: Colors.blue,
                  ),
                ),
                buildUuid(context),
              ],
            ),
            children: service.characteristics
                .map(
                  (c) => CharacteristicTile(
                    characteristic: c,
                  ),
                )
                .toList(),
          )
        : ListTile(
            title: const Text('Service'),
            subtitle: buildUuid(context),
          );
  }
}
