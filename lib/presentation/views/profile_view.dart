import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../infrastructure/infrastructure.dart';
import '../blocs/blocs.dart';
import '../widgets/widgets.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileBloc(
        profilePurpose: ProfilePurpose.viewMyProfile,
        context: context,
        authBloc: context.read<AuthBloc>(),
        userRepository: UserRepositoryImpl(
          userDatasource: UserDatasourceImpl(),
        ),
      ),
      child: const _ProfileView(),
    );
  }
}

class _ProfileView extends StatelessWidget {
  const _ProfileView();

  @override
  Widget build(BuildContext context) {
    return const Stack(
      children: [
        Center(
          child: SingleChildScrollView(
            child: SizedBox(width: 400, child: CustomCard()),
          ),
        ),
      ],
    );
  }
}
