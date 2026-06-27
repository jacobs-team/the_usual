import SwiftUI
import WidgetKit

/// The day's calorie summary, read from the shared App Group container that the
/// Flutter app writes to.
struct LauncherEntry: TimelineEntry {
  let date: Date
  let hasGoal: Bool
  let goal: Int
  let consumed: Int
  let remaining: Int
  let protein: Int
  let carbs: Int
  let fat: Int
}

private let appGroupId = "group.com.jblankenship.theusual"

private func currentEntry() -> LauncherEntry {
  let defaults = UserDefaults(suiteName: appGroupId)
  let goal = defaults?.integer(forKey: "calorieGoal") ?? 0
  let hasGoal = (defaults?.bool(forKey: "hasGoal") ?? false) && goal > 0
  return LauncherEntry(
    date: Date(),
    hasGoal: hasGoal,
    goal: goal,
    consumed: defaults?.integer(forKey: "caloriesConsumed") ?? 0,
    remaining: defaults?.integer(forKey: "caloriesRemaining") ?? 0,
    protein: defaults?.integer(forKey: "proteinGrams") ?? 0,
    carbs: defaults?.integer(forKey: "carbsGrams") ?? 0,
    fat: defaults?.integer(forKey: "fatGrams") ?? 0
  )
}

/// The instant the stored day ends, after which the widget should reset to a
/// fresh full-goal day. Nil when it hasn't been written yet.
private func dayRollover() -> Date? {
  let epoch = UserDefaults(suiteName: appGroupId)?.double(forKey: "dayRolloverEpoch") ?? 0
  return epoch > 0 ? Date(timeIntervalSince1970: epoch) : nil
}

struct LauncherProvider: TimelineProvider {
  func placeholder(in context: Context) -> LauncherEntry {
    LauncherEntry(
      date: Date(), hasGoal: true, goal: 3000, consumed: 1600, remaining: 1400,
      protein: 90, carbs: 140, fat: 50
    )
  }

  func getSnapshot(in context: Context, completion: @escaping (LauncherEntry) -> Void) {
    completion(currentEntry())
  }

  func getTimeline(in context: Context, completion: @escaping (Timeline<LauncherEntry>) -> Void) {
    let today = currentEntry()
    var entries = [today]
    // When the day rolls over without the app being opened, no meals can have
    // been logged, so the new day starts at the full goal. This entry holds
    // from the rollover onward, keeping every following unopened day correct.
    if today.hasGoal, let rollover = dayRollover(), rollover > today.date {
      entries.append(LauncherEntry(
        date: rollover, hasGoal: true, goal: today.goal, consumed: 0,
        remaining: today.goal, protein: 0, carbs: 0, fat: 0
      ))
    }
    completion(Timeline(entries: entries, policy: .never))
  }
}

struct LauncherWidgetView: View {
  @Environment(\.widgetFamily) private var family
  var entry: LauncherEntry

  @ViewBuilder private var content: some View {
    if family == .accessoryRectangular {
      MacroRowView(entry: entry)
    } else if entry.hasGoal {
      CalorieRing(entry: entry).widgetAccentable()
    } else {
      AccessoryWidgetBackground()
        .overlay(PlateLogoMark().padding(3))
        .widgetAccentable()
    }
  }

  @ViewBuilder var body: some View {
    if #available(iOS 17.0, *) {
      content.containerBackground(.clear, for: .widget)
    } else {
      content
    }
  }
}

/// A custom calorie progress ring drawn so we control the center layout — the
/// stock capacity gauge shrinks its label into a small reserved area, leaving
/// the inner space unused. Shows calories eaten over goal with a divider, and
/// protein grams eaten below. Sized relative to the widget so the text fills the
/// circle.
struct CalorieRing: View {
  let entry: LauncherEntry
  var showProtein = true

  var body: some View {
    GeometryReader { geometry in
      let diameter = min(geometry.size.width, geometry.size.height)
      let lineWidth = diameter * 0.1
      let fraction = entry.goal > 0
        ? min(max(Double(entry.consumed) / Double(entry.goal), 0), 1)
        : 0
      ZStack {
        Circle()
          .stroke(.white.opacity(0.3), lineWidth: lineWidth)
        Circle()
          .trim(from: 0, to: fraction)
          .stroke(.white, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
          .rotationEffect(.degrees(-90))
        VStack(spacing: diameter * 0.02) {
          Text("\(entry.consumed)")
            .font(.system(size: diameter * 0.22, weight: .semibold))
          Rectangle()
            .fill(.white)
            .frame(width: diameter * 0.5, height: max(1, diameter * 0.02))
          Text("\(entry.goal)")
            .font(.system(size: diameter * 0.22, weight: .semibold))
          if showProtein {
            Text("P \(entry.protein)")
              .font(.system(size: diameter * 0.16, weight: .semibold))
              .padding(.top, diameter * 0.01)
          }
        }
        .minimumScaleFactor(0.5)
        .frame(width: diameter - lineWidth * 2.6)
        .scaleEffect(0.85)
      }
    }
  }
}

/// The wide (rectangular) layout: the calorie ring on the left with protein,
/// carbs, and fat grams listed beside it. Falls back to a plain launcher when no
/// goal is set.
struct MacroRowView: View {
  var entry: LauncherEntry

  @ViewBuilder var body: some View {
    if entry.hasGoal {
      HStack(spacing: 12) {
        CalorieRing(entry: entry, showProtein: false)
          .aspectRatio(1, contentMode: .fit)
        VStack(alignment: .leading, spacing: 3) {
          Text("P  \(entry.protein) g")
          Text("C  \(entry.carbs) g")
          Text("F  \(entry.fat) g")
        }
        .font(.system(size: 15, weight: .semibold))
        .minimumScaleFactor(0.6)
        Spacer(minLength: 0)
      }
      .widgetAccentable()
    } else {
      HStack(spacing: 10) {
        PlateLogoMark()
          .aspectRatio(1, contentMode: .fit)
        Text("The Usual")
          .font(.system(size: 17, weight: .semibold))
        Spacer(minLength: 0)
      }
      .widgetAccentable()
    }
  }
}

struct TheUsualLauncherWidget: Widget {
  let kind = "TheUsualLauncherWidget"

  var body: some WidgetConfiguration {
    StaticConfiguration(kind: kind, provider: LauncherProvider()) { entry in
      LauncherWidgetView(entry: entry)
    }
    .configurationDisplayName("The Usual")
    .description("Calories and macros today. Tap to open The Usual.")
    .supportedFamilies([.accessoryCircular, .accessoryRectangular])
    .contentMarginsDisabled()
  }
}
