import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:histouric_web/infrastructure/datasource/spring_boot_user_datasource.dart';
import 'package:histouric_web/infrastructure/repositories/user_repository_impl.dart';
import 'package:histouric_web/presentation/blocs/blocs.dart';
import 'package:histouric_web/presentation/widgets/custom_card.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileBloc(
        profilePurpose: ProfilePurpose.viewMyProfile,
        context: context,
        authBloc: context.read<AuthBloc>(),
        userRepository:
            UserRepositoryImpl(userDatasource: SpringBootUserDatasource()),
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
            child: SizedBox(
              width: 400,
              child: CustomCard(),
            ),
          ),
        )
      ],
    );
  }
}
