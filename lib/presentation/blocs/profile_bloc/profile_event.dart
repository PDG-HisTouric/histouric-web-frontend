part of 'profile_bloc.dart';

abstract class ProfileEvent {}

class RoleAdded extends ProfileEvent {
  final String role;

  RoleAdded(this.role);
}

class RoleRemoved extends ProfileEvent {
  final String role;

  RoleRemoved(this.role);
}

class UserSaved extends ProfileEvent {
  final String? email;
  final String? password;
  final String? nickname;
  final List<String>? selectedRoles;

  UserSaved({
    this.email,
    this.password,
    this.nickname,
    this.selectedRoles,
  });
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
