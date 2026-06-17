import SwiftUI
import WidgetKit

struct SimpleWidgetEntryView: View {
    @Environment(\.widgetFamily) private var family

    let config: WidgetConfig

    private var slotLimit: Int {
        family == .systemMedium ? 4 : 8
    }

    private var fontSize: Font {
        family == .systemMedium ? .title2 : .title3
    }

    private var visibleSlots: [AppSlot] {
        config.visibleSlots(limit: slotLimit)
    }

    var body: some View {
        ZStack {
            Color(hex: config.backgroundColor)

            if visibleSlots.isEmpty {
                Text("Open app to configure")
                    .font(fontSize)
                    .fontWeight(config.fontWeightValue)
                    .foregroundStyle(config.foregroundColor)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 16)
            } else {
                VStack(spacing: 0) {
                    ForEach(Array(visibleSlots.enumerated()), id: \.element.id) { index, slot in
                        if index > 0 {
                            Spacer(minLength: 0)
                        }
                        slotView(for: slot)
                    }
                    Spacer(minLength: 0)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
            }
        }
        .containerBackground(for: .widget) {
            Color(hex: config.backgroundColor)
        }
    }

    @ViewBuilder
    private func slotView(for slot: AppSlot) -> some View {
        if let url = URLSchemeValidator.resolvedURL(for: slot) {
            Link(destination: url) {
                Text(slot.label)
                    .font(fontSize)
                    .fontWeight(config.fontWeightValue)
                    .foregroundStyle(config.foregroundColor)
                    .frame(maxWidth: .infinity, alignment: config.swiftUIAlignment)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
            }
            .accessibilityLabel(
                String(format: String(localized: "Open %@"), slot.label)
            )
        } else {
            Text(slot.label)
                .font(fontSize)
                .fontWeight(config.fontWeightValue)
                .foregroundStyle(config.foregroundColor.opacity(0.3))
                .frame(maxWidth: .infinity, alignment: config.swiftUIAlignment)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
                .accessibilityLabel(slot.label)
        }
    }
}

#Preview(as: .systemMedium) {
    SimpleWidget()
} timeline: {
    SimpleWidgetEntry(date: .now, config: .defaultConfig)
}

#Preview(as: .systemLarge) {
    SimpleWidget()
} timeline: {
    SimpleWidgetEntry(date: .now, config: .defaultConfig)
}
