import 'package:formz/formz.dart';

// Define input validation errors
enum BICDescriptionError { empty, length }

// Extend FormzInput and provide the input type and error type.
class BICDescription extends FormzInput<String, BICDescriptionError> {
  // Call super.pure to represent an unmodified form input.
  const BICDescription.pure() : super.pure('');

  // Call super.dirty to represent a modified form input.
  const BICDescription.dirty(String value) : super.dirty(value);

  String? get errorMessage {
    if (isValid || isPure) return null;
    if (displayError == BICDescriptionError.empty) {
      return 'La descripción del Bien de Interés Cultural es requerida';
    }
    if (displayError == BICDescriptionError.length) {
      return 'La descripción del Bien de Interés Cultural puede tener máximo 500 caracteres';
    }
    return null;
  }

  // Override validator to handle validating a given input value.
  @override
  BICDescriptionError? validator(String value) {
    if (value.isEmpty || value.trim().isEmpty) return BICDescriptionError.empty;
    if (value.length > 500) return BICDescriptionError.length;

    return null;
  }
}
