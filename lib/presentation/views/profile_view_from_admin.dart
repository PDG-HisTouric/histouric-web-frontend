import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../infrastructure/infrastructure.dart';
import '../blocs/blocs.dart';
import '../widgets/widgets.dart';

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
          userDatasource: UserDatasourceImpl(),
        ),
        keyValueStorageService: KeyValueStorageServiceImpl(),
        authRepository: AuthRepositoryImpl(
          authDatasource: AuthDatasourceImpl(),
        ),
        context: context,
      ),
      child: _ProfileViewFromAdmin(
        token: token,
        nickname: nickname,
        profilePurpose: profilePurpose,
      ),
    );
  }
}

class _ProfileViewFromAdmin extends StatefulWidget {
  final ProfilePurpose profilePurpose;
  final String nickname;
  final String token;

  const _ProfileViewFromAdmin({
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
    BlocProvider.of<AuthBloc>(context, listen: false).loadUserFromAdmin(
      nickname: widget.nickname,
    );
  }

  @override
  Widget build(BuildContext context) {
    final authBloc = context.watch<AuthBloc>();

    if (authBloc.state.authStatus == AuthStatus.checking) {
      return const Center(child: CircularProgressIndicator());
    }

    return Stack(
      children: [
        Center(
          child: SingleChildScrollView(
            child: SizedBox(
              width: 400,
              child: BlocProvider(
                create: (context) => ProfileBloc(
                  authBloc: context.read<AuthBloc>(),
                  userRepository: UserRepositoryImpl(
                    userDatasource: UserDatasourceImpl(),
                  ),
                  context: context,
                  profilePurpose: widget.profilePurpose,
                ),
                child: const CustomCard(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
