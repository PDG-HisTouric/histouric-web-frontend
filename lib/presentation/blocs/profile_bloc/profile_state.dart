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
  final bool initializingControllers;
  late final TextEditingController emailController;
  late final TextEditingController passwordController;
  late final TextEditingController usernameController;

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
    this.initializingControllers = true,
  });

  ProfileState copyWith({
    Email? email,
    Password? password,
    Nickname? nickname,
    Set<String>? selectedRoles,
    Set<String>? allRoles,
    bool? isEditing,
    bool? isSaving,
    bool? isCreating,
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
      initializingControllers: initializingControllers,
    )
      ..emailController = emailController
      ..passwordController = passwordController
      ..usernameController = usernameController;
  }

  ProfileState configureControllers({
    String? emailText,
    String? passwordText,
    String? nicknameText,
  }) {
    return ProfileState(
      email: email,
      password: password,
      nickname: nickname,
      selectedRoles: selectedRoles,
      allRoles: allRoles,
      isEditing: isEditing,
      isSaving: isSaving,
      isCreating: isCreating,
      forEditing: forEditing,
      initializingControllers: false,
    )
      ..emailController = TextEditingController(text: emailText ?? email.value)
      ..passwordController =
          TextEditingController(text: passwordText ?? password.value)
      ..usernameController =
          TextEditingController(text: nicknameText ?? nickname.value);
  }

  // void configureControllers() {
  //   emailController = TextEditingController(text: email.value);
  // }
}
