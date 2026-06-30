import 'package:flutter/foundation.dart' show listEquals;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_usual/app/app.dart';
import 'package:the_usual/app/core/dependencies/dependencies.dart';
import 'package:the_usual/design_system/design_system.dart';

/// {@template logged_entry_row}
/// A single logged meal entry: name, a remove button, and inline-editable
/// nutrition fields.
///
/// When linked to a usual meal the row shows that usual meal's current name, so
/// renaming it in settings is reflected here. When the logged nutrition differs
/// from the usual meal, a labelled button appears to push the logged values to
/// it.
///
/// When the entry has components (a composed meal) the row expands to show each
/// component with its own quantity stepper and editable nutrition fields.
/// {@endtemplate}
class LoggedEntryRow extends StatelessWidget {
  /// {@macro logged_entry_row}
  const LoggedEntryRow({
    required this.mealLogEntry,
    required this.expandedByDefault,
    super.key,
  });

  /// The logged entry to show.
  final MealLogEntry mealLogEntry;

  /// Whether the nutrition fields start expanded for editing.
  final bool expandedByDefault;

  @override
  Widget build(BuildContext context) {
    if (mealLogEntry.components.isNotEmpty) {
      return _ComposedLoggedEntry(
        mealLogEntry: mealLogEntry,
        expandedByDefault: expandedByDefault,
      );
    }

    return BlocSelector<UserSettingsBloc, UserSettingsState, UsualMeal?>(
      bloc: getIt<UserSettingsBloc>(),
      selector: (state) => _findLinkedUsualMeal(
        state,
        mealLogEntry.mealOfTheDay,
        mealLogEntry.usualMealId,
      ),
      builder: (context, usualMeal) {
        final nutrition = mealLogEntry.nutrition;
        final differsFromUsualMeal =
            usualMeal != null && usualMeal.nutrition != nutrition;

        return ExpandableNutrition(
          name: usualMeal?.name ?? mealLogEntry.name,
          nutrition: nutrition,
          quantity: mealLogEntry.quantity,
          onQuantityChanged: (quantity) => getIt<DailyLogBloc>().add(
            DailyLogEvent.mealEntryQuantityChanged(mealLogEntry.id, quantity),
          ),
          expandedByDefault: expandedByDefault,
          onChanged: (nutrition) => getIt<DailyLogBloc>().add(
            DailyLogEvent.mealEntryNutritionChanged(mealLogEntry.id, nutrition),
          ),
          onRemoved: () => getIt<DailyLogBloc>().add(
            DailyLogEvent.mealEntryRemoved(mealLogEntry.id),
          ),
          expandedFooter: usualMeal == null
              ? UpdateUsualButton(
                  label: 'Save as usual',
                  onPressed: () {
                    final usualMealId = getIt<UserSettingsBloc>()
                        .saveAsUsualMeal(
                          mealLogEntry.mealOfTheDay,
                          mealLogEntry.name,
                          nutrition,
                        );
                    getIt<DailyLogBloc>().add(
                      DailyLogEvent.mealEntryUsualMealLinked(
                        mealLogEntry.id,
                        usualMealId,
                      ),
                    );
                  },
                )
              : differsFromUsualMeal
              ? UpdateUsualButton(
                  label: nutrition.isEmpty
                      ? "Clear this usual meal's nutrition"
                      : 'Update usual meal to match',
                  onPressed: () => getIt<UserSettingsBloc>().add(
                    UserSettingsEvent.usualMealNutritionChanged(
                      mealLogEntry.mealOfTheDay,
                      usualMeal.id,
                      nutrition,
                    ),
                  ),
                )
              : null,
        );
      },
    );
  }
}

/// The usual meal a logged entry is linked to, or null when it isn't linked or
/// its usual meal no longer exists.
UsualMeal? _findLinkedUsualMeal(
  UserSettingsState state,
  MealOfTheDay mealOfTheDay,
  String? usualMealId,
) {
  if (usualMealId == null) return null;
  final usualMeals = state.usuals[mealOfTheDay] ?? const <UsualMeal>[];
  for (final usualMeal in usualMeals) {
    if (usualMeal.id == usualMealId) return usualMeal;
  }
  return null;
}

