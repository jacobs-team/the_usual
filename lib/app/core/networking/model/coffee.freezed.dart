// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'coffee.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Coffee {

/// The file path or URL string for the coffee image.
@JsonKey(name: 'file') String get imageUrl;
/// Create a copy of Coffee
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CoffeeCopyWith<Coffee> get copyWith => _$CoffeeCopyWithImpl<Coffee>(this as Coffee, _$identity);

  /// Serializes this Coffee to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Coffee&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,imageUrl);

@override
String toString() {
  return 'Coffee(imageUrl: $imageUrl)';
}


}

/// @nodoc
abstract mixin class $CoffeeCopyWith<$Res>  {
  factory $CoffeeCopyWith(Coffee value, $Res Function(Coffee) _then) = _$CoffeeCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'file') String imageUrl
});




}
/// @nodoc
class _$CoffeeCopyWithImpl<$Res>
    implements $CoffeeCopyWith<$Res> {
  _$CoffeeCopyWithImpl(this._self, this._then);

  final Coffee _self;
  final $Res Function(Coffee) _then;

/// Create a copy of Coffee
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? imageUrl = null,}) {
  return _then(_self.copyWith(
imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [Coffee].
extension CoffeePatterns on Coffee {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Coffee value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Coffee() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Coffee value)  $default,){
final _that = this;
switch (_that) {
case _Coffee():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Coffee value)?  $default,){
final _that = this;
switch (_that) {
case _Coffee() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'file')  String imageUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Coffee() when $default != null:
return $default(_that.imageUrl);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'file')  String imageUrl)  $default,) {final _that = this;
switch (_that) {
case _Coffee():
return $default(_that.imageUrl);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'file')  String imageUrl)?  $default,) {final _that = this;
switch (_that) {
case _Coffee() when $default != null:
return $default(_that.imageUrl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Coffee implements Coffee {
  const _Coffee({@JsonKey(name: 'file') required this.imageUrl});
  factory _Coffee.fromJson(Map<String, dynamic> json) => _$CoffeeFromJson(json);

/// The file path or URL string for the coffee image.
@override@JsonKey(name: 'file') final  String imageUrl;

/// Create a copy of Coffee
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CoffeeCopyWith<_Coffee> get copyWith => __$CoffeeCopyWithImpl<_Coffee>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CoffeeToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Coffee&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,imageUrl);

@override
String toString() {
  return 'Coffee(imageUrl: $imageUrl)';
}


}

/// @nodoc
abstract mixin class _$CoffeeCopyWith<$Res> implements $CoffeeCopyWith<$Res> {
  factory _$CoffeeCopyWith(_Coffee value, $Res Function(_Coffee) _then) = __$CoffeeCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'file') String imageUrl
});




}
/// @nodoc
class __$CoffeeCopyWithImpl<$Res>
    implements _$CoffeeCopyWith<$Res> {
  __$CoffeeCopyWithImpl(this._self, this._then);

  final _Coffee _self;
  final $Res Function(_Coffee) _then;

/// Create a copy of Coffee
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? imageUrl = null,}) {
  return _then(_Coffee(
imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
