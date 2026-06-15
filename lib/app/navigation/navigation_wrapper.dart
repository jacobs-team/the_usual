import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:the_usual/app/app.dart';
import 'package:the_usual/design_system/design_system.dart';

/// {@template navigation_wrapper}
/// Shell for the primary tabs (Today and History). On small screens it shows a
/// floating [GlassContainer] nav bar over each tab's content; on larger screens
/// it switches to a [NavigationRail]. Each tab keeps its own navigation stack.
/// {@endtemplate}
class NavigationWrapper extends StatelessWidget {
  /// {@macro navigation_wrapper}
  const NavigationWrapper({required this.navigationShell, super.key});

  /// The navigation shell managed by [GoRouter] that maintains each tab's
  /// navigation stack.
  final StatefulNavigationShell navigationShell;

  void _goToBranch(int index) => navigationShell.goBranch(
    index,
    initialLocation: index == navigationShell.currentIndex,
  );

  @override
  Widget build(BuildContext context) {
    final showRail = context.layout > LayoutData.small;
    final expandRail = context.layout > LayoutData.large;
    const destinations = AppRouter.destinations;

    final mediaQuery = MediaQuery.of(context);
    final floatingNavClearance =
        AppDesign.spacing.sm + kMinInteractiveDimension;
    final content = showRail
        ? navigationShell
        : MediaQuery(
            data: mediaQuery.copyWith(
              padding: mediaQuery.padding.copyWith(
                bottom: mediaQuery.padding.bottom == 0
                    ? 0
                    : mediaQuery.padding.bottom + floatingNavClearance,
              ),
            ),
            child: navigationShell,
          );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: Row(
                  children: [
                    if (showRail)
                      NavigationRail(
                        extended: expandRail,
                        destinations: destinations
                            .map(
                              (d) => NavigationRailDestination(
                                icon: d.icon,
                                label: Text(d.label),
                                selectedIcon: d.selectedIcon,
                              ),
                            )
                            .toList(),
                        selectedIndex: navigationShell.currentIndex,
                        onDestinationSelected: _goToBranch,
                      ),
                    Expanded(child: content),
                  ],
                ),
              ),
            ],
          ),

          if (!showRail)
            Positioned(
              bottom: AppDesign.spacing.xxl,
              left: 0,
              right: 0,
              child: Center(
                child: _FloatingNavBar(
                  destinations: destinations,
                  selectedIndex: navigationShell.currentIndex,
                  onDestinationSelected: _goToBranch,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _FloatingNavBar extends StatelessWidget {
  const _FloatingNavBar({
    required this.destinations,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  final List<NavigationDestination> destinations;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GlassContainer(
      child: Row(
        spacing: AppDesign.spacing.lg,
        mainAxisSize: MainAxisSize.min,
        children: destinations.indexed.map((entry) {
          final (i, d) = entry;
          final isSelected = i == selectedIndex;
          return IconButton(
            onPressed: () => onDestinationSelected(i),
            tooltip: d.label,
            icon: isSelected ? d.selectedIcon ?? d.icon : d.icon,
            color: isSelected
                ? colorScheme.onPrimary
                : colorScheme.onSurfaceVariant,
            style: isSelected
                ? IconButton.styleFrom(backgroundColor: colorScheme.primary)
                : null,
          );
        }).toList(),
      ),
    );
  }
}