/// An [ExpansionTile] showing a composed meal's name and total nutrition when
/// collapsed, and its components when expanded: one [_ComposedComponentRow] per
/// component inside a tinted, rail-marked group that reads as nested under the
/// meal, followed by an action to add another food from the usual foods
/// library. Component nutrition is read-only here and edited in that library.
/// Shows an [UpdateUsualButton] footer mirroring the plain-entry footer: "Save
/// as usual" when not linked, "Update usual meal to match" when linked but the
/// components or nutrition differ, and nothing when identical.
class _ComposedLoggedEntry extends StatelessWidget {
  const _ComposedLoggedEntry({
    required this.mealLogEntry,
    required this.expandedByDefault,
  });

  final MealLogEntry mealLogEntry;
  final bool expandedByDefault;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocSelector<UserSettingsBloc, UserSettingsState, UsualMeal?>(
      bloc: getIt<UserSettingsBloc>(),
      selector: (state) => _findLinkedUsualMeal(
        state,
        mealLogEntry.mealOfTheDay,
        mealLogEntry.usualMealId,
      ),
      builder: (context, usualMeal) {
        final differsFromUsualMeal =
            usualMeal != null &&
            (!listEquals(usualMeal.components, mealLogEntry.components) ||
                usualMeal.nutrition != mealLogEntry.nutrition);

        UpdateUsualButton? footer;
        if (usualMeal == null) {
          footer = UpdateUsualButton(
            label: 'Save as usual',
            onPressed: () {
              final id = getIt<UserSettingsBloc>().saveAsUsualMeal(
                mealLogEntry.mealOfTheDay,
                mealLogEntry.name,
                mealLogEntry.nutrition,
                components: mealLogEntry.components,
              );
              getIt<DailyLogBloc>().add(
                DailyLogEvent.mealEntryUsualMealLinked(mealLogEntry.id, id),
              );
            },
          );
        } else if (differsFromUsualMeal) {
          footer = UpdateUsualButton(
            label: 'Update usual meal to match',
            onPressed: () => getIt<UserSettingsBloc>().add(
              UserSettingsEvent.usualMealComponentsChanged(
                mealLogEntry.mealOfTheDay,
                usualMeal.id,
                mealLogEntry.components,
                mealLogEntry.nutrition,
              ),
            ),
          );
        }

        return ListTileTheme.merge(
          minLeadingWidth: 0,
          horizontalTitleGap: AppDesign.spacing.sm,
          child: ExpansionTile(
            dense: true,
            initiallyExpanded: expandedByDefault,
            controlAffinity: ListTileControlAffinity.leading,
            tilePadding: EdgeInsets.zero,
            childrenPadding: EdgeInsets.only(left: AppDesign.spacing.lg),
            shape: const Border(),
            collapsedShape: const Border(),
            expandedCrossAxisAlignment: CrossAxisAlignment.stretch,
            title: DefaultTextStyle.merge(
              style: theme.textTheme.bodyMedium,
              child: Wrap(
                spacing: AppDesign.spacing.sm,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    mealLogEntry.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyLarge,
                  ),
                  NutritionSummary(mealLogEntry.nutrition),
                ],
              ),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete_forever_outlined),
              onPressed: () => getIt<DailyLogBloc>().add(
                DailyLogEvent.mealEntryRemoved(mealLogEntry.id),
              ),
            ),
            children: [
              Container(
                margin: EdgeInsets.only(top: AppDesign.spacing.xs),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(AppDesign.radius.sm),
                ),
                child: Stack(
                  children: [
                    // Full-height connector rail marking the ingredients as
                    // nested under the meal.
                    Positioned(
                      left: AppDesign.spacing.sm,
                      top: AppDesign.spacing.sm,
                      bottom: AppDesign.spacing.sm,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: theme.colorScheme.outlineVariant,
                          borderRadius: BorderRadius.circular(1),
                        ),
                        child: const SizedBox(width: 2),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        AppDesign.spacing.sm + AppDesign.spacing.md,
                        0,
                        0,
                        0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (
                            var index = 0;
                            index < mealLogEntry.components.length;
                            index++
                          ) ...[
                            if (index > 0) const Divider(height: 1),
                            _ComposedComponentRow(
                              key: ValueKey(index),
                              mealLogEntryId: mealLogEntry.id,
                              mealComponent: mealLogEntry.components[index],
                              componentIndex: index,
                            ),
                          ],
                          const Divider(height: 1),
                          TextButton.icon(
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                vertical: AppDesign.spacing.xs,
                              ),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            onPressed: () async {
                              final result =
                                  await TheUsualBottomSheet.show<
                                    UsualFoodPickerResult
                                  >(
                                    context,
                                    builder: (_) =>
                                        const UsualFoodPickerSheet(),
                                  );
                              if (result == null) return;
                              final component = switch (result) {
                                PickedFoodPickerResult(:final usualFood) =>
                                  MealComponent(
                                    name: usualFood.name,
                                    nutrition: usualFood.nutrition,
                                    usualFoodId: usualFood.id,
                                  ),
                                CreatedFoodPickerResult(
                                  :final name,
                                  :final nutrition,
                                  :final saveAsUsual,
                                ) =>
                                  MealComponent(
                                    name: name,
                                    nutrition: nutrition,
                                    usualFoodId: saveAsUsual
                                        ? getIt<UserSettingsBloc>()
                                              .saveAsUsualFood(name, nutrition)
                                        : null,
                                  ),
                              };
                              getIt<DailyLogBloc>().add(
                                DailyLogEvent.mealEntryComponentAdded(
                                  mealLogEntry.id,
                                  component,
                                ),
                              );
                            },
                            icon: const Icon(Icons.add),
                            label: const Text('Add a food'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (footer != null)
                Padding(
                  padding: EdgeInsets.only(top: AppDesign.spacing.sm),
                  child: footer,
                ),
            ],
          ),
        );
      },
    );
  }
}

