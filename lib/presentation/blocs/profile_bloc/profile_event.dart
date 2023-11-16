part of 'profile_bloc.dart';

abstract class ProfileEvent {}

class RoleSelected extends ProfileEvent {
  final String role;

  RoleSelected(this.role);
}

class RoleAdded extends ProfileEvent {
  final String role;

  RoleAdded(this.role);
}

class RoleRemoved extends ProfileEvent {
  final String role;

  RoleRemoved(this.role);
}

class SelectedRolesChanged extends ProfileEvent {
  final List<String> availableRoles;

  SelectedRolesChanged(this.availableRoles);
}

class UserSaved extends ProfileEvent {
  final HistouricUser histouricUser;
  final bool isForCreate;

  UserSaved({required this.histouricUser, this.isForCreate = false});
}

class EditButtonPressed extends ProfileEvent {}

class EmailChanged extends ProfileEvent {
  final String email;

  EmailChanged(this.email);
}

class PasswordChanged extends ProfileEvent {
  final String password;

  PasswordChanged(this.password);
}

class NicknameChanged extends ProfileEvent {
  final String nickname;

  NicknameChanged(this.nickname);
}

class CancelButtonPressed extends ProfileEvent {}

class ControllersInitialized extends ProfileEvent {
  final String? emailText;
  final String? passwordText;
  final String? nicknameText;

  ControllersInitialized({
    this.emailText,
    this.passwordText,
    this.nicknameText,
  });
}

class SaveProcessStopped extends ProfileEvent {}

class RolesChanged extends ProfileEvent {
  final List<String> roles;

  RolesChanged(this.roles);
}

class CreateButtonPressed extends ProfileEvent {}
