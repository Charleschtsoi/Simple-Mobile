import SwiftUI

@main
struct SimpleMobileApp: App {
    @AppStorage("hasOnboarded") private var hasOnboarded = false
    @State private var slotViewModel = SlotListViewModel()
    @State private var wallpaperViewModel = WallpaperViewModel()

    var body: some Scene {
        WindowGroup {
            if hasOnboarded {
                MainTabView(
                    slotViewModel: slotViewModel,
                    wallpaperViewModel: wallpaperViewModel
                )
            } else {
                OnboardingView()
            }
        }
    }
}

private struct MainTabView: View {
    @Bindable var slotViewModel: SlotListViewModel
    @Bindable var wallpaperViewModel: WallpaperViewModel

    var body: some View {
        TabView {
            NavigationStack {
                SlotListView(viewModel: slotViewModel)
            }
            .tabItem {
                Label(String(localized: "Slots"), systemImage: "list.bullet")
            }

            NavigationStack {
                AppearanceSettingsView(viewModel: slotViewModel)
            }
            .tabItem {
                Label(String(localized: "Appearance"), systemImage: "textformat")
            }

            NavigationStack {
                WallpaperView(viewModel: wallpaperViewModel, slotViewModel: slotViewModel)
            }
            .tabItem {
                Label(String(localized: "Wallpaper"), systemImage: "photo")
            }
        }
    }
}