/// A single component row inside a composed meal entry: the component name, its
/// scaled nutrition as a [NutritionSummary], and a quantity stepper. Nutrition
/// itself is read-only here; it is edited in the usual foods library via the
/// meal header's edit action.
class _ComposedComponentRow extends StatelessWidget {
  const _ComposedComponentRow({
    required this.mealLogEntryId,
    required this.mealComponent,
    required this.componentIndex,
    super.key,
  });

  final String mealLogEntryId;
  final MealComponent mealComponent;
  final int componentIndex;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppDesign.spacing.sm),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(mealComponent.name, style: theme.textTheme.bodyMedium),
                SizedBox(height: AppDesign.spacing.xs),
                DefaultTextStyle.merge(
                  style: theme.textTheme.bodyMedium,
                  child: NutritionSummary(mealComponent.scaledNutrition),
                ),
              ],
            ),
          ),
          SizedBox(width: AppDesign.spacing.sm),
          if (mealComponent.usualFoodId == null) ...[
            SaveUsualIconButton(
              onPressed: () {
                final usualFoodId = getIt<UserSettingsBloc>().saveAsUsualFood(
                  mealComponent.name,
                  mealComponent.nutrition,
                );
                getIt<DailyLogBloc>().add(
                  DailyLogEvent.mealEntryComponentUsualFoodLinked(
                    mealLogEntryId,
                    componentIndex,
                    usualFoodId,
                  ),
                );
              },
            ),
            SizedBox(width: AppDesign.spacing.sm),
          ],
          QuantityStepper(
            dense: true,
            showStepSizeToggle: false,
            quantity: mealComponent.quantity,
            onChanged: (quantity) => getIt<DailyLogBloc>().add(
              DailyLogEvent.mealEntryComponentQuantityChanged(
                mealLogEntryId,
                componentIndex,
                quantity,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_forever_outlined),
            tooltip: 'Remove food',
            onPressed: () => getIt<DailyLogBloc>().add(
              DailyLogEvent.mealEntryComponentRemoved(
                mealLogEntryId,
                componentIndex,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
