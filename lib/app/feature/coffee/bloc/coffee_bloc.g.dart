// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coffee_bloc.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CoffeeState _$CoffeeStateFromJson(Map<String, dynamic> json) => _CoffeeState(
  loadingState:
      $enumDecodeNullable(_$CoffeeLoadingStateEnumMap, json['loadingState']) ??
      CoffeeLoadingState.init,
  currentImage: (json['currentImage'] as num?)?.toInt() ?? 0,
  errorMessage: json['errorMessage'] as String?,
  images:
      (json['images'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  favorites:
      (json['favorites'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  imageWindow:
      (json['imageWindow'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toSet() ??
      const {},
);

Map<String, dynamic> _$CoffeeStateToJson(_CoffeeState instance) =>
    <String, dynamic>{
      'loadingState': _$CoffeeLoadingStateEnumMap[instance.loadingState]!,
      'currentImage': instance.currentImage,
      'errorMessage': instance.errorMessage,
      'images': instance.images,
      'favorites': instance.favorites,
      'imageWindow': instance.imageWindow.toList(),
    };

const _$CoffeeLoadingStateEnumMap = {
  CoffeeLoadingState.init: 'init',
  CoffeeLoadingState.loading: 'loading',
  CoffeeLoadingState.saving: 'saving',
  CoffeeLoadingState.success: 'success',
  CoffeeLoadingState.failure: 'failure',
};
