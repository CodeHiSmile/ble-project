import 'package:ble_project/models/entities/user_entity.dart';
import 'package:ble_project/utils/isar_storage_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'create_user_cubit.dart';

class CreateUserArguments {
  String userId;

  CreateUserArguments({
    required this.userId,
  });
}

class CreateUserPage extends StatelessWidget {
  final CreateUserArguments? arguments;

  const CreateUserPage({
    Key? key,
    this.arguments,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return CreateUserCubit();
      },
      child: const CreateUserChildPage(),
    );
  }
}

class CreateUserChildPage extends StatefulWidget {
  const CreateUserChildPage({Key? key}) : super(key: key);

  @override
  State<CreateUserChildPage> createState() => _CreateUserChildPageState();
}

class _CreateUserChildPageState extends State<CreateUserChildPage> {
  late final CreateUserCubit _cubit;
  late TextEditingController userNameController;
  late TextEditingController birthController;
  late TextEditingController addressController;

  @override
  void initState() {
    super.initState();
    userNameController = TextEditingController();
    birthController = TextEditingController();
    addressController = TextEditingController();

    _cubit = BlocProvider.of(context);
    _cubit.loadInitialData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: _buildBodyWidget(),
      ),
    );
  }

  Widget _buildBodyWidget() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          _buildRow(
            title: "Họ và tên",
            controller: userNameController,
          ),
          _buildRow(
            title: "Ngày sinh",
            controller: birthController,
          ),
          _buildRow(
            title: "Địa chỉ",
            controller: addressController,
          ),
          InkWell(
            onTap: () async {
              final isarStorage = IsarStorageUtil();
              await isarStorage.saveUser(UserEntity(
                userName: userNameController.text,
                dateOfBirth: birthController.text,
                address: addressController.text,
              ));
              if (context.mounted) {
                Navigator.of(context).pop(true);
              }
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.blue,
              ),
              child: const Center(
                child: Text(
                  "Lưu",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildRow({
    required String title,
    String? hinText,
    required TextEditingController controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.grey.withOpacity(0.3),
              ),
            ),
            hintStyle: const TextStyle(
              color: Colors.grey,
              fontStyle: FontStyle.italic,
            ),
            hintText: hinText ?? '',
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }
}
