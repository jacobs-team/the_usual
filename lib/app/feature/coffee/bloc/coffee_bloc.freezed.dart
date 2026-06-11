// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'coffee_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CoffeeEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CoffeeEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CoffeeEvent()';
}


}

/// @nodoc
class $CoffeeEventCopyWith<$Res>  {
$CoffeeEventCopyWith(CoffeeEvent _, $Res Function(CoffeeEvent) __);
}


/// Adds pattern-matching-related methods to [CoffeeEvent].
extension CoffeeEventPatterns on CoffeeEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( LoadImages value)?  loadImages,TResult Function( ToggleFavoriteImage value)?  toggleFavoriteImage,TResult Function( ClearFeed value)?  clearFeed,required TResult orElse(),}){
final _that = this;
switch (_that) {
case LoadImages() when loadImages != null:
return loadImages(_that);case ToggleFavoriteImage() when toggleFavoriteImage != null:
return toggleFavoriteImage(_that);case ClearFeed() when clearFeed != null:
return clearFeed(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( LoadImages value)  loadImages,required TResult Function( ToggleFavoriteImage value)  toggleFavoriteImage,required TResult Function( ClearFeed value)  clearFeed,}){
final _that = this;
switch (_that) {
case LoadImages():
return loadImages(_that);case ToggleFavoriteImage():
return toggleFavoriteImage(_that);case ClearFeed():
return clearFeed(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( LoadImages value)?  loadImages,TResult? Function( ToggleFavoriteImage value)?  toggleFavoriteImage,TResult? Function( ClearFeed value)?  clearFeed,}){
final _that = this;
switch (_that) {
case LoadImages() when loadImages != null:
return loadImages(_that);case ToggleFavoriteImage() when toggleFavoriteImage != null:
return toggleFavoriteImage(_that);case ClearFeed() when clearFeed != null:
return clearFeed(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( int currentImage)?  loadImages,TResult Function( String url)?  toggleFavoriteImage,TResult Function()?  clearFeed,required TResult orElse(),}) {final _that = this;
switch (_that) {
case LoadImages() when loadImages != null:
return loadImages(_that.currentImage);case ToggleFavoriteImage() when toggleFavoriteImage != null:
return toggleFavoriteImage(_that.url);case ClearFeed() when clearFeed != null:
return clearFeed();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( int currentImage)  loadImages,required TResult Function( String url)  toggleFavoriteImage,required TResult Function()  clearFeed,}) {final _that = this;
switch (_that) {
case LoadImages():
return loadImages(_that.currentImage);case ToggleFavoriteImage():
return toggleFavoriteImage(_that.url);case ClearFeed():
return clearFeed();case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( int currentImage)?  loadImages,TResult? Function( String url)?  toggleFavoriteImage,TResult? Function()?  clearFeed,}) {final _that = this;
switch (_that) {
case LoadImages() when loadImages != null:
return loadImages(_that.currentImage);case ToggleFavoriteImage() when toggleFavoriteImage != null:
return toggleFavoriteImage(_that.url);case ClearFeed() when clearFeed != null:
return clearFeed();case _:
  return null;

}
}

}

/// @nodoc


class LoadImages implements CoffeeEvent {
  const LoadImages(this.currentImage);
  

 final  int currentImage;

/// Create a copy of CoffeeEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LoadImagesCopyWith<LoadImages> get copyWith => _$LoadImagesCopyWithImpl<LoadImages>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoadImages&&(identical(other.currentImage, currentImage) || other.currentImage == currentImage));
}


@override
int get hashCode => Object.hash(runtimeType,currentImage);

@override
String toString() {
  return 'CoffeeEvent.loadImages(currentImage: $currentImage)';
}


}

/// @nodoc
abstract mixin class $LoadImagesCopyWith<$Res> implements $CoffeeEventCopyWith<$Res> {
  factory $LoadImagesCopyWith(LoadImages value, $Res Function(LoadImages) _then) = _$LoadImagesCopyWithImpl;
@useResult
$Res call({
 int currentImage
});




}
/// @nodoc
class _$LoadImagesCopyWithImpl<$Res>
    implements $LoadImagesCopyWith<$Res> {
  _$LoadImagesCopyWithImpl(this._self, this._then);

  final LoadImages _self;
  final $Res Function(LoadImages) _then;

/// Create a copy of CoffeeEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? currentImage = null,}) {
  return _then(LoadImages(
null == currentImage ? _self.currentImage : currentImage // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class ToggleFavoriteImage implements CoffeeEvent {
  const ToggleFavoriteImage(this.url);
  

 final  String url;

/// Create a copy of CoffeeEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ToggleFavoriteImageCopyWith<ToggleFavoriteImage> get copyWith => _$ToggleFavoriteImageCopyWithImpl<ToggleFavoriteImage>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ToggleFavoriteImage&&(identical(other.url, url) || other.url == url));
}


@override
int get hashCode => Object.hash(runtimeType,url);

@override
String toString() {
  return 'CoffeeEvent.toggleFavoriteImage(url: $url)';
}


}

/// @nodoc
abstract mixin class $ToggleFavoriteImageCopyWith<$Res> implements $CoffeeEventCopyWith<$Res> {
  factory $ToggleFavoriteImageCopyWith(ToggleFavoriteImage value, $Res Function(ToggleFavoriteImage) _then) = _$ToggleFavoriteImageCopyWithImpl;
@useResult
$Res call({
 String url
});




}
/// @nodoc
class _$ToggleFavoriteImageCopyWithImpl<$Res>
    implements $ToggleFavoriteImageCopyWith<$Res> {
  _$ToggleFavoriteImageCopyWithImpl(this._self, this._then);

  final ToggleFavoriteImage _self;
  final $Res Function(ToggleFavoriteImage) _then;

/// Create a copy of CoffeeEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? url = null,}) {
  return _then(ToggleFavoriteImage(
null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class ClearFeed implements CoffeeEvent {
  const ClearFeed();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ClearFeed);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CoffeeEvent.clearFeed()';
}


}





/// @nodoc
mixin _$CoffeeState {

 CoffeeLoadingState get loadingState; int get currentImage; String? get errorMessage; List<String> get images; List<String> get favorites;/// A set of indices representing the active sliding window of
/// precached images.
 Set<int> get imageWindow;
/// Create a copy of CoffeeState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CoffeeStateCopyWith<CoffeeState> get copyWith => _$CoffeeStateCopyWithImpl<CoffeeState>(this as CoffeeState, _$identity);

  /// Serializes this CoffeeState to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CoffeeState&&(identical(other.loadingState, loadingState) || other.loadingState == loadingState)&&(identical(other.currentImage, currentImage) || other.currentImage == currentImage)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&const DeepCollectionEquality().equals(other.images, images)&&const DeepCollectionEquality().equals(other.favorites, favorites)&&const DeepCollectionEquality().equals(other.imageWindow, imageWindow));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,loadingState,currentImage,errorMessage,const DeepCollectionEquality().hash(images),const DeepCollectionEquality().hash(favorites),const DeepCollectionEquality().hash(imageWindow));

@override
String toString() {
  return 'CoffeeState(loadingState: $loadingState, currentImage: $currentImage, errorMessage: $errorMessage, images: $images, favorites: $favorites, imageWindow: $imageWindow)';
}


}

/// @nodoc
abstract mixin class $CoffeeStateCopyWith<$Res>  {
  factory $CoffeeStateCopyWith(CoffeeState value, $Res Function(CoffeeState) _then) = _$CoffeeStateCopyWithImpl;
@useResult
$Res call({
 CoffeeLoadingState loadingState, int currentImage, String? errorMessage, List<String> images, List<String> favorites, Set<int> imageWindow
});




}
/// @nodoc
class _$CoffeeStateCopyWithImpl<$Res>
    implements $CoffeeStateCopyWith<$Res> {
  _$CoffeeStateCopyWithImpl(this._self, this._then);

  final CoffeeState _self;
  final $Res Function(CoffeeState) _then;

/// Create a copy of CoffeeState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? loadingState = null,Object? currentImage = null,Object? errorMessage = freezed,Object? images = null,Object? favorites = null,Object? imageWindow = null,}) {
  return _then(_self.copyWith(
loadingState: null == loadingState ? _self.loadingState : loadingState // ignore: cast_nullable_to_non_nullable
as CoffeeLoadingState,currentImage: null == currentImage ? _self.currentImage : currentImage // ignore: cast_nullable_to_non_nullable
as int,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,images: null == images ? _self.images : images // ignore: cast_nullable_to_non_nullable
as List<String>,favorites: null == favorites ? _self.favorites : favorites // ignore: cast_nullable_to_non_nullable
as List<String>,imageWindow: null == imageWindow ? _self.imageWindow : imageWindow // ignore: cast_nullable_to_non_nullable
as Set<int>,
  ));
}

}


/// Adds pattern-matching-related methods to [CoffeeState].
extension CoffeeStatePatterns on CoffeeState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CoffeeState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CoffeeState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CoffeeState value)  $default,){
final _that = this;
switch (_that) {
case _CoffeeState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CoffeeState value)?  $default,){
final _that = this;
switch (_that) {
case _CoffeeState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( CoffeeLoadingState loadingState,  int currentImage,  String? errorMessage,  List<String> images,  List<String> favorites,  Set<int> imageWindow)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CoffeeState() when $default != null:
return $default(_that.loadingState,_that.currentImage,_that.errorMessage,_that.images,_that.favorites,_that.imageWindow);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( CoffeeLoadingState loadingState,  int currentImage,  String? errorMessage,  List<String> images,  List<String> favorites,  Set<int> imageWindow)  $default,) {final _that = this;
switch (_that) {
case _CoffeeState():
return $default(_that.loadingState,_that.currentImage,_that.errorMessage,_that.images,_that.favorites,_that.imageWindow);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( CoffeeLoadingState loadingState,  int currentImage,  String? errorMessage,  List<String> images,  List<String> favorites,  Set<int> imageWindow)?  $default,) {final _that = this;
switch (_that) {
case _CoffeeState() when $default != null:
return $default(_that.loadingState,_that.currentImage,_that.errorMessage,_that.images,_that.favorites,_that.imageWindow);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CoffeeState implements CoffeeState {
  const _CoffeeState({this.loadingState = CoffeeLoadingState.init, this.currentImage = 0, this.errorMessage, final  List<String> images = const [], final  List<String> favorites = const [], final  Set<int> imageWindow = const {}}): _images = images,_favorites = favorites,_imageWindow = imageWindow;
  factory _CoffeeState.fromJson(Map<String, dynamic> json) => _$CoffeeStateFromJson(json);

@override@JsonKey() final  CoffeeLoadingState loadingState;
@override@JsonKey() final  int currentImage;
@override final  String? errorMessage;
 final  List<String> _images;
@override@JsonKey() List<String> get images {
  if (_images is EqualUnmodifiableListView) return _images;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_images);
}

 final  List<String> _favorites;
@override@JsonKey() List<String> get favorites {
  if (_favorites is EqualUnmodifiableListView) return _favorites;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_favorites);
}

/// A set of indices representing the active sliding window of
/// precached images.
 final  Set<int> _imageWindow;
/// A set of indices representing the active sliding window of
/// precached images.
@override@JsonKey() Set<int> get imageWindow {
  if (_imageWindow is EqualUnmodifiableSetView) return _imageWindow;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_imageWindow);
}


/// Create a copy of CoffeeState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CoffeeStateCopyWith<_CoffeeState> get copyWith => __$CoffeeStateCopyWithImpl<_CoffeeState>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CoffeeStateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CoffeeState&&(identical(other.loadingState, loadingState) || other.loadingState == loadingState)&&(identical(other.currentImage, currentImage) || other.currentImage == currentImage)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&const DeepCollectionEquality().equals(other._images, _images)&&const DeepCollectionEquality().equals(other._favorites, _favorites)&&const DeepCollectionEquality().equals(other._imageWindow, _imageWindow));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,loadingState,currentImage,errorMessage,const DeepCollectionEquality().hash(_images),const DeepCollectionEquality().hash(_favorites),const DeepCollectionEquality().hash(_imageWindow));

@override
String toString() {
  return 'CoffeeState(loadingState: $loadingState, currentImage: $currentImage, errorMessage: $errorMessage, images: $images, favorites: $favorites, imageWindow: $imageWindow)';
}


}

/// @nodoc
abstract mixin class _$CoffeeStateCopyWith<$Res> implements $CoffeeStateCopyWith<$Res> {
  factory _$CoffeeStateCopyWith(_CoffeeState value, $Res Function(_CoffeeState) _then) = __$CoffeeStateCopyWithImpl;
@override @useResult
$Res call({
 CoffeeLoadingState loadingState, int currentImage, String? errorMessage, List<String> images, List<String> favorites, Set<int> imageWindow
});




}
/// @nodoc
class __$CoffeeStateCopyWithImpl<$Res>
    implements _$CoffeeStateCopyWith<$Res> {
  __$CoffeeStateCopyWithImpl(this._self, this._then);

  final _CoffeeState _self;
  final $Res Function(_CoffeeState) _then;

/// Create a copy of CoffeeState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? loadingState = null,Object? currentImage = null,Object? errorMessage = freezed,Object? images = null,Object? favorites = null,Object? imageWindow = null,}) {
  return _then(_CoffeeState(
loadingState: null == loadingState ? _self.loadingState : loadingState // ignore: cast_nullable_to_non_nullable
as CoffeeLoadingState,currentImage: null == currentImage ? _self.currentImage : currentImage // ignore: cast_nullable_to_non_nullable
as int,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,images: null == images ? _self._images : images // ignore: cast_nullable_to_non_nullable
as List<String>,favorites: null == favorites ? _self._favorites : favorites // ignore: cast_nullable_to_non_nullable
as List<String>,imageWindow: null == imageWindow ? _self._imageWindow : imageWindow // ignore: cast_nullable_to_non_nullable
as Set<int>,
  ));
}


}

// dart format on
