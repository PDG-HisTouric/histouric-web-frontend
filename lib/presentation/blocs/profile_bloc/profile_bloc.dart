import 'package:bloc/bloc.dart';
import 'package:histouric_web/infrastructure/inputs/email.dart';
import 'package:histouric_web/infrastructure/inputs/password.dart';

import '../../../infrastructure/inputs/nickname.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileState()) {
    on<RoleAdded>(_onRoleAdded);
    on<RoleRemoved>(_onRoleRemoved);
    on<DataChanged>(_onDataChanged);
  }

  void _onRoleAdded(RoleAdded event, Emitter<ProfileState> emit) {
    emit(state.copyWith(selectedRoles: state.selectedRoles..add(event.role)));
  }

  void _onRoleRemoved(RoleRemoved event, Emitter<ProfileState> emit) {
    emit(
        state.copyWith(selectedRoles: state.selectedRoles..remove(event.role)));
  }

  void _onDataChanged(DataChanged event, Emitter<ProfileState> emit) {
    emit(state.copyWith(
      email: Email.dirty(event.email),
      password: Password.dirty(event.password),
      nickname: Nickname.dirty(event.nickname),
      selectedRoles: event.selectedRoles.toSet(),
    ));
  }

  void updateData({
    required String email,
    required String password,
    required String nickname,
    required List<String> selectedRoles,
  }) {
    add(DataChanged(
      email: email,
      password: password,
      nickname: nickname,
      selectedRoles: selectedRoles,
    ));
  }

  void removeRole(String role) {
    add(RoleRemoved(role));
  }

  void addRole(String role) {
    add(RoleAdded(role));
  }
}
