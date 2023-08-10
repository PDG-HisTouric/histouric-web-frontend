import 'package:bloc/bloc.dart';
import 'package:histouric_web/domain/entities/entities.dart';
import 'package:histouric_web/domain/entities/token.dart';
import 'package:histouric_web/domain/repositories/repositories.dart';

import '../../../infrastructure/services/services.dart';

part 'logged_user_event.dart';
part 'logged_user_state.dart';

class LoggedUserBloc extends Bloc<LoggedUserEvent, LoggedUserState> {
  final UserRepository userRepository;
  final KeyValueStorageService keyValueStorageService;

  LoggedUserBloc(
      {required this.userRepository, required this.keyValueStorageService})
      : super(LoggedUserState()) {
    on<CheckToken>(_onCheckToken);
  }

  void _onCheckToken(CheckToken event, Emitter<LoggedUserState> emit) async {
    try {
      String tokenString =
          (await keyValueStorageService.getValue<String>("token"))!;
      userRepository.configureToken(tokenString);
      String nickname =
          (await keyValueStorageService.getValue<String>("nickname"))!;
      HistouricUser histouricUser =
          await userRepository.getUserByNickname(nickname);
      emit(state.copyWith(
          nickname: nickname,
          token: tokenString,
          authStatus: AuthStatus.authenticated,
          email: histouricUser.email,
          roles: histouricUser.roles.map((role) => role.name).toList()));
    } catch (e) {
      emit(state.copyWith(authStatus: AuthStatus.notAuthenticated));
    }
    print(state.authStatus.toString());
  }

  void updateLoggedUser() {
    add(CheckToken());
  }
}
