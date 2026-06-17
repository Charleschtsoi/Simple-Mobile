import Foundation

/// A single slot on the widget representing one app shortcut.
struct AppSlot: Codable, Identifiable, Hashable {
    let id: UUID
    var label: String
    var urlScheme: String
    var shortcutName: String?
    var launchMode: String
    var sortOrder: Int

    init(
        id: UUID = UUID(),
        label: String,
        urlScheme: String,
        shortcutName: String? = nil,
        launchMode: LaunchMode = .urlScheme,
        sortOrder: Int
    ) {
        self.id = id
        self.label = label
        self.urlScheme = urlScheme
        self.shortcutName = shortcutName
        self.launchMode = launchMode.rawValue
        self.sortOrder = sortOrder
    }

    var resolvedLaunchMode: LaunchMode {
        LaunchMode(rawValue: launchMode) ?? LaunchMode.inferred(urlScheme: urlScheme, shortcutName: shortcutName)
    }

    enum CodingKeys: String, CodingKey {
        case id, label, urlScheme, shortcutName, launchMode, sortOrder
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        label = try container.decode(String.self, forKey: .label)
        urlScheme = try container.decode(String.self, forKey: .urlScheme)
        shortcutName = try container.decodeIfPresent(String.self, forKey: .shortcutName)
        sortOrder = try container.decode(Int.self, forKey: .sortOrder)

        if let storedMode = try container.decodeIfPresent(String.self, forKey: .launchMode),
           LaunchMode(rawValue: storedMode) != nil {
            launchMode = storedMode
        } else {
            launchMode = LaunchMode.inferred(urlScheme: urlScheme, shortcutName: shortcutName).rawValue
        }
    }
}
