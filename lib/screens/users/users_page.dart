import 'package:ble_project/global/global_data.dart';
import 'package:ble_project/screens/create_user/create_user_page.dart';
import 'package:ble_project/screens/history/history_page.dart';
import 'package:ble_project/screens/scan_screen/scan_screen_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'users_cubit.dart';

class UsersPage extends StatelessWidget {
  const UsersPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return UsersCubit();
      },
      child: const UsersChildPage(),
    );
  }
}

class UsersChildPage extends StatefulWidget {
  const UsersChildPage({Key? key}) : super(key: key);

  @override
  State<UsersChildPage> createState() => _UsersChildPageState();
}

class _UsersChildPageState extends State<UsersChildPage> {
  late final UsersCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = BlocProvider.of(context);
    _cubit.loadInitialData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Danh sách người dùng"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const CreateUserPage(),
              settings: const RouteSettings(name: '/CreateUserScreen'),
            ),
          );

          if (result != null) {
            _cubit.loadInitialData();
          }
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: BlocBuilder<UsersCubit, UsersState>(builder: (context, state) {
          return ListView.builder(
            padding: const EdgeInsets.only(top: 8),
            itemCount: state.listUser?.length ?? 0,
            itemBuilder: (context, index) {
              final item = state.listUser![index];
              return InkWell(
                onTap: () async {
                  GlobalData.instance.userSelected = item;

                  await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const ScanScreenPage(),
                      settings: const RouteSettings(name: '/ScanScreen'),
                    ),
                  );

                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        "${item.userName}",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        "${item.address}",
                      ),
                      InkWell(
                        onTap: () {
                          MaterialPageRoute route = MaterialPageRoute(
                            builder: (context) => HistoryPage(
                              arguments: HistoryArguments(
                                userId: item.getId,
                                userName: item.userName,
                              ),
                            ),
                            settings: const RouteSettings(
                              name: '/HistoryScreen',
                            ),
                          );
                          Navigator.of(context).push(route);
                        },
                        child: const Text(
                          "Xem lịch sử",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }
}
