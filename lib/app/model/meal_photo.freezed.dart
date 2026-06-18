// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'meal_photo.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MealPhoto {

 Uint8List get bytes; String get mediaType;
/// Create a copy of MealPhoto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MealPhotoCopyWith<MealPhoto> get copyWith => _$MealPhotoCopyWithImpl<MealPhoto>(this as MealPhoto, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MealPhoto&&const DeepCollectionEquality().equals(other.bytes, bytes)&&(identical(other.mediaType, mediaType) || other.mediaType == mediaType));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(bytes),mediaType);

@override
String toString() {
  return 'MealPhoto(bytes: $bytes, mediaType: $mediaType)';
}


}

/// @nodoc
abstract mixin class $MealPhotoCopyWith<$Res>  {
  factory $MealPhotoCopyWith(MealPhoto value, $Res Function(MealPhoto) _then) = _$MealPhotoCopyWithImpl;
@useResult
$Res call({
 Uint8List bytes, String mediaType
});




}
/// @nodoc
class _$MealPhotoCopyWithImpl<$Res>
    implements $MealPhotoCopyWith<$Res> {
  _$MealPhotoCopyWithImpl(this._self, this._then);

  final MealPhoto _self;
  final $Res Function(MealPhoto) _then;

/// Create a copy of MealPhoto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? bytes = null,Object? mediaType = null,}) {
  return _then(_self.copyWith(
bytes: null == bytes ? _self.bytes : bytes // ignore: cast_nullable_to_non_nullable
as Uint8List,mediaType: null == mediaType ? _self.mediaType : mediaType // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [MealPhoto].
extension MealPhotoPatterns on MealPhoto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MealPhoto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MealPhoto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MealPhoto value)  $default,){
final _that = this;
switch (_that) {
case _MealPhoto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MealPhoto value)?  $default,){
final _that = this;
switch (_that) {
case _MealPhoto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Uint8List bytes,  String mediaType)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MealPhoto() when $default != null:
return $default(_that.bytes,_that.mediaType);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Uint8List bytes,  String mediaType)  $default,) {final _that = this;
switch (_that) {
case _MealPhoto():
return $default(_that.bytes,_that.mediaType);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Uint8List bytes,  String mediaType)?  $default,) {final _that = this;
switch (_that) {
case _MealPhoto() when $default != null:
return $default(_that.bytes,_that.mediaType);case _:
  return null;

}
}

}

/// @nodoc


class _MealPhoto implements MealPhoto {
  const _MealPhoto({required this.bytes, this.mediaType = 'image/jpeg'});
  

@override final  Uint8List bytes;
@override@JsonKey() final  String mediaType;

/// Create a copy of MealPhoto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MealPhotoCopyWith<_MealPhoto> get copyWith => __$MealPhotoCopyWithImpl<_MealPhoto>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MealPhoto&&const DeepCollectionEquality().equals(other.bytes, bytes)&&(identical(other.mediaType, mediaType) || other.mediaType == mediaType));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(bytes),mediaType);

@override
String toString() {
  return 'MealPhoto(bytes: $bytes, mediaType: $mediaType)';
}


}

/// @nodoc
abstract mixin class _$MealPhotoCopyWith<$Res> implements $MealPhotoCopyWith<$Res> {
  factory _$MealPhotoCopyWith(_MealPhoto value, $Res Function(_MealPhoto) _then) = __$MealPhotoCopyWithImpl;
@override @useResult
$Res call({
 Uint8List bytes, String mediaType
});




}
/// @nodoc
class __$MealPhotoCopyWithImpl<$Res>
    implements _$MealPhotoCopyWith<$Res> {
  __$MealPhotoCopyWithImpl(this._self, this._then);

  final _MealPhoto _self;
  final $Res Function(_MealPhoto) _then;

/// Create a copy of MealPhoto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? bytes = null,Object? mediaType = null,}) {
  return _then(_MealPhoto(
bytes: null == bytes ? _self.bytes : bytes // ignore: cast_nullable_to_non_nullable
as Uint8List,mediaType: null == mediaType ? _self.mediaType : mediaType // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
