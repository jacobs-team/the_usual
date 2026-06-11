// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dev_tools_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DevToolsState {

 bool get isApiDebug; bool get isDarkMode;
/// Create a copy of DevToolsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DevToolsStateCopyWith<DevToolsState> get copyWith => _$DevToolsStateCopyWithImpl<DevToolsState>(this as DevToolsState, _$identity);

  /// Serializes this DevToolsState to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DevToolsState&&(identical(other.isApiDebug, isApiDebug) || other.isApiDebug == isApiDebug)&&(identical(other.isDarkMode, isDarkMode) || other.isDarkMode == isDarkMode));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,isApiDebug,isDarkMode);

@override
String toString() {
  return 'DevToolsState(isApiDebug: $isApiDebug, isDarkMode: $isDarkMode)';
}


}

/// @nodoc
abstract mixin class $DevToolsStateCopyWith<$Res>  {
  factory $DevToolsStateCopyWith(DevToolsState value, $Res Function(DevToolsState) _then) = _$DevToolsStateCopyWithImpl;
@useResult
$Res call({
 bool isApiDebug, bool isDarkMode
});




}
/// @nodoc
class _$DevToolsStateCopyWithImpl<$Res>
    implements $DevToolsStateCopyWith<$Res> {
  _$DevToolsStateCopyWithImpl(this._self, this._then);

  final DevToolsState _self;
  final $Res Function(DevToolsState) _then;

/// Create a copy of DevToolsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isApiDebug = null,Object? isDarkMode = null,}) {
  return _then(_self.copyWith(
isApiDebug: null == isApiDebug ? _self.isApiDebug : isApiDebug // ignore: cast_nullable_to_non_nullable
as bool,isDarkMode: null == isDarkMode ? _self.isDarkMode : isDarkMode // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [DevToolsState].
extension DevToolsStatePatterns on DevToolsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DevToolsState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DevToolsState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DevToolsState value)  $default,){
final _that = this;
switch (_that) {
case _DevToolsState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DevToolsState value)?  $default,){
final _that = this;
switch (_that) {
case _DevToolsState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isApiDebug,  bool isDarkMode)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DevToolsState() when $default != null:
return $default(_that.isApiDebug,_that.isDarkMode);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isApiDebug,  bool isDarkMode)  $default,) {final _that = this;
switch (_that) {
case _DevToolsState():
return $default(_that.isApiDebug,_that.isDarkMode);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isApiDebug,  bool isDarkMode)?  $default,) {final _that = this;
switch (_that) {
case _DevToolsState() when $default != null:
return $default(_that.isApiDebug,_that.isDarkMode);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DevToolsState extends DevToolsState {
  const _DevToolsState({this.isApiDebug = true, this.isDarkMode = false}): super._();
  factory _DevToolsState.fromJson(Map<String, dynamic> json) => _$DevToolsStateFromJson(json);

@override@JsonKey() final  bool isApiDebug;
@override@JsonKey() final  bool isDarkMode;

/// Create a copy of DevToolsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DevToolsStateCopyWith<_DevToolsState> get copyWith => __$DevToolsStateCopyWithImpl<_DevToolsState>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DevToolsStateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DevToolsState&&(identical(other.isApiDebug, isApiDebug) || other.isApiDebug == isApiDebug)&&(identical(other.isDarkMode, isDarkMode) || other.isDarkMode == isDarkMode));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,isApiDebug,isDarkMode);

@override
String toString() {
  return 'DevToolsState(isApiDebug: $isApiDebug, isDarkMode: $isDarkMode)';
}


}

/// @nodoc
abstract mixin class _$DevToolsStateCopyWith<$Res> implements $DevToolsStateCopyWith<$Res> {
  factory _$DevToolsStateCopyWith(_DevToolsState value, $Res Function(_DevToolsState) _then) = __$DevToolsStateCopyWithImpl;
@override @useResult
$Res call({
 bool isApiDebug, bool isDarkMode
});




}
/// @nodoc
class __$DevToolsStateCopyWithImpl<$Res>
    implements _$DevToolsStateCopyWith<$Res> {
  __$DevToolsStateCopyWithImpl(this._self, this._then);

  final _DevToolsState _self;
  final $Res Function(_DevToolsState) _then;

/// Create a copy of DevToolsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isApiDebug = null,Object? isDarkMode = null,}) {
  return _then(_DevToolsState(
isApiDebug: null == isApiDebug ? _self.isApiDebug : isApiDebug // ignore: cast_nullable_to_non_nullable
as bool,isDarkMode: null == isDarkMode ? _self.isDarkMode : isDarkMode // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
