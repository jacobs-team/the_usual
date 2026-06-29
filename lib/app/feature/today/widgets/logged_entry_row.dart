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
/// collapsed, and one [_ComposedComponentRow] per component when expanded.
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
              for (
                var index = 0;
                index < mealLogEntry.components.length;
                index++
              )
                _ComposedComponentRow(
                  key: ValueKey(index),
                  mealLogEntryId: mealLogEntry.id,
                  mealComponent: mealLogEntry.components[index],
                  componentIndex: index,
                ),
              ?footer,
            ],
          ),
        );
      },
    );
  }
}

/// A single component row inside a composed meal entry: the component name,
/// its scaled nutrition summary, a quantity stepper, and a tap-to-reveal set of
/// editable nutrition fields.
class _ComposedComponentRow extends StatefulWidget {
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
  State<_ComposedComponentRow> createState() => _ComposedComponentRowState();
}

class _ComposedComponentRowState extends State<_ComposedComponentRow> {
  bool _nutritionExpanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mealComponent = widget.mealComponent;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        InkWell(
          onTap: () => setState(() => _nutritionExpanded = !_nutritionExpanded),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: AppDesign.spacing.xs),
            child: Row(
              children: [
                Expanded(
                  child: DefaultTextStyle.merge(
                    style: theme.textTheme.bodyMedium,
                    child: Wrap(
                      spacing: AppDesign.spacing.sm,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          mealComponent.name,
                          style: theme.textTheme.bodyMedium,
                        ),
                        NutritionSummary(mealComponent.scaledNutrition),
                      ],
                    ),
                  ),
                ),
                QuantityStepper(
                  dense: true,
                  quantity: mealComponent.quantity,
                  onChanged: (quantity) => getIt<DailyLogBloc>().add(
                    DailyLogEvent.mealEntryComponentQuantityChanged(
                      widget.mealLogEntryId,
                      widget.componentIndex,
                      quantity,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (_nutritionExpanded)
          Padding(
            padding: EdgeInsets.only(bottom: AppDesign.spacing.sm),
            child: NutritionFields(
              dense: true,
              initial: mealComponent.nutrition,
              onChanged: (nutrition) => getIt<DailyLogBloc>().add(
                DailyLogEvent.mealEntryComponentNutritionChanged(
                  widget.mealLogEntryId,
                  widget.componentIndex,
                  nutrition,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
