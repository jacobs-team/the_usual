import 'package:flutter_template/app/app.dart';

/// {@template mapping_exception}
/// An exception that indicates a problem mapping a dynamic value to
/// a data model.
///
/// This usually occurs when the JSON structure from the server does
/// not match the expected format.
/// {@endtemplate}
final class MappingException extends AppException {
  /// {@macro mapping_exception}
  const MappingException(Object error, [StackTrace? stackTrace])
    : super(
        message: 'Data mapping error:',
        error: error,
        stackTrace: stackTrace,
      );
}
