import 'package:formz/formz.dart';

// Define input validation errors
enum StockError { empty, value, format }

// Extend FormzInput and provide the input type and error type.
class Stock extends FormzInput<int, StockError> {
  const Stock.pure() : super.pure(0);

  const Stock.dirty({int value = 0}) : super.dirty(value);

  String? get errorMessage {
    if (isValid || isPure) return null;

    if (displayError == StockError.empty) return 'El campo es requerido';
    if (displayError == StockError.value) {
      return 'Tiene que ser un número mayor o ogual a cero';
    }
    if (displayError == StockError.format) {
      return 'No tiene formato de número';
    }

    return null;
  }

  // Override validator to handle validating a given input value.
  @override
  StockError? validator(int value) {
    if (value.toString().isEmpty || value.toString().trim().isEmpty) {
      return StockError.empty;
    }

    final isInteger = int.tryParse(value.toString()) != null;
    if (!isInteger) return StockError.value;

    if (value < 0) return StockError.value;

    return null;
  }
}
