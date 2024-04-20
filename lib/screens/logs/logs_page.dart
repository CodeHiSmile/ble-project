import 'dart:async';
import 'package:ble_project/global/global_data.dart';
import 'package:ble_project/models/entities/log_entity.dart';
import 'package:ble_project/utils/isar_storage_util.dart';
import 'package:ble_project/utils/snackbar.dart';
import 'package:ble_project/widgets/spark_line.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'dart:math' as math;

import 'logs_cubit.dart';

class LogsArguments {
  final BluetoothCharacteristic characteristic;

  LogsArguments({
    required this.characteristic,
  });
}

class LogsPage extends StatelessWidget {
  final LogsArguments arguments;

  const LogsPage({
    Key? key,
    required this.arguments,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return LogsCubit();
      },
      child: LogsChildPage(
        arguments: arguments,
      ),
    );
  }
}

class LogsChildPage extends StatefulWidget {
  final LogsArguments arguments;

  const LogsChildPage({
    Key? key,
    required this.arguments,
  }) : super(key: key);

  @override
  State<LogsChildPage> createState() => _LogsChildPageState();
}

class _LogsChildPageState extends State<LogsChildPage>
    with SingleTickerProviderStateMixin {
  late final LogsCubit _cubit;
  late StreamSubscription<List<int>> _lastValueSubscription;
  late TabController tabController;
  late Timer _timer;

  BluetoothCharacteristic get characteristic => widget.arguments.characteristic;

  List<String> pages = [
    "Biểu đồ",
    "Logs",
  ];

  @override
  void initState() {
    super.initState();
    _cubit = BlocProvider.of(context);

    tabController = TabController(
      length: pages.length,
      initialIndex: 0,
      vsync: this,
    );

    _lastValueSubscription = characteristic.lastValueStream.listen((value) {
      _cubit.receivedData(value);
    });

    startTimer();
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 15), (timer) async {
      await saveLogsData();
      _cubit.resetData();
    });
  }

  Future saveLogsData() async {
    List<int> listData = [];
    if ((_cubit.state.listData ?? []).isNotEmpty) {
      for (int i = 0; i < _cubit.state.listData!.length; i++) {
        listData.addAll(_cubit.state.listData![i]);
      }
    }

    final isarStorage = IsarStorageUtil();
    isarStorage.saveLogs(
      LogsEntity(
        listData: listData,
        userId: GlobalData.instance.userSelected?.getId,
        createDate: DateTime.now().toString(),
      ),
    );
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

      if (characteristic.isNotifying == false) {
        _timer.cancel();
      } else {
        _cubit.resetData();
        _timer.cancel();
        startTimer();
      }
      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      Snackbar.show(ABC.c, prettyException("Subscribe Error:", e),
          success: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chi tiết"),
        leading: InkWell(
          onTap: () {
            onSubscribePressed();
            Navigator.of(context).pop();
          },
          child: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        actions: [
          buildSubscribeButton(),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            TabBar(
              onTap: (index) {
                tabController.animateTo(index);
              },
              tabs: [
                Tab(
                  child: Text(
                    pages[0],
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Tab(
                  child: Text(
                    pages[1],
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
              indicatorWeight: 2,
              controller: tabController,
            ),
            Expanded(
              child: TabBarView(
                controller: tabController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildChartWidget(),
                  _buildLogsWidget(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartWidget() {
    return BlocBuilder<LogsCubit, LogsState>(
      builder: (context, state) {
        List<int> listData = [];
        if ((state.listData ?? []).isNotEmpty) {
          for (int i = 0; i < state.listData!.length; i++) {
            listData.addAll(state.listData![i]);
          }

          return Center(
            child: Container(
              // decoration: BoxDecoration(
              //   border: Border.all(
              //     color: Colors.grey,
              //   ),
              // ),
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              width: double.infinity,
              height: 300.0,
              child: Sparkline(
                max: 3000,
                min: -3000,
                enableGridLines: true,
                gridLineAmount: 11,
                gridLinelabelPrefix: "   ",
                gridLineLabelPrecision: 1,
                data: listData,
              ),
            ),
          );
        }
        return const SizedBox();
      },
    );
  }

  Widget _buildLogsWidget() {
    return BlocBuilder<LogsCubit, LogsState>(
      buildWhen: (prev, current) {
        return prev.loadDataStatus != current.loadDataStatus;
      },
      builder: (context, state) {
        return ListView.separated(
          itemCount: state.listData?.length ?? 0,
          separatorBuilder: (_, __) => const Divider(),
          itemBuilder: (context, index) {
            String data = state.listData![index].isNotEmpty
                ? state.listData![index].toString()
                : '';

            if (data.isNotEmpty) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("STT: $index"),
                    Text(
                      data,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              );
            }
            return const SizedBox();
          },
        );
      },
    );
  }

  Widget buildSubscribeButton() {
    bool isNotifying = widget.arguments.characteristic.isNotifying;
    return InkWell(
      onTap: () {
        onSubscribePressed();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 8,
        ),
        child: Center(
          child: Text(
            isNotifying ? "Unsubscribe" : "Subscribe",
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _cubit.close();
    _lastValueSubscription.cancel();
    _timer.cancel();
    super.dispose();
  }
}
