import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:histouric_web/infrastructure/inputs/email.dart';
import 'package:histouric_web/infrastructure/inputs/password.dart';
import 'package:histouric_web/presentation/blocs/blocs.dart';

import '../../../infrastructure/inputs/nickname.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final AuthBloc authBloc;

  ProfileBloc({required this.authBloc})
      : super(ProfileState(
          email: Email.dirty(
            authBloc.state.email!,
          ),
          nickname: Nickname.dirty(
            authBloc.state.nickname!,
          ),
        )) {
    on<RoleAdded>(_onRoleAdded);
    on<RoleRemoved>(_onRoleRemoved);
    on<UserSaved>(_onUserSaved);
    on<EditButtonPressed>(_onEditButtonPressed);
    mapRoles();
  }

  void _onRoleAdded(RoleAdded event, Emitter<ProfileState> emit) {
    emit(state.copyWith(selectedRoles: state.selectedRoles..add(event.role)));
  }

  void _onRoleRemoved(RoleRemoved event, Emitter<ProfileState> emit) {
    emit(
        state.copyWith(selectedRoles: state.selectedRoles..remove(event.role)));
  }

  void _onUserSaved(UserSaved event, Emitter<ProfileState> emit) {
    emit(state.copyWith(
      email: Email.dirty(event.email ?? state.email.value),
      password: Password.dirty(event.password ?? state.password.value),
      nickname: Nickname.dirty(event.nickname ?? state.nickname.value),
      selectedRoles: event.selectedRoles?.toSet() ?? state.selectedRoles,
      isEditing: false,
    ));
  }

  void removeRole(String role) {
    add(RoleRemoved(role));
  }

  void addRole(String role) {
    add(RoleAdded(role));
  }

  void saveChanges({
    String? email,
    String? password,
    String? nickname,
    List<String>? selectedRoles,
  }) {
    add(UserSaved(
      email: email,
      password: password,
      nickname: nickname,
      selectedRoles: selectedRoles,
    ));
  }

  void _onEditButtonPressed(
      EditButtonPressed event, Emitter<ProfileState> emit) {
    emit(state.copyWith(isEditing: true));
  }

  void startEditing() {
    add(EditButtonPressed());
  }

  void mapRoles() {
    final initialRoles = authBloc.state.roles!;
    List<String> rolesForIcons = [];
    if (initialRoles.contains("ADMIN")) rolesForIcons.add("Administrador");
    if (initialRoles.contains("RESEARCHER")) rolesForIcons.add("Investigador");
    if (initialRoles.contains("TOURISM_MANAGER")) {
      rolesForIcons.add("Gestor de Turismo");
    }
    saveChanges(selectedRoles: rolesForIcons);
  }
}
