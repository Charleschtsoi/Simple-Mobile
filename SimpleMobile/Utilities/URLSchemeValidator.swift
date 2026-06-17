import Foundation

enum URLSchemeValidator {
    static let longLabelThreshold = 15

    static func normalize(_ scheme: String) -> String {
        let trimmed = scheme.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return trimmed }
        if trimmed.contains("://") {
            return trimmed
        }
        return trimmed + "://"
    }

    static func isValidScheme(_ scheme: String) -> Bool {
        let normalized = normalize(scheme)
        return !normalized.isEmpty && normalized.contains("://")
    }

    static func resolvedURL(for slot: AppSlot) -> URL? {
        switch slot.resolvedLaunchMode {
        case .urlScheme:
            let normalizedScheme = normalize(slot.urlScheme)
            if !normalizedScheme.isEmpty, isValidScheme(normalizedScheme) {
                return URL(string: normalizedScheme)
            }
            return shortcutURL(named: slot.shortcutName)

        case .shortcutOnly:
            return shortcutURL(named: slot.shortcutName)
        }
    }

    private static func shortcutURL(named shortcutName: String?) -> URL? {
        guard let shortcutName = shortcutName?.trimmingCharacters(in: .whitespacesAndNewlines),
              !shortcutName.isEmpty,
              let encoded = shortcutName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return nil
        }
        return URL(string: "shortcuts://run-shortcut?name=\(encoded)")
    }

    struct ValidationResult {
        var labelError: String?
        var schemeError: String?
        var shortcutError: String?
        var longLabelWarning: String?

        var isValid: Bool {
            labelError == nil && schemeError == nil && shortcutError == nil
        }
    }

    static func validate(
        label: String,
        urlScheme: String,
        shortcutName: String?,
        launchMode: LaunchMode
    ) -> ValidationResult {
        var result = ValidationResult()

        if label.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            result.labelError = String(localized: "Label is required")
        }

        let normalized = normalize(urlScheme)
        let trimmedShortcut = shortcutName?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

        switch launchMode {
        case .urlScheme:
            if normalized.isEmpty && trimmedShortcut.isEmpty {
                result.schemeError = String(localized: "Enter a URL scheme or shortcut name")
            } else if !normalized.isEmpty && !isValidScheme(normalized) {
                result.schemeError = String(localized: "URL scheme must include ://")
            }

        case .shortcutOnly:
            if trimmedShortcut.isEmpty {
                result.shortcutError = String(localized: "Shortcut name is required for Shortcut Only mode")
            }
        }

        if label.count > longLabelThreshold {
            result.longLabelWarning = String(localized: "Long labels may appear smaller on the widget")
        }

        return result
    }
}
