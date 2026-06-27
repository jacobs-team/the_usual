import SwiftUI
import WidgetKit

/// A single static timeline entry — the launcher widget shows the same content
/// at all times, so one entry that never needs refreshing is enough.
struct LauncherEntry: TimelineEntry {
  let date: Date
}

struct LauncherProvider: TimelineProvider {
  func placeholder(in context: Context) -> LauncherEntry {
    LauncherEntry(date: Date())
  }

  func getSnapshot(in context: Context, completion: @escaping (LauncherEntry) -> Void) {
    completion(LauncherEntry(date: Date()))
  }

  func getTimeline(in context: Context, completion: @escaping (Timeline<LauncherEntry>) -> Void) {
    completion(Timeline(entries: [LauncherEntry(date: Date())], policy: .never))
  }
}

struct LauncherWidgetView: View {
  var entry: LauncherEntry

  @ViewBuilder var body: some View {
    let content = AccessoryWidgetBackground()
      .overlay(PlateLogoMark().padding(3))
      .widgetAccentable()
    if #available(iOS 17.0, *) {
      content.containerBackground(.clear, for: .widget)
    } else {
      content
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
    .description("Open The Usual to log your meals.")
    .supportedFamilies([.accessoryCircular])
    .contentMarginsDisabled()
  }
}
