import 'package:the_usual/app/model/model.dart';

extension MealComponentListFormatting on List<MealComponent> {
  /// The combined nutrition of these components, each scaled by its quantity —
  /// one serving of a meal composed from them. Values a component leaves unset
  /// add nothing. Empty when there are no components.
  Nutrition get componentsTotal {
    var nutrition = const Nutrition();
    for (final mealComponent in this) {
      nutrition += mealComponent.scaledNutrition;
    }
    return nutrition;
  }
}
