import Foundation

final class SharedStore {
    static let suiteName = "group.com.charlescht.simplemobile.shared"
    static let widgetKind = "SimpleWidget"

    private let defaults: UserDefaults

    init(defaults: UserDefaults? = UserDefaults(suiteName: suiteName)) {
        self.defaults = defaults ?? .standard
    }

    func saveConfig(_ config: WidgetConfig) {
        guard let data = try? JSONEncoder().encode(config) else { return }
        defaults.set(data, forKey: Keys.widgetConfig)
    }

    func loadConfig() -> WidgetConfig {
        guard let data = defaults.data(forKey: Keys.widgetConfig),
              let config = try? JSONDecoder().decode(WidgetConfig.self, from: data) else {
            return .defaultConfig
        }
        return config
    }

    var widgetHasBeenAdded: Bool {
        get { defaults.bool(forKey: Keys.widgetHasBeenAdded) }
        set { defaults.set(newValue, forKey: Keys.widgetHasBeenAdded) }
    }

    func markWidgetAdded() {
        widgetHasBeenAdded = true
    }

    private enum Keys {
        static let widgetConfig = "widgetConfig"
        static let widgetHasBeenAdded = "widgetHasBeenAdded"
    }
}
