import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_template/app/core/core.dart';
import 'package:flutter_template/app/core/dependencies/dependencies.dart';
import 'package:flutter_template/app/feature/coffee/bloc/coffee_bloc.dart';
import 'package:flutter_template/l10n/l10n.dart';

/// {@template expanded_image}
/// A view that displays a full-screen, interactive gallery of favorited images.
///
/// It uses a [PageView] to navigate through the user's favorites, retrieving
/// cached files via [FileCacheService] and enabling zoom/pan through [InteractiveViewer].
/// {@endtemplate}
class ExpandedImage extends StatefulWidget {
  /// {@macro expanded_image}
  const ExpandedImage(this.initialImage, {super.key});

  /// The URL of the image that should be displayed first when the view opens.
  final String initialImage;

  @override
  State<ExpandedImage> createState() => _ExpandedImageState();
}

class _ExpandedImageState extends State<ExpandedImage> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: getIt<CoffeeBloc>().state.favorites.indexOf(
        widget.initialImage,
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocSelector<CoffeeBloc, CoffeeState, List<String>>(
        bloc: getIt<CoffeeBloc>(),
        selector: (state) {
          return state.favorites;
        },
        builder: (context, favorites) {
          return PageView.builder(
            controller: _pageController,
            itemCount: favorites.length,
            itemBuilder: (context, pageIndex) {
              return FutureBuilder<Uint8List?>(
                future: getIt<FileCacheService>().getBytes(
                  favorites[pageIndex],
                ),
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done ||
                      snapshot.data == null) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return InteractiveViewer(
                    child: Image.memory(
                      snapshot.data!,
                      fit: BoxFit.contain,
                      semanticLabel: context.l10n.coffeePhotoLabel,
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
