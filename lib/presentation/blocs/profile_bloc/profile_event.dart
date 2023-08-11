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

class DataChanged extends ProfileEvent {
  final String email;
  final String password;
  final String nickname;
  final List<String> selectedRoles;

  DataChanged({
    required this.email,
    required this.password,
    required this.nickname,
    required this.selectedRoles,
  });
}
