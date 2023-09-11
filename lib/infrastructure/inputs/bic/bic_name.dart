import 'package:formz/formz.dart';

// Define input validation errors
enum BICNameError { empty, length }

// Extend FormzInput and provide the input type and error type.
class BICName extends FormzInput<String, BICNameError> {
  // Call super.pure to represent an unmodified form input.
  const BICName.pure() : super.pure('');

  // Call super.dirty to represent a modified form input.
  const BICName.dirty(String value) : super.dirty(value);

  String? get errorMessage {
    if (isValid || isPure) return null;
    if (displayError == BICNameError.empty) {
      return 'El nombre del Bien de Interés Cultural es requerido';
    }
    if (displayError == BICNameError.length) {
      return 'El nombre del Bien de Interés Cultural puede tener máximo 50 caracteres';
    }
    return null;
  }

  // Override validator to handle validating a given input value.
  @override
  BICNameError? validator(String value) {
    if (value.isEmpty || value.trim().isEmpty) return BICNameError.empty;
    if (value.length > 50) return BICNameError.length;

    return null;
  }
}
