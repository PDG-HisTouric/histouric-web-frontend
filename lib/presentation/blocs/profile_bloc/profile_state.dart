part of 'profile_bloc.dart';

enum ProfilePurpose {
  editMyProfile,
  viewMyProfile,
  editUserFromAdmin,
  createUserFromAdmin
}

class ProfileState {
  final Email email;
  final Password password;
  final Nickname nickname;
  final Set<String> allRoles;
  final Set<String> selectedRoles;
  final bool isSaving;
  final ProfilePurpose profilePurpose;
  final bool initializingControllers;
  late final TextEditingController emailController;
  late final TextEditingController passwordController;
  late final TextEditingController usernameController;

  ProfileState({
    this.nickname = const Nickname.pure(),
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.selectedRoles = const {},
    this.isSaving = false,
    this.allRoles = const {},
    required this.profilePurpose,
    this.initializingControllers = true,
  });

  ProfileState copyWith({
    Email? email,
    Password? password,
    Nickname? nickname,
    Set<String>? selectedRoles,
    Set<String>? allRoles,
    bool? isSaving,
    ProfilePurpose? profilePurpose,
  }) {
    return ProfileState(
      email: email ?? this.email,
      password: password ?? this.password,
      nickname: nickname ?? this.nickname,
      selectedRoles: selectedRoles ?? this.selectedRoles,
      allRoles: allRoles ?? this.allRoles,
      isSaving: isSaving ?? this.isSaving,
      profilePurpose: profilePurpose ?? this.profilePurpose,
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
      isSaving: isSaving,
      profilePurpose: profilePurpose,
      initializingControllers: false,
    )
      ..emailController = TextEditingController(text: emailText ?? email.value)
      ..passwordController = TextEditingController(
        text: passwordText ?? password.value,
      )
      ..usernameController = TextEditingController(
        text: nicknameText ?? nickname.value,
      );
  }
}
