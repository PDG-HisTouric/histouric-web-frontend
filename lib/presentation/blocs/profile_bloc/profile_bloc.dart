import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:histouric_web/domain/entities/histouric_user.dart';
import 'package:histouric_web/domain/repositories/repositories.dart';
import 'package:histouric_web/infrastructure/inputs/email.dart';
import 'package:histouric_web/infrastructure/inputs/password.dart';
import 'package:histouric_web/presentation/blocs/blocs.dart';

import '../../../config/helpers/dialogs.dart';
import '../../../domain/entities/entities.dart';
import '../../../infrastructure/inputs/nickname.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final AuthBloc authBloc;
  final UserRepository userRepository;
  final BuildContext context;
  final bool forEditing;

  ProfileBloc({
    required this.authBloc,
    required this.userRepository,
    required this.context,
    required this.forEditing,
  }) : super(ProfileState(
          forEditing: forEditing,
          email: Email.dirty(
            authBloc.state.email!,
          ),
          nickname: Nickname.dirty(
            authBloc.state.nickname!,
          ),
        )) {
    on<RoleSelected>(_onRoleSelected);
    on<RoleRemoved>(_onRoleRemoved);
    on<UserSaved>(_onUserSaved);
    on<EditButtonPressed>(_onEditButtonPressed);
    on<EmailChanged>(_onEmailChanged);
    on<PasswordChanged>(_onPasswordChanged);
    on<NicknameChanged>(_onNicknameChanged);
    on<CancelButtonPressed>(_onCancelButtonPressed);
    userRepository.configureToken(authBloc.state.token!);
    mapRolesFromInitialRoles();
  }

  void _onRoleSelected(RoleSelected event, Emitter<ProfileState> emit) {
    Set<String> newSelectedRoles = state.selectedRoles.map((role) {
      return role;
    }).toSet();
    emit(state.copyWith(selectedRoles: newSelectedRoles..add(event.role)));
  }

  void _onRoleRemoved(RoleRemoved event, Emitter<ProfileState> emit) {
    emit(
        state.copyWith(selectedRoles: state.selectedRoles..remove(event.role)));
  }

  void _onUserSaved(UserSaved event, Emitter<ProfileState> emit) async {
    emit(state.copyWith(
      isEditing: false,
      isSaving: true,
    ));

    final updatedUser = event.histouricUser;

    authBloc.changeUser(
        id: updatedUser.id,
        nickname: updatedUser.nickname,
        email: updatedUser.email,
        roles: updatedUser.roles.map((role) => role.name).toList());
    emit(state.copyWith(
      email: Email.dirty(updatedUser.email?.trim() ?? state.email.value),
      password: const Password.dirty(""),
      nickname: Nickname.dirty(
        updatedUser.nickname?.trim() ?? state.nickname.value,
      ),
      selectedRoles: updatedUser.roles.map((role) => role.name).toSet(),
      isSaving: false,
    ));
  }

  void removeRole(String role) {
    add(RoleRemoved(role));
  }

  void addRole(String role) {
    add(RoleSelected(role));
  }

  void saveChanges({
    String? email,
    String? password,
    String? nickname,
    List<String>? selectedRoles,
  }) async {
    try {
      add(UserSaved(
        histouricUser: await callTheRepository(),
      ));
    } catch (e) {
      emit(state.copyWith(isSaving: false));
      Dialogs.showErrorDialog(
        context: context,
        content: "Ocurrió un error al guardar los cambios.",
      );
    }
  }

  Future<HistouricUser> callTheRepository() async {
    bool currentUserIsAdmin = authBloc.state.roles!.contains("ADMIN");

    final user = HistouricUserWithPassword(
      id: authBloc.state.id!,
      email: state.email.value,
      password: (state.password.value.isEmpty) ? null : state.password.value,
      nickname: state.nickname.value,
      roles: currentUserIsAdmin ? mapRolesFromState() : null,
    );

    return await userRepository.updateUserById(user.id, user);
  }

  void _onEditButtonPressed(
      EditButtonPressed event, Emitter<ProfileState> emit) {
    emit(state.copyWith(isEditing: true));
  }

  void startEditing() {
    add(EditButtonPressed());
  }

  void mapRolesFromInitialRoles() {
    final initialRoles = authBloc.state.roles!;
    List<String> rolesForIcons = [];
    if (initialRoles.contains("ADMIN")) rolesForIcons.add("Administrador");
    if (initialRoles.contains("RESEARCHER")) rolesForIcons.add("Investigador");
    if (initialRoles.contains("TOURISM_MANAGER")) {
      rolesForIcons.add("Gestor de Turismo");
    }
    for (var role in rolesForIcons) {
      addRole(role);
    }
  }

  List<String> mapRolesFromState() {
    List<String> roles = [];
    if (state.selectedRoles.contains("Administrador")) roles.add("ADMIN");
    if (state.selectedRoles.contains("Investigador")) roles.add("RESEARCHER");
    if (state.selectedRoles.contains("Gestor de Turismo")) {
      roles.add("TOURISM_MANAGER");
    }
    return roles;
  }

  void _onEmailChanged(EmailChanged event, Emitter<ProfileState> emit) {
    emit(state.copyWith(email: Email.dirty(event.email)));
  }

  void _onPasswordChanged(PasswordChanged event, Emitter<ProfileState> emit) {
    emit(state.copyWith(password: Password.dirty(event.password)));
  }

  void _onNicknameChanged(NicknameChanged event, Emitter<ProfileState> emit) {
    emit(state.copyWith(nickname: Nickname.dirty(event.nickname)));
  }

  void changeEmail(String email) {
    add(EmailChanged(email));
  }

  void changePassword(String password) {
    add(PasswordChanged(password));
  }

  void changeNickname(String nickname) {
    add(NicknameChanged(nickname));
  }

  void _onCancelButtonPressed(
      CancelButtonPressed event, Emitter<ProfileState> emit) {
    emit(state.copyWith(isEditing: false));
  }

  void cancelEditing() {
    add(CancelButtonPressed());
  }
}
