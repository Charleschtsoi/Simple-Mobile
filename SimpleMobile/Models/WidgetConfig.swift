import Foundation

/// The full widget configuration stored in shared UserDefaults.
struct WidgetConfig: Codable, Equatable {
    var slots: [AppSlot]
    var backgroundColor: String
    var fontWeight: String
    var textAlignment: String
    var languageMode: String

    static let maxSlots = 8

    static let defaultConfig: WidgetConfig = {
        let slots: [AppSlot] = [
            AppSlot(label: "WhatsApp", urlScheme: "whatsapp://", sortOrder: 0),
            AppSlot(label: "Threads", urlScheme: "barcelona://", sortOrder: 1),
            AppSlot(label: "Signal", urlScheme: "sgnl://", sortOrder: 2),
            AppSlot(label: "Spotify", urlScheme: "spotify://", sortOrder: 3),
            AppSlot(label: "Safari", urlScheme: "https://", sortOrder: 4)
        ]

        return WidgetConfig(
            slots: slots,
            backgroundColor: "#000000",
            fontWeight: "bold",
            textAlignment: "leading",
            languageMode: "en"
        )
    }()

    var sortedSlots: [AppSlot] {
        slots.sorted { $0.sortOrder < $1.sortOrder }
    }

    mutating func normalizeSortOrders() {
        let ordered = sortedSlots
        for index in ordered.indices {
            if let slotIndex = slots.firstIndex(where: { $0.id == ordered[index].id }) {
                slots[slotIndex].sortOrder = index
            }
        }
    }
}
