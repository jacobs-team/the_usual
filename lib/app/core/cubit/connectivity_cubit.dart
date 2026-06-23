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
    _subscription = _connectivity.onConnectivityChanged.listen(_onResults);
    // [onConnectivityChanged] only fires on change, so seed from the current
    // state too, otherwise the initial value is a guess until the first change.
    unawaited(_connectivity.checkConnectivity().then(_onResults));
  }

  final Connectivity _connectivity = Connectivity();
  late final StreamSubscription<List<ConnectivityResult>> _subscription;

  void _onResults(List<ConnectivityResult> results) {
    // Per connectivity_plus, the only disconnected state is [none]. A VPN and
    // the iOS simulator report [other], which is still connected, so a
    // wifi/mobile/ethernet whitelist wrongly reads those as offline.
    emit(results.isNotEmpty && !results.contains(ConnectivityResult.none));
  }

  @override
  Future<void> close() async {
    await _subscription.cancel();
    return super.close();
  }
}
