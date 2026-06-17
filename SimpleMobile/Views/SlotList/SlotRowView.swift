import SwiftUI

struct SlotRowView: View {
    let slot: AppSlot

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(slot.label)
                .font(.body)
            Text(displaySubtitle)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(slot.label), \(displaySubtitle)")
    }

    private var displaySubtitle: String {
        switch slot.resolvedLaunchMode {
        case .shortcutOnly:
            if let shortcutName = slot.shortcutName, !shortcutName.isEmpty {
                return String(format: String(localized: "Shortcut: %@"), shortcutName)
            }
            return String(localized: "Shortcut not configured")

        case .urlScheme:
            if !slot.urlScheme.isEmpty {
                return slot.urlScheme
            }
            if let shortcutName = slot.shortcutName, !shortcutName.isEmpty {
                return String(format: String(localized: "Shortcut: %@"), shortcutName)
            }
            return String(localized: "No link configured")
        }
    }
}
