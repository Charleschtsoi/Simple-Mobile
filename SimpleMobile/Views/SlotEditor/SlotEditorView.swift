import SwiftUI
import UIKit

struct SlotEditorView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.locale) private var locale

    @State private var slot: AppSlot
    @State private var label: String
    @State private var urlScheme: String
    @State private var shortcutName: String
    @State private var launchMode: LaunchMode
    @State private var selectedPresetID: String?
    @State private var validation = URLSchemeValidator.ValidationResult()
    @State private var didSave = false

    let isNew: Bool
    let onSave: (AppSlot) -> Void

    init(slot: AppSlot, isNew: Bool, onSave: @escaping (AppSlot) -> Void) {
        self._slot = State(initialValue: slot)
        self._label = State(initialValue: slot.label)
        self._urlScheme = State(initialValue: slot.urlScheme)
        self._shortcutName = State(initialValue: slot.shortcutName ?? "")
        self._launchMode = State(initialValue: slot.resolvedLaunchMode)
        self.isNew = isNew
        self.onSave = onSave
    }

    var body: some View {
        NavigationStack {
            Form {
                if isNew {
                    hkPresetsSection
                }

                Section(String(localized: "Display")) {
                    TextField(String(localized: "Label"), text: $label)
                        .accessibilityLabel(String(localized: "Label"))

                    if let warning = validation.longLabelWarning {
                        Text(warning)
                            .font(.caption)
                            .foregroundStyle(.orange)
                    }
                }

                Section(String(localized: "Launch")) {
                    Picker(String(localized: "Launch Mode"), selection: $launchMode) {
                        ForEach(LaunchMode.allCases) { mode in
                            Text(mode.title).tag(mode)
                        }
                    }
                    .pickerStyle(.segmented)
                    .accessibilityLabel(String(localized: "Launch Mode"))

                    if launchMode == .urlScheme {
                        urlSchemeFields
                    } else {
                        shortcutOnlyFields
                    }

                    validationMessages

                    Button(String(localized: "Test Link")) {
                        testLink()
                    }
                    .disabled(URLSchemeValidator.resolvedURL(for: draftSlot) == nil)
                }
            }
            .navigationTitle(isNew ? String(localized: "Add Slot") : String(localized: "Edit Slot"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(String(localized: "Cancel")) {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(String(localized: "Save")) {
                        save()
                    }
                }
            }
            .onChange(of: label) { _, _ in validate() }
            .onChange(of: urlScheme) { _, _ in validate() }
            .onChange(of: shortcutName) { _, _ in validate() }
            .onChange(of: launchMode) { _, newMode in
                if newMode == .shortcutOnly {
                    urlScheme = ""
                }
                validate()
            }
            .onAppear { validate() }
            .sensoryFeedback(.success, trigger: didSave)
        }
    }

    private var hkPresetsSection: some View {
        Section {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(HKAppPreset.all) { preset in
                        Button {
                            applyPreset(preset)
                        } label: {
                            Text(preset.localizedLabel(locale: locale))
                                .font(.subheadline)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background(
                                    Capsule()
                                        .fill(
                                            selectedPresetID == preset.id
                                                ? Color.primary
                                                : Color(.secondarySystemBackground)
                                        )
                                )
                                .foregroundStyle(
                                    selectedPresetID == preset.id
                                        ? Color(.systemBackground)
                                        : Color.primary
                                )
                        }
                        .buttonStyle(.plain)
                        .accessibilityLabel(
                            String(format: String(localized: "Preset: %@"), preset.localizedLabel(locale: locale))
                        )
                    }
                }
                .padding(.vertical, 4)
            }
            .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
        } header: {
            Text(String(localized: "Hong Kong Apps"))
        } footer: {
            Text(String(localized: "Tap a preset to auto-fill. Shortcut-only apps need a one-time Shortcuts setup."))
                .font(.caption)
        }
    }

    @ViewBuilder
    private var urlSchemeFields: some View {
        TextField(String(localized: "URL Scheme"), text: $urlScheme)
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled()
            .accessibilityLabel(String(localized: "URL Scheme"))

        TextField(String(localized: "Shortcut Name (optional)"), text: $shortcutName)
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled()
            .accessibilityLabel(String(localized: "Shortcut Name (optional)"))
    }

    @ViewBuilder
    private var shortcutOnlyFields: some View {
        TextField(String(localized: "Shortcut Name"), text: $shortcutName)
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled()
            .accessibilityLabel(String(localized: "Shortcut Name"))

        ShortcutSetupGuideView(
            appName: guideAppName,
            suggestedShortcutName: guideShortcutName
        )
        .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 12, trailing: 16))
        .listRowBackground(Color.clear)
    }

    @ViewBuilder
    private var validationMessages: some View {
        if let labelError = validation.labelError {
            Text(labelError)
                .font(.caption)
                .foregroundStyle(.red)
        }

        if let schemeError = validation.schemeError {
            Text(schemeError)
                .font(.caption)
                .foregroundStyle(.red)
        }

        if let shortcutError = validation.shortcutError {
            Text(shortcutError)
                .font(.caption)
                .foregroundStyle(.red)
        }
    }

    private var guideAppName: String {
        if let presetID = selectedPresetID,
           let preset = HKAppPreset.preset(withID: presetID) {
            return preset.shortcutsAppName
        }
        return String(localized: "your app")
    }

    private var guideShortcutName: String {
        let trimmed = shortcutName.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmed.isEmpty {
            return trimmed
        }
        if let presetID = selectedPresetID,
           let preset = HKAppPreset.preset(withID: presetID),
           !preset.suggestedShortcutName.isEmpty {
            return preset.suggestedShortcutName
        }
        return String(localized: "Open App")
    }

    private var draftSlot: AppSlot {
        var updated = slot
        updated.label = label
        updated.launchMode = launchMode.rawValue
        let trimmedShortcut = shortcutName.trimmingCharacters(in: .whitespacesAndNewlines)
        updated.shortcutName = trimmedShortcut.isEmpty ? nil : trimmedShortcut

        if launchMode == .shortcutOnly {
            updated.urlScheme = ""
        } else {
            updated.urlScheme = URLSchemeValidator.normalize(urlScheme)
        }

        return updated
    }

    private func applyPreset(_ preset: HKAppPreset) {
        selectedPresetID = preset.id
        label = preset.localizedLabel(locale: locale)
        launchMode = preset.launchMode
        urlScheme = preset.urlScheme ?? ""
        shortcutName = preset.suggestedShortcutName
        validate()
    }

    private func validate() {
        validation = URLSchemeValidator.validate(
            label: label,
            urlScheme: urlScheme,
            shortcutName: shortcutName,
            launchMode: launchMode
        )
    }

    private func save() {
        validate()
        guard validation.isValid else { return }
        onSave(draftSlot)
        didSave = true
        dismiss()
    }

    private func testLink() {
        guard let url = URLSchemeValidator.resolvedURL(for: draftSlot) else { return }
        UIApplication.shared.open(url)
    }
}
