import SwiftUI

extension WidgetConfig {
    var swiftUIAlignment: Alignment {
        switch textAlignment {
        case "center":
            return .center
        case "trailing":
            return .trailing
        default:
            return .leading
        }
    }

    var fontWeightValue: Font.Weight {
        fontWeight == "light" ? .light : .bold
    }

    var foregroundColor: Color {
        Color(hex: backgroundColor).isLightBackground ? .black : .white
    }

    func visibleSlots(limit: Int) -> [AppSlot] {
        Array(sortedSlots.prefix(limit))
    }
}
