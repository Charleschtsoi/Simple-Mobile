import Foundation

enum LaunchMode: String, Codable, CaseIterable, Identifiable {
    case urlScheme
    case shortcutOnly

    var id: String { rawValue }

    var title: String {
        switch self {
        case .urlScheme:
            return String(localized: "URL Scheme")
        case .shortcutOnly:
            return String(localized: "Shortcut Only")
        }
    }

    static func inferred(urlScheme: String, shortcutName: String?) -> LaunchMode {
        let hasScheme = !urlScheme.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        let hasShortcut = !(shortcutName?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true)
        if !hasScheme && hasShortcut {
            return .shortcutOnly
        }
        return .urlScheme
    }
}
