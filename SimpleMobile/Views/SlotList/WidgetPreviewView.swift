import SwiftUI

enum PreviewWidgetSize {
    case medium
    case large

    var slotLimit: Int {
        switch self {
        case .medium: return 4
        case .large: return 8
        }
    }

    var fontSize: Font {
        switch self {
        case .medium: return .title2
        case .large: return .title3
        }
    }
}

struct WidgetPreviewView: View {
    let config: WidgetConfig
    var size: PreviewWidgetSize = .medium
    var cornerRadius: CGFloat = 16

    private var visibleSlots: [AppSlot] {
        config.visibleSlots(limit: size.slotLimit)
    }

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .fill(Color(hex: config.backgroundColor))

            if visibleSlots.isEmpty {
                Text("Open app to configure")
                    .font(.caption)
                    .fontWeight(config.fontWeightValue)
                    .foregroundStyle(config.foregroundColor)
                    .multilineTextAlignment(.center)
                    .padding(8)
            } else {
                VStack(spacing: 0) {
                    ForEach(Array(visibleSlots.enumerated()), id: \.element.id) { index, slot in
                        if index > 0 {
                            Spacer(minLength: 0)
                        }
                        Text(slot.label)
                            .font(size.fontSize)
                            .fontWeight(config.fontWeightValue)
                            .foregroundStyle(
                                URLSchemeValidator.resolvedURL(for: slot) != nil
                                    ? config.foregroundColor
                                    : config.foregroundColor.opacity(0.3)
                            )
                            .frame(maxWidth: .infinity, alignment: config.swiftUIAlignment)
                            .lineLimit(1)
                            .minimumScaleFactor(0.7)
                    }
                    Spacer(minLength: 0)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
    }
}
