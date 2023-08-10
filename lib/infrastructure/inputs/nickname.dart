import 'package:formz/formz.dart';

// Define input validation errors
enum NicknameError { empty, length }

// Extend FormzInput and provide the input type and error type.
class Nickname extends FormzInput<String, NicknameError> {
  // Call super.pure to represent an unmodified form input.
  const Nickname.pure() : super.pure('');

  // Call super.dirty to represent a modified form input.
  const Nickname.dirty(String value) : super.dirty(value);

  String? get errorMessage {
    if (isValid || isPure) return null;
    if(displayError == NicknameError.empty) return 'El apodo es requerido';
    if(displayError == NicknameError.length) return 'El apodo puede tener máximo 50 caracteres';
    return null;
  }

  // Override validator to handle validating a given input value.
  @override
  NicknameError? validator(String value) {

    if (value.isEmpty || value.trim().isEmpty) return NicknameError.empty;
    if (value.length > 50) return NicknameError.length;

    return null;
  }
}