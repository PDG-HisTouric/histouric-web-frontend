import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:histouric_web/domain/entities/entities.dart';
import 'package:histouric_web/infrastructure/datasource/datasources.dart';
import 'package:histouric_web/infrastructure/repositories/repositories.dart';
import 'package:histouric_web/infrastructure/services/services.dart';
import 'package:histouric_web/presentation/blocs/auth_bloc/auth_bloc.dart';
import 'package:histouric_web/presentation/blocs/blocs.dart';
import 'package:histouric_web/presentation/presentations.dart';

class ProfileViewFromAdmin extends StatelessWidget {
  final ProfilePurpose profilePurpose;
  final String nickname;
  final String token;

  const ProfileViewFromAdmin({
    super.key,
    required this.profilePurpose,
    required this.nickname,
    required this.token,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => AuthBloc(
              token: token,
              userRepository: UserRepositoryImpl(
                userDatasource: SpringBootUserDatasource(),
              ),
              keyValueStorageService: KeyValueStorageServiceImpl(),
              authRepository: AuthRepositoryImpl(
                authDatasource: SpringBootLoginDatasource(),
              ),
              context: context,
            ),
        child: _ProfileViewFromAdmin(
          token: token,
          nickname: nickname,
          profilePurpose: profilePurpose,
        ));
  }
}

class _ProfileViewFromAdmin extends StatefulWidget {
  final ProfilePurpose profilePurpose;
  final String nickname;
  final String token;

  const _ProfileViewFromAdmin({
    super.key,
    required this.profilePurpose,
    required this.nickname,
    required this.token,
  });

  @override
  State<_ProfileViewFromAdmin> createState() => _ProfileViewFromAdminState();
}

class _ProfileViewFromAdminState extends State<_ProfileViewFromAdmin> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<AuthBloc>(context, listen: false)
        .loadUserFromAdmin(nickname: widget.nickname);
  }

  @override
  Widget build(BuildContext context) {
    final authBloc = context.watch<AuthBloc>();

    if (authBloc.state.authStatus == AuthStatus.checking) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Stack(
      children: [
        Center(
          child: SingleChildScrollView(
            child: SizedBox(
              width: 400,
              child: BlocProvider(
                create: (context) => ProfileBloc(
                    // usersTableBloc: context.read<UsersTableBloc>(),
                    authBloc: context.read<AuthBloc>(),
                    userRepository: UserRepositoryImpl(
                        userDatasource: SpringBootUserDatasource()),
                    context: context,
                    profilePurpose: widget.profilePurpose),
                child: const CustomCard(),
              ),
            ),
          ),
        )
      ],
    );
  }
}