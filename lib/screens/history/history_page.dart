import 'package:ble_project/screens/log_info/log_info_screen.dart';
import 'package:ble_project/utils/isar_storage_util.dart';
import 'package:ble_project/widgets/spark_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'history_cubit.dart';
import 'package:intl/intl.dart';

class HistoryArguments {
  final int? userId;
  final String? userName;

  HistoryArguments({
    this.userId,
    this.userName,
  });
}

class HistoryPage extends StatelessWidget {
  final HistoryArguments? arguments;

  const HistoryPage({
    Key? key,
    this.arguments,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return HistoryCubit();
      },
      child: HistoryChildPage(
        arguments: arguments,
      ),
    );
  }
}

class HistoryChildPage extends StatefulWidget {
  final HistoryArguments? arguments;

  const HistoryChildPage({
    Key? key,
    this.arguments,
  }) : super(key: key);

  @override
  State<HistoryChildPage> createState() => _HistoryChildPageState();
}

class _HistoryChildPageState extends State<HistoryChildPage> {
  late final HistoryCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = BlocProvider.of(context);
    _cubit.loadInitialData(widget.arguments?.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lịch sử"),
      ),
      body: SafeArea(
        child: _buildBodyWidget(),
      ),
    );
  }

  Widget _buildBodyWidget() {
    return BlocBuilder<HistoryCubit, HistoryState>(builder: (context, state) {
      return RefreshIndicator(
        onRefresh: () async {
          _cubit.loadInitialData(widget.arguments?.userId);
        },
        child: ListView.builder(
          itemCount: state.logs?.length ?? 0,
          itemBuilder: (context, index) {
            final item = state.logs![index];
            final createDate = DateFormat('dd/MM/yyyy  HH:mm:ss')
                .format(DateTime.parse(item.createDate ?? ''));

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black,
                    ),
                  ),
                  margin: const EdgeInsets.all(16),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text("Ngày tạo: $createDate"),
                          ),
                          InkWell(
                            onTap: () {
                              MaterialPageRoute route = MaterialPageRoute(
                                builder: (context) => LogInfoScreen(
                                  logsData: item.listData,
                                  fileName: "${widget.arguments?.userName ?? ''}_${item.createDate}",
                                ),
                              );

                              Navigator.of(context).push(route);
                            },
                            child: const Text(
                              "Xem Logs",
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () async {
                              final isarStorage = IsarStorageUtil();
                              await isarStorage.deleteLogs(item);
                              _cubit.loadInitialData(widget.arguments?.userId);
                            },
                            child: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 300,
                        child: Sparkline(
                          max: 3000,
                          min: -3000,
                          enableGridLines: true,
                          gridLineAmount: 11,
                          gridLinelabelPrefix: "   ",
                          gridLineLabelPrecision: 1,
                          data: item.listData!,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      );
    });
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }
}
