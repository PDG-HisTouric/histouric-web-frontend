import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:formz/formz.dart';
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
    on<SelectedRolesChanged>(_onAvailableRolesChanged);
    on<ControllersInitialized>(_onControllersInitialized);
    on<SaveProcessStopped>(_onSaveProcessStopped);
    _configureControllers();
    userRepository.configureToken(authBloc.state.token!);
    mapRolesFromAuthBloc();
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

  void _onAvailableRolesChanged(
      SelectedRolesChanged event, Emitter<ProfileState> emit) {
    emit(state.copyWith(selectedRoles: event.availableRoles.toSet()));
  }

  void _onUserSaved(UserSaved event, Emitter<ProfileState> emit) {
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
      email: Email.dirty(updatedUser.email.trim()),
      password: const Password.dirty(""),
      nickname: Nickname.dirty(
        updatedUser.nickname.trim(),
      ),
      selectedRoles: mapSelectedRolesFromList(
              updatedUser.roles.map((role) => role.name).toList())
          .toSet(),
      isSaving: false,
    ));
  }

  void removeRole(String role) {
    add(RoleRemoved(role));
  }

  void addRole(String role) {
    add(RoleSelected(role));
  }

  void saveChanges() async {
    try {
      HistouricUser histouricUser = await callTheRepository();
      add(UserSaved(
        histouricUser: histouricUser,
      ));
    } catch (e) {
      add(SaveProcessStopped());
      Dialogs.showErrorDialog(
        context: context,
        content: e.toString().substring(11),
      );
    }
  }

  void _onSaveProcessStopped(
    SaveProcessStopped event,
    Emitter<ProfileState> emit,
  ) {
    emit(state.copyWith(isSaving: false));
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
    EditButtonPressed event,
    Emitter<ProfileState> emit,
  ) {
    emit(state.copyWith(isEditing: true));
  }

  void startEditing() {
    add(EditButtonPressed());
  }

  void mapRolesFromAuthBloc() {
    final initialRoles = authBloc.state.roles!;
    List<String> rolesForIcons = mapSelectedRolesFromList(initialRoles);
    for (var role in rolesForIcons) {
      addRole(role);
    }
    changeSelectedRoles(rolesForIcons);
  }

  List<String> mapSelectedRolesFromList(List<String> selectedRoles) {
    List<String> roles = [];
    if (selectedRoles.contains("ADMIN")) roles.add("Administrador");
    if (selectedRoles.contains("RESEARCHER")) roles.add("Investigador");
    if (selectedRoles.contains("TOURISM_MANAGER")) {
      roles.add("Gestor de Turismo");
    }
    return roles;
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
    mapRolesFromAuthBloc();

    emit(state.copyWith(
      nickname: Nickname.dirty(authBloc.state.nickname!),
      email: Email.dirty(authBloc.state.email!),
      password: const Password.dirty(""),
      isEditing: false,
    ));
  }

  void cancelEditing() {
    add(CancelButtonPressed());
  }

  void changeSelectedRoles(List<String> selectedRoles) {
    add(SelectedRolesChanged(selectedRoles));
  }

  void _onControllersInitialized(
      ControllersInitialized event, Emitter<ProfileState> emit) {
    emit(state.configureControllers());
  }

  void _configureControllers() {
    add(ControllersInitialized());
  }
}
