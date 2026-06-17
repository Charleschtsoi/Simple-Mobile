import Foundation
import Observation
import WidgetKit

@Observable
final class SlotListViewModel {
    private let store = SharedStore()

    var config: WidgetConfig
    var widgetHasBeenAdded: Bool

    init() {
        config = store.loadConfig()
        widgetHasBeenAdded = store.widgetHasBeenAdded
    }

    var canAddSlot: Bool {
        config.slots.count < WidgetConfig.maxSlots
    }

    func refreshWidgetStatus() {
        widgetHasBeenAdded = store.widgetHasBeenAdded
    }

    func save() {
        AppLabelDictionary.applyLanguageMode(to: &config)
        config.normalizeSortOrders()
        store.saveConfig(config)
        WidgetCenter.shared.reloadTimelines(ofKind: SharedStore.widgetKind)
        HapticManager.success()
    }

    func move(from source: IndexSet, to destination: Int) {
        var ordered = config.sortedSlots
        ordered.move(fromOffsets: source, toOffset: destination)
        for (index, slot) in ordered.enumerated() {
            if let slotIndex = config.slots.firstIndex(where: { $0.id == slot.id }) {
                config.slots[slotIndex].sortOrder = index
            }
        }
        save()
    }

    func delete(at offsets: IndexSet) {
        let ordered = config.sortedSlots
        let idsToRemove = offsets.map { ordered[$0].id }
        config.slots.removeAll { idsToRemove.contains($0.id) }
        config.normalizeSortOrders()
        save()
    }

    func addSlot(_ slot: AppSlot) {
        guard canAddSlot else { return }
        var newSlot = slot
        newSlot.sortOrder = config.slots.count
        config.slots.append(newSlot)
        save()
    }

    func updateSlot(_ slot: AppSlot) {
        guard let index = config.slots.firstIndex(where: { $0.id == slot.id }) else { return }
        config.slots[index] = slot
        save()
    }

    func applyAppearance(
        backgroundColor: String,
        fontWeight: String,
        textAlignment: String,
        languageMode: String
    ) {
        config.backgroundColor = backgroundColor
        config.fontWeight = fontWeight
        config.textAlignment = textAlignment
        config.languageMode = languageMode
        save()
    }
}
