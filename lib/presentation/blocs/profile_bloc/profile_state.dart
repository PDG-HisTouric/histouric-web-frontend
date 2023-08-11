part of 'profile_bloc.dart';

class ProfileState {
  final Email email;
  final Password password;
  final Nickname nickname;
  final Set<String> selectedRoles;
  final bool isEditing;
  late final TextEditingController emailController;
  late final TextEditingController passwordController;
  late final TextEditingController usernameController;

  ProfileState({
    this.nickname = const Nickname.pure(),
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.selectedRoles = const {},
    this.isEditing = false,
  }) {
    emailController = TextEditingController(text: email.value);
    passwordController = TextEditingController(text: password.value);
    usernameController = TextEditingController(text: nickname.value);
  }

  ProfileState copyWith({
    Email? email,
    Password? password,
    Nickname? nickname,
    Set<String>? selectedRoles,
    bool? isEditing,
  }) {
    return ProfileState(
      email: email ?? this.email,
      password: password ?? this.password,
      nickname: nickname ?? this.nickname,
      selectedRoles: selectedRoles ?? this.selectedRoles,
      isEditing: isEditing ?? this.isEditing,
    );
  }
}
