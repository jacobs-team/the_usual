// coverage:ignore-file

import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

/// {@template connectivity_cubit}
/// A [Cubit] that monitors the device's network connectivity status.
///
/// It listens to the [Connectivity] stream and emits a [bool] indicating
/// whether the device has an active internet connection
/// (WiFi, Mobile, or Ethernet).
/// {@endtemplate}
@singleton
class ConnectivityCubit extends Cubit<bool> {
  /// {@macro connectivity_cubit}
  ConnectivityCubit() : super(true) {
    _subscription = Connectivity().onConnectivityChanged.listen((results) {
      final isConnected =
          results.contains(ConnectivityResult.wifi) ||
          results.contains(ConnectivityResult.mobile) ||
          results.contains(ConnectivityResult.ethernet);
      emit(isConnected);
    });
  }

  late final StreamSubscription<List<ConnectivityResult>> _subscription;

  @override
  Future<void> close() async {
    await _subscription.cancel();
    return super.close();
  }
}
