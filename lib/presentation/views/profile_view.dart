import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:histouric_web/infrastructure/datasource/spring_boot_user_datasource.dart';
import 'package:histouric_web/infrastructure/inputs/email.dart';
import 'package:histouric_web/infrastructure/repositories/user_repository_impl.dart';
import 'package:histouric_web/presentation/blocs/blocs.dart';
import 'package:histouric_web/presentation/blocs/profile_bloc/profile_bloc.dart';
import 'package:histouric_web/presentation/widgets/container_with_gradient.dart';
import 'package:histouric_web/presentation/widgets/custom_card.dart';

import '../widgets/background_figures.dart';
import '../widgets/star_painter.dart';

class ProfileView extends StatelessWidget {
  final bool forEditing;

  const ProfileView({super.key, required this.forEditing});

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
  const _ProfileView({
    super.key,
  });

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
