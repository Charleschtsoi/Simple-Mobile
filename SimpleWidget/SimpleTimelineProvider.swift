import WidgetKit

struct SimpleWidgetEntry: TimelineEntry {
    let date: Date
    let config: WidgetConfig
}

struct SimpleTimelineProvider: AppIntentTimelineProvider {
    typealias Entry = SimpleWidgetEntry
    typealias Intent = ConfigurationAppIntent

    private let store = SharedStore()

    func placeholder(in context: Context) -> SimpleWidgetEntry {
        SimpleWidgetEntry(date: .now, config: .defaultConfig)
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleWidgetEntry {
        SimpleWidgetEntry(date: .now, config: store.loadConfig())
    }

    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleWidgetEntry> {
        store.markWidgetAdded()
        let config = store.loadConfig()
        let entry = SimpleWidgetEntry(date: .now, config: config)
        return Timeline(entries: [entry], policy: .never)
    }
}
