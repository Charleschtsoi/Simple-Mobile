import SwiftUI

struct AppearanceSettingsView: View {
    @Bindable var viewModel: SlotListViewModel

    var body: some View {
        Form {
            Section(String(localized: "Background")) {
                Picker(String(localized: "Color"), selection: backgroundSelection) {
                    Text(String(localized: "Black")).tag("#000000")
                    Text(String(localized: "White")).tag("#FFFFFF")
                    Text(String(localized: "Deep Grey")).tag("#121212")
                }
                .pickerStyle(.segmented)
                .accessibilityLabel(String(localized: "Background color"))
            }

            Section(String(localized: "Typography")) {
                Picker(String(localized: "Font Weight"), selection: fontWeightSelection) {
                    Text(String(localized: "Bold")).tag("bold")
                    Text(String(localized: "Light")).tag("light")
                }
                .pickerStyle(.segmented)

                Picker(String(localized: "Text Alignment"), selection: alignmentSelection) {
                    Text(String(localized: "Leading")).tag("leading")
                    Text(String(localized: "Center")).tag("center")
                    Text(String(localized: "Trailing")).tag("trailing")
                }
                .pickerStyle(.segmented)
            }

            Section(String(localized: "Language")) {
                Picker(String(localized: "Label Language"), selection: languageSelection) {
                    Text(String(localized: "English")).tag("en")
                    Text(String(localized: "繁體中文")).tag("zh-HK")
                    Text(String(localized: "Custom")).tag("custom")
                }
                .pickerStyle(.segmented)
            }

            Section(String(localized: "Preview")) {
                WidgetPreviewView(config: viewModel.config)
                    .frame(height: 140)
                    .listRowInsets(EdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16))
                    .listRowBackground(Color.clear)
            }
        }
        .navigationTitle(String(localized: "Appearance"))
    }

    private var backgroundSelection: Binding<String> {
        Binding(
            get: { viewModel.config.backgroundColor },
            set: { newValue in
                viewModel.applyAppearance(
                    backgroundColor: newValue,
                    fontWeight: viewModel.config.fontWeight,
                    textAlignment: viewModel.config.textAlignment,
                    languageMode: viewModel.config.languageMode
                )
            }
        )
    }

    private var fontWeightSelection: Binding<String> {
        Binding(
            get: { viewModel.config.fontWeight },
            set: { newValue in
                viewModel.applyAppearance(
                    backgroundColor: viewModel.config.backgroundColor,
                    fontWeight: newValue,
                    textAlignment: viewModel.config.textAlignment,
                    languageMode: viewModel.config.languageMode
                )
            }
        )
    }

    private var alignmentSelection: Binding<String> {
        Binding(
            get: { viewModel.config.textAlignment },
            set: { newValue in
                viewModel.applyAppearance(
                    backgroundColor: viewModel.config.backgroundColor,
                    fontWeight: viewModel.config.fontWeight,
                    textAlignment: newValue,
                    languageMode: viewModel.config.languageMode
                )
            }
        )
    }

    private var languageSelection: Binding<String> {
        Binding(
            get: { viewModel.config.languageMode },
            set: { newValue in
                viewModel.applyAppearance(
                    backgroundColor: viewModel.config.backgroundColor,
                    fontWeight: viewModel.config.fontWeight,
                    textAlignment: viewModel.config.textAlignment,
                    languageMode: newValue
                )
            }
        )
    }
}
