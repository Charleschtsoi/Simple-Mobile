import SwiftUI
import WidgetKit

@main
struct SimpleWidgetBundle: WidgetBundle {
    var body: some Widget {
        SimpleWidget()
    }
}

struct SimpleWidget: Widget {
    let kind = SharedStore.widgetKind

    var body: some WidgetConfiguration {
        AppIntentConfiguration(
            kind: kind,
            intent: ConfigurationAppIntent.self,
            provider: SimpleTimelineProvider()
        ) { entry in
            SimpleWidgetEntryView(config: entry.config)
        }
        .configurationDisplayName("極簡手機")
        .description("Typography-only app launcher")
        .supportedFamilies([.systemMedium, .systemLarge])
    }
}
