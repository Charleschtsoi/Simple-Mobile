import AppIntents
import WidgetKit

struct ConfigurationAppIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "Simple Widget"
    static var description = IntentDescription("Typography-only app launcher widget")
}
