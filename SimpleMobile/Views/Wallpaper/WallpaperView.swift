import SwiftUI

struct WallpaperView: View {
    @Bindable var viewModel: WallpaperViewModel
    @Bindable var slotViewModel: SlotListViewModel

    var body: some View {
        Form {
            Section(String(localized: "Preview")) {
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(Color(hex: slotViewModel.config.backgroundColor))
                    .frame(height: 320)
                    .overlay {
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .strokeBorder(Color.primary.opacity(0.1), lineWidth: 1)
                    }
                    .listRowInsets(EdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16))
                    .listRowBackground(Color.clear)
                    .accessibilityLabel(String(localized: "Wallpaper preview"))
            }

            Section(String(localized: "Size")) {
                Picker(String(localized: "Wallpaper Size"), selection: $viewModel.selectedSize) {
                    ForEach(WallpaperSize.allCases) { size in
                        Text(size.title).tag(size)
                    }
                }
                .pickerStyle(.segmented)
            }

            Section {
                Button {
                    viewModel.resetSaveState()
                    viewModel.saveWallpaper()
                } label: {
                    HStack {
                        Spacer()
                        if viewModel.saveState == .saving {
                            ProgressView()
                        } else {
                            Text(String(localized: "Save to Photos"))
                        }
                        Spacer()
                    }
                }
                .disabled(viewModel.saveState == .saving)

                switch viewModel.saveState {
                case .success:
                    Label(String(localized: "Saved to Photos"), systemImage: "checkmark.circle.fill")
                        .foregroundStyle(.green)
                        .symbolEffect(.bounce, value: viewModel.saveState)
                case .denied:
                    Text(String(localized: "Photo access denied. Enable in Settings."))
                        .font(.caption)
                        .foregroundStyle(.red)
                case .failed:
                    Text(String(localized: "Could not save wallpaper. Try again."))
                        .font(.caption)
                        .foregroundStyle(.red)
                case .idle, .saving:
                    EmptyView()
                }
            }
        }
        .navigationTitle(String(localized: "Wallpaper"))
        .onAppear {
            viewModel.resetSaveState()
        }
    }
}
