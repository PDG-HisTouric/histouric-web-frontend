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
