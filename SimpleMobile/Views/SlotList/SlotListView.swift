import SwiftUI

struct SlotListView: View {
    @Bindable var viewModel: SlotListViewModel
    @State private var editingSlot: AppSlot?
    @State private var isAddingSlot = false
    @State private var editMode: EditMode = .inactive

    var body: some View {
        List {
            if !viewModel.widgetHasBeenAdded {
                Section {
                    Label {
                        Text("Add the widget to your Home Screen to launch apps with a tap.")
                            .font(.subheadline)
                    } icon: {
                        Image(systemName: "square.grid.2x2")
                    }
                    .accessibilityLabel(
                        String(localized: "Add the widget to your Home Screen to launch apps with a tap.")
                    )
                }
            }

            Section(String(localized: "Preview")) {
                WidgetPreviewView(config: viewModel.config)
                    .frame(height: 140)
                    .listRowInsets(EdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16))
                    .listRowBackground(Color.clear)
            }

            Section(String(localized: "App Slots")) {
                ForEach(viewModel.config.sortedSlots) { slot in
                    Button {
                        editingSlot = slot
                    } label: {
                        SlotRowView(slot: slot)
                    }
                    .buttonStyle(.plain)
                }
                .onMove(perform: viewModel.move)
                .onDelete(perform: viewModel.delete)

                Button(String(localized: "Add Slot")) {
                    isAddingSlot = true
                }
                .disabled(!viewModel.canAddSlot)
            }
        }
        .navigationTitle(String(localized: "Slots"))
        .environment(\.editMode, $editMode)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                EditButton()
            }
        }
        .onAppear {
            viewModel.refreshWidgetStatus()
        }
        .sheet(item: $editingSlot) { slot in
            SlotEditorView(
                slot: slot,
                isNew: false,
                onSave: { updated in
                    viewModel.updateSlot(updated)
                    editingSlot = nil
                }
            )
        }
        .sheet(isPresented: $isAddingSlot) {
            SlotEditorView(
                slot: AppSlot(label: "", urlScheme: "", sortOrder: viewModel.config.slots.count),
                isNew: true,
                onSave: { newSlot in
                    viewModel.addSlot(newSlot)
                    isAddingSlot = false
                }
            )
        }
    }
}
