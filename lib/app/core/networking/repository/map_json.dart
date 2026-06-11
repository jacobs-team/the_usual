import 'package:flutter_template/app/core/core.dart';

/// Maps a [raw] dynamic value into a single object of type [T].
///
/// Expects [raw] to be a [Map<String, dynamic>]. If the mapping fails
/// or the type cast is invalid, a [MappingException] is thrown.
T mapJson<T>(dynamic raw, T Function(Map<String, dynamic>) fromMap) {
  try {
    return fromMap(raw as Map<String, dynamic>);
  } catch (e, s) {
    throw MappingException(e, s);
  }
}

/// Maps a [raw] dynamic value into a [List] of objects of type [T].
///
/// Expects [raw] to be a [List<dynamic>]. Each element in the list is
/// transformed using the [fromJson] function. If the list cast or
/// any individual element mapping fails, a [MappingException] is thrown.
List<T> mapJsonList<T>(
  dynamic raw,
  T Function(Map<String, dynamic>) fromJson,
) {
  try {
    final list = raw as List<dynamic>;
    return list.map((e) => fromJson(e as Map<String, dynamic>)).toList();
  } catch (e, s) {
    throw MappingException(e, s);
  }
}
