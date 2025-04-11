// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Memverse';

  @override
  String get referenceTestAppBarTitle => 'Reference Test';

  @override
  String get referenceTest => 'Prueba de Referencias';

  @override
  String get question => 'Pregunta';

  @override
  String get reference => 'Referencia:';

  @override
  String get enterReferenceHint => 'Ingrese referencia (ej., Génesis 1:1)';

  @override
  String get referenceFormat => 'Formato: Libro Capítulo:Versículo';

  @override
  String get submit => 'Enviar';

  @override
  String get correct => '¡Correcto!';

  @override
  String get pleaseEnterReference => 'Por favor ingrese una referencia.';

  @override
  String notQuiteRight(Object reference) {
    return 'No es del todo correcto. La referencia correcta es $reference.';
  }

  @override
  String correctReferenceIdentification(Object reference) {
    return '¡Buen trabajo! Identificaste correctamente este versículo como $reference.';
  }

  @override
  String bookAndChapterCorrectButVerseIncorrect(Object reference) {
    return 'El libro y capítulo son correctos, pero el versículo es incorrecto. La referencia correcta es $reference.';
  }

  @override
  String bookCorrectButChapterIncorrect(Object reference) {
    return 'El libro es correcto, pero el capítulo es incorrecto. La referencia correcta es $reference.';
  }

  @override
  String bookIncorrect(Object reference) {
    return 'El libro que ingresaste es incorrecto. La referencia correcta es $reference.';
  }

  @override
  String get referenceRecall => 'Recuerdo de Referencias';

  @override
  String get referencesDueToday => 'Referencias por Revisar Hoy';

  @override
  String get priorQuestions => 'Preguntas Anteriores';

  @override
  String get noPreviousQuestions => 'Aún no hay preguntas anteriores';

  @override
  String get referenceCannotBeEmpty => 'La referencia no puede estar vacía';

  @override
  String get invalidBookName => 'Nombre de libro inválido';

  @override
  String get formatShouldBeBookChapterVerse => 'El formato debe ser \"Libro Capítulo:Versículo\"';

  @override
  String get password => 'Contraseña';

  @override
  String get showPassword => 'Mostrar contraseña';

  @override
  String get hidePassword => 'Ocultar contraseña';

  @override
  String get pleaseEnterYourPassword => 'Por favor ingrese su contraseña';

  @override
  String get username => 'Nombre de usuario';

  @override
  String get pleaseEnterYourUsername => 'Por favor ingrese su nombre de usuario';
}
