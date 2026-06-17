import SwiftUI

struct ShortcutSetupGuideView: View {
    let appName: String
    let suggestedShortcutName: String

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label(String(localized: "Shortcut Setup Guide"), systemImage: "list.number")
                .font(.subheadline.bold())

            Text(String(localized: "Apps like this have no public URL scheme. Create a Shortcut once, then enter its exact name below."))
                .font(.caption)
                .foregroundStyle(.secondary)

            VStack(alignment: .leading, spacing: 10) {
                guideStep(
                    number: 1,
                    text: String(localized: "Open the Shortcuts app")
                )
                guideStep(
                    number: 2,
                    text: String(format: String(localized: "Create a new shortcut with the Open App action, then choose %@"), appName)
                )
                guideStep(
                    number: 3,
                    text: String(format: String(localized: "Name the shortcut exactly: %@"), suggestedShortcutName)
                )
                guideStep(
                    number: 4,
                    text: String(localized: "Return here and enter that name in Shortcut Name, then tap Test Link")
                )
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(Color(.secondarySystemBackground))
            )
        }
        .accessibilityElement(children: .combine)
    }

    private func guideStep(number: Int, text: String) -> some View {
        HStack(alignment: .top, spacing: 10) {
            Text("\(number)")
                .font(.caption2.bold())
                .frame(width: 20, height: 20)
                .background(Circle().fill(Color.primary.opacity(0.12)))
            Text(text)
                .font(.caption)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}
