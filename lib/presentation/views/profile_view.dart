import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:histouric_web/infrastructure/datasource/spring_boot_user_datasource.dart';
import 'package:histouric_web/infrastructure/inputs/email.dart';
import 'package:histouric_web/infrastructure/repositories/user_repository_impl.dart';
import 'package:histouric_web/presentation/blocs/blocs.dart';
import 'package:histouric_web/presentation/blocs/profile_bloc/profile_bloc.dart';
import 'package:histouric_web/presentation/widgets/container_with_gradient.dart';
import 'package:histouric_web/presentation/widgets/custom_card.dart';

import '../widgets/star_painter.dart';

class ProfileView extends StatelessWidget {
  final bool forEditing;

  const ProfileView({super.key, required this.forEditing});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileBloc(
        forEditing: forEditing,
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
    final authState = context.watch<AuthBloc>().state;

    return const Stack(
      children: [
        ContainerWithGradient(),
        _BackgroundFigures(),
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

class _BackgroundFigures extends StatelessWidget {
  const _BackgroundFigures({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Stack(
      children: [
        Positioned(
          top: 50,
          left: 50,
          child: _buildStar(
            30.0,
            colorScheme.onPrimary.withOpacity(0.2),
          ),
        ),
        Positioned(
          top: 150,
          right: 50,
          child: _buildStar(
            20.0,
            colorScheme.onPrimary.withOpacity(0.2),
          ),
        ),
        Positioned(
          bottom: 100,
          left: 150,
          child: _buildCircle(
            100.0,
            colorScheme.onPrimary.withOpacity(0.2),
          ),
        ),
        Positioned(
          bottom: 80,
          right: 200,
          child: _buildStar(
            25.0,
            colorScheme.onPrimary.withOpacity(0.2),
          ),
        ),
        Positioned(
          top: 250,
          left: 200,
          child: _buildStar(
            70.0,
            colorScheme.onPrimary.withOpacity(0.2),
          ),
        ),
        Positioned(
          top: 350,
          right: 100,
          child: _buildStar(
            35.0,
            colorScheme.onPrimary.withOpacity(0.2),
          ),
        ),
        Positioned(
          bottom: 250,
          left: 100,
          child: _buildStar(
            50.0,
            colorScheme.onPrimary.withOpacity(0.2),
          ),
        ),
        Positioned(
          bottom: 300,
          right: 150,
          child: _buildStar(
            30.0,
            colorScheme.onPrimary.withOpacity(0.2),
          ),
        ),
        Positioned(
          top: 400,
          left: 250,
          child: _buildCircle(
            80.0,
            colorScheme.onPrimary.withOpacity(0.2),
          ),
        ),
        Positioned(
          top: 500,
          right: 150,
          child: _buildStar(
            50.0,
            colorScheme.onPrimary.withOpacity(0.2),
          ),
        ),
        Positioned(
          bottom: 400,
          left: 100,
          child: _buildCircle(
            40.0,
            colorScheme.onPrimary.withOpacity(0.2),
          ),
        ),
        Positioned(
          bottom: 450,
          right: 200,
          child: _buildStar(
            20.0,
            colorScheme.onPrimary.withOpacity(0.2),
          ),
        ),
      ],
    );
  }
}

Widget _buildStar(double size, Color color) {
  return CustomPaint(
    painter: StarPainter(size: size, color: color),
  );
}

Widget _buildCircle(double radius, Color color) {
  return Container(
    width: radius * 2,
    height: radius * 2,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: color,
    ),
  );
}
