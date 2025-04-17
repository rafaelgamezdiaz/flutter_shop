import 'package:formz/formz.dart';

enum FullNameError { empty, length, format }

class FullName extends FormzInput<String, FullNameError> {
  static final RegExp fullNameRegExp = RegExp(
    r"^[a-zA-ZÀ-ÿ\u00f1\u00d1]+(?:[\s'-][a-zA-ZÀ-ÿ\u00f1\u00d1]+)*$",
  );

  // Call super.pure to represent an unmodified form input.
  const FullName.pure() : super.pure('');
  // Call super.dirty to represent a modified form input.
  const FullName.dirty({String value = ''}) : super.dirty(value);

  String? get errorMessage {
    if (isValid || isPure) return null;

    if (displayError == FullNameError.empty) {
      return 'En nombre completo es requerido';
    }

    if (displayError == FullNameError.length) {
      return 'Mínimo 3 caracteres';
    }

    if (displayError == FullNameError.format) {
      return 'No incluir números ni caracteres especiales';
    }

    return null;
  }

  @override
  FullNameError? validator(String value) {
    if (value.isEmpty || value.trim().isEmpty) return FullNameError.empty;
    if (value.length < 3) return FullNameError.length;
    if (!fullNameRegExp.hasMatch(value)) return FullNameError.format;
    return null;
  }
}
