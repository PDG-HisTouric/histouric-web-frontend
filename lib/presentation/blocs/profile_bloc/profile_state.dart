part of 'profile_bloc.dart';

class ProfileState {
  final Email email;
  final Password password;
  final Nickname nickname;
  final Set<String> allRoles;
  final Set<String> selectedRoles;
  final bool isEditing;
  final bool isCreating;
  final bool isSaving;
  final bool forEditing;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController usernameController;

  ProfileState({
    this.nickname = const Nickname.pure(),
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.selectedRoles = const {},
    this.isEditing = false,
    this.isSaving = false,
    this.isCreating = false,
    this.allRoles = const {},
    required this.forEditing,
  })  : emailController = TextEditingController(text: email.value),
        passwordController = TextEditingController(text: password.value),
        usernameController = TextEditingController(text: nickname.value) {
    emailController.selection = TextSelection.collapsed(
      offset: email.value.length,
    );
    passwordController.selection = TextSelection.collapsed(
      offset: password.value.length,
    );
    usernameController.selection = TextSelection.collapsed(
      offset: nickname.value.length,
    );
  }

  ProfileState copyWith({
    Email? email,
    Password? password,
    Nickname? nickname,
    Set<String>? selectedRoles,
    Set<String>? allRoles,
    bool? isEditing,
    bool? isSaving,
    bool? isCreating,
    TextEditingController? emailController,
    TextEditingController? passwordController,
    TextEditingController? usernameController,
  }) {
    return ProfileState(
      email: email ?? this.email,
      password: password ?? this.password,
      nickname: nickname ?? this.nickname,
      selectedRoles: selectedRoles ?? this.selectedRoles,
      allRoles: allRoles ?? this.allRoles,
      isEditing: isEditing ?? this.isEditing,
      isSaving: isSaving ?? this.isSaving,
      isCreating: isCreating ?? this.isCreating,
      forEditing: forEditing,
    );
  }
}
