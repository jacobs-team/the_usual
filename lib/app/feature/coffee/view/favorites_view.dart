import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_template/app/core/dependencies/dependencies.dart';
import 'package:flutter_template/app/feature/coffee/coffee.dart';
import 'package:flutter_template/design_system/design_system.dart';
import 'package:flutter_template/l10n/l10n.dart';

/// {@template favorites_view}
/// A stateless widget that displays a grid of favorited coffee images.
/// {@endtemplate}
class FavoritesView extends StatelessWidget {
  /// {@macro favorites_view}
  const FavoritesView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocSelector<CoffeeBloc, CoffeeState, List<String>>(
        bloc: getIt<CoffeeBloc>(),
        selector: (state) {
          return state.favorites;
        },
        builder: (context, savedImages) {
          if (savedImages.isEmpty) {
            return Center(child: Text(context.l10n.noSavedImages));
          }
          return ListView.separated(
            padding: EdgeInsets.all(AppDesign.spacing.md),
            clipBehavior: Clip.none,
            separatorBuilder: (context, index) => SizedBox(
              height: AppDesign.spacing.md,
            ),
            itemCount: savedImages.length,
            itemBuilder: (context, index) {
              return FavoriteImage(
                key: ValueKey(savedImages[index]),
                savedImages[index],
              );
            },
          );
        },
      ),
    );
  }
}
