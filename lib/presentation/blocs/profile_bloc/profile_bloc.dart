import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../config/helpers/dialogs.dart';
import '../../../domain/domain.dart';
import '../../../infrastructure/infrastructure.dart';
import '../blocs.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final AuthBloc authBloc;
  final UserRepository userRepository;
  final BuildContext context;
  final ProfilePurpose profilePurpose;
  final UsersTableBloc? usersTableBloc;

  ProfileBloc({
    required this.authBloc,
    required this.userRepository,
    required this.context,
    required this.profilePurpose,
    this.usersTableBloc,
  }) : super(ProfileState(
          profilePurpose: profilePurpose,
          email: Email.dirty(authBloc.state.email!),
          nickname: Nickname.dirty(authBloc.state.nickname!),
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
    on<RolesChanged>(_onRolesChanged);
    on<CreateButtonPressed>(_onCreateButtonPressed);
    _configureControllers();
    userRepository.configureToken(authBloc.state.token!);
    _mapRolesFromAuthBloc();
  }

  void createUserFromAdmin() {
    add(CreateButtonPressed());
  }

  void _onCreateButtonPressed(
    CreateButtonPressed event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      emit(state.copyWith(isSaving: true));

      HistouricUser histouricUser = await _createUser();

      add(UserSaved(histouricUser: histouricUser));
    } catch (e) {
      add(SaveProcessStopped());

      Dialogs.showErrorDialog(
        context: context,
        content: e.toString().substring(11),
      );
    }
  }

  Future<HistouricUser> _createUser() async {
    final user = HistouricUserWithPassword(
      email: state.email.value,
      password: state.password.value,
      nickname: state.nickname.value,
      roles: _mapRolesFromState(),
    );

    return await userRepository.registerUser(user);
  }

  void _onRoleSelected(RoleSelected event, Emitter<ProfileState> emit) {
    Set<String> newSelectedRoles = state.selectedRoles.map((role) {
      return role;
    }).toSet();

    emit(state.copyWith(selectedRoles: newSelectedRoles..add(event.role)));
  }

  void _onRoleRemoved(RoleRemoved event, Emitter<ProfileState> emit) {
    emit(state.copyWith(
      selectedRoles: state.selectedRoles..remove(event.role),
    ));
  }

  void _onAvailableRolesChanged(
    SelectedRolesChanged event,
    Emitter<ProfileState> emit,
  ) {
    emit(state.copyWith(selectedRoles: event.availableRoles.toSet()));
  }

  void _onUserSaved(UserSaved event, Emitter<ProfileState> emit) {
    emit(state.copyWith(
      profilePurpose: ProfilePurpose.viewMyProfile,
      isSaving: true,
    ));

    final updatedUser = event.histouricUser;

    authBloc.changeUser(
      id: updatedUser.id,
      nickname: updatedUser.nickname,
      email: updatedUser.email,
      roles: updatedUser.roles.map((role) => role.name).toList(),
      token: updatedUser.token,
    );

    emit(state.copyWith(
      email: Email.dirty(updatedUser.email.trim()),
      password: const Password.dirty(""),
      nickname: Nickname.dirty(updatedUser.nickname.trim()),
      selectedRoles: _mapSelectedRolesFromList(
        updatedUser.roles.map((role) => role.name).toList(),
      ).toSet(),
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
      HistouricUser histouricUser = await _updateUserById();
      add(UserSaved(histouricUser: histouricUser));
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

  Future<HistouricUser> _updateUserById() async {
    final user = HistouricUserWithPassword(
      id: authBloc.state.id!,
      email: (state.email.value.isEmpty) ? null : state.email.value,
      password: (state.password.value.isEmpty) ? null : state.password.value,
      nickname: (state.nickname.value.isEmpty) ? null : state.nickname.value,
      roles: _mapRolesFromState(),
    );

    return await userRepository.updateUserById(user.id!, user);
  }

  void _onEditButtonPressed(
    EditButtonPressed event,
    Emitter<ProfileState> emit,
  ) {
    emit(state.copyWith(profilePurpose: ProfilePurpose.editMyProfile));

    add(ControllersInitialized(
      emailText: authBloc.state.email!,
      nicknameText: authBloc.state.nickname!,
      passwordText: "",
    ));
  }

  void startEditing() {
    add(EditButtonPressed());
  }

  void _mapRolesFromAuthBloc() {
    final initialRoles = authBloc.state.roles!;

    List<String> rolesForIcons = _mapSelectedRolesFromList(initialRoles);

    for (var role in rolesForIcons) {
      addRole(role);
    }

    _changeSelectedRoles(rolesForIcons);
  }

  List<String> _mapSelectedRolesFromList(List<String> selectedRoles) {
    List<String> roles = [];

    if (selectedRoles.contains("ADMIN")) roles.add("Administrador");
    if (selectedRoles.contains("RESEARCHER")) roles.add("Investigador");
    if (selectedRoles.contains("TOURISM_MANAGER")) {
      roles.add("Gestor de Turismo");
    }

    return roles;
  }

  List<String>? _mapRolesFromState() {
    List<String> roles = [];

    if (!authBloc.state.roles!.contains("ADMIN") &&
        state.profilePurpose != ProfilePurpose.editUserFromAdmin &&
        state.profilePurpose != ProfilePurpose.createUserFromAdmin) {
      return null;
    }

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
    CancelButtonPressed event,
    Emitter<ProfileState> emit,
  ) {
    _mapRolesFromAuthBloc();

    emit(state.copyWith(
      nickname: Nickname.dirty(authBloc.state.nickname!),
      email: Email.dirty(authBloc.state.email!),
      password: const Password.dirty(""),
      profilePurpose: ProfilePurpose.viewMyProfile,
    ));
  }

  void cancelEditing() {
    add(CancelButtonPressed());
  }

  void _changeSelectedRoles(List<String> selectedRoles) {
    add(SelectedRolesChanged(selectedRoles));
  }

  void _onControllersInitialized(
    ControllersInitialized event,
    Emitter<ProfileState> emit,
  ) {
    emit(state.configureControllers(
      emailText: event.emailText,
      passwordText: event.passwordText,
      nicknameText: event.nicknameText,
    ));
  }

  void _configureControllers({
    emailText,
    passwordText,
    nicknameText,
  }) {
    add(ControllersInitialized(
      emailText: emailText,
      passwordText: passwordText,
      nicknameText: nicknameText,
    ));
  }

  void _onRolesChanged(RolesChanged event, Emitter<ProfileState> emit) {
    emit(state.copyWith(
      email: const Email.dirty(""),
      password: const Password.dirty(""),
      nickname: const Nickname.dirty(""),
    ));

    saveChanges();
    usersTableBloc?.fetchUsers();
  }
}
