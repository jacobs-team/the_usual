import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_template/app/core/cubit/connectivity_cubit.dart';
import 'package:flutter_template/app/core/dependencies/dependencies.dart';
import 'package:flutter_template/app/feature/coffee/coffee.dart';
import 'package:flutter_template/app/feature/coffee/widgets/floating_controls.dart';

/// {@template coffee_view}
/// A stateful widget that displays a vertical feed of coffee images.
///
/// It manages image prefetching, pagination, and user interactions like
/// favoriting and navigation.
/// {@endtemplate}
class CoffeeView extends StatefulWidget {
  /// {@macro coffee_view}
  const CoffeeView({super.key});

  @override
  State<CoffeeView> createState() => _CoffeeViewState();
}

class _CoffeeViewState extends State<CoffeeView> {
  late final CoffeeBloc coffeeBloc;
  late final PageController _pageController;
  Set<int> _cachedImageWindow = {};

  @override
  void initState() {
    coffeeBloc = getIt<CoffeeBloc>();
    coffeeBloc.add(const LoadImages(0));
    _pageController = PageController();
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingControls(pageController: _pageController),
      body: MultiBlocListener(
        listeners: [
          // Precaches images in a 10 image window
          // with the current image being the center.
          BlocListener<CoffeeBloc, CoffeeState>(
            bloc: coffeeBloc,
            listener: (context, state) {
              final newIndices = state.imageWindow.difference(
                _cachedImageWindow,
              );
              for (final i in newIndices) {
                if (i < state.images.length) {
                  unawaited(
                    precacheImage(NetworkImage(state.images[i]), context),
                  );
                }
              }
              _cachedImageWindow = state.imageWindow;
            },
            listenWhen: (previous, current) =>
                previous.imageWindow != current.imageWindow,
          ),
          // Reloads the current image (and any subsequent cache window images)
          // in the event of a reconnection.
          BlocListener<ConnectivityCubit, bool>(
            bloc: getIt<ConnectivityCubit>(),
            listenWhen: (previous, current) => current,
            listener: (context, state) {
              final page = _pageController.page?.round() ?? 0;
              final images = coffeeBloc.state.images;
              if (page >= images.length) {
                coffeeBloc.add(LoadImages(page));
              }
            },
          ),
          BlocListener<CoffeeBloc, CoffeeState>(
            bloc: coffeeBloc,
            listenWhen: (previous, current) =>
                previous.loadingState != CoffeeLoadingState.failure &&
                current.loadingState == CoffeeLoadingState.failure,
            listener: (context, state) {
              ScaffoldMessenger.of(
                context,
              ).clearSnackBars();
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage!),
                  duration: const Duration(seconds: 10),
                ),
              );
            },
          ),
        ],
        child:
            BlocSelector<CoffeeBloc, CoffeeState, (List<String>, List<String>)>(
              bloc: coffeeBloc,
              selector: (state) => (state.images, state.favorites),
              builder: (context, record) {
                final (images, favorites) = record;
                return PageView.builder(
                  scrollDirection: Axis.vertical,
                  controller: _pageController,
                  onPageChanged: (page) => coffeeBloc.add(LoadImages(page)),
                  itemBuilder: (context, index) {
                    return images.length <= index
                        ? const Center(child: CircularProgressIndicator())
                        : CoffeeImage(
                            onTap: () => coffeeBloc.add(
                              ToggleFavoriteImage(images[index]),
                            ),
                            url: images[index],
                            favorited: favorites.contains(images[index]),
                          );
                  },
                );
              },
            ),
      ),
    );
  }
}
