part of 'profile_bloc.dart';

class ProfileState {
  final Email email;
  final Password password;
  final Nickname nickname;
  final Set<String> selectedRoles;

  ProfileState({
    this.nickname = const Nickname.pure(),
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.selectedRoles = const {},
  });

  ProfileState copyWith({
    Email? email,
    Password? password,
    Nickname? nickname,
    Set<String>? selectedRoles,
  }) {
    return ProfileState(
      email: email ?? this.email,
      password: password ?? this.password,
      nickname: nickname ?? this.nickname,
      selectedRoles: selectedRoles ?? this.selectedRoles,
    );
  }
}
