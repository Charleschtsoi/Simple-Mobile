import SwiftUI

struct OnboardingView: View {
    @AppStorage("hasOnboarded") private var hasOnboarded = false
    @State private var page = 0

    var body: some View {
        VStack(spacing: 0) {
            TabView(selection: $page) {
                welcomePage.tag(0)
                setupPage.tag(1)
                goMinimalPage.tag(2)
            }
            .tabViewStyle(.page(indexDisplayMode: .always))

            Button(action: advance) {
                Text(page == 2 ? String(localized: "Get Started") : String(localized: "Continue"))
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.primary)
                    .foregroundStyle(Color(.systemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 32)
            .accessibilityLabel(
                page == 2 ? String(localized: "Get Started") : String(localized: "Continue")
            )
        }
    }

    private var welcomePage: some View {
        VStack(spacing: 24) {
            Spacer()
            MinimalPhoneIllustration(showLabels: true)
                .frame(height: 220)
            Text("Your phone, simplified.")
                .font(.largeTitle.bold())
                .multilineTextAlignment(.center)
            Text("Replace colorful icons with clean text labels. Tap to launch.")
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
            Spacer()
        }
        .padding()
    }

    private var setupPage: some View {
        VStack(spacing: 24) {
            Spacer()
            WidgetSetupIllustration()
                .frame(height: 220)
            Text("Add the Widget")
                .font(.title.bold())
            VStack(alignment: .leading, spacing: 12) {
                stepRow(number: 1, text: String(localized: "Long-press your Home Screen"))
                stepRow(number: 2, text: String(localized: "Tap Edit, then Add Widget"))
                stepRow(number: 3, text: String(localized: "Search for 極簡手機 and add Medium or Large"))
            }
            .padding(.horizontal, 32)
            Spacer()
        }
        .padding()
    }

    private var goMinimalPage: some View {
        VStack(spacing: 24) {
            Spacer()
            MinimalWallpaperIllustration()
                .frame(height: 220)
            Text("Go Minimal")
                .font(.title.bold())
            Text("Set a solid wallpaper and move other apps to App Library for a distraction-free screen.")
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
            Spacer()
        }
        .padding()
    }

    private func stepRow(number: Int, text: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Text("\(number)")
                .font(.caption.bold())
                .frame(width: 24, height: 24)
                .background(Circle().fill(Color.primary.opacity(0.1)))
            Text(text)
                .font(.subheadline)
        }
        .accessibilityElement(children: .combine)
    }

    private func advance() {
        if page < 2 {
            page += 1
        } else {
            hasOnboarded = true
        }
    }
}

private struct MinimalPhoneIllustration: View {
    let showLabels: Bool

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .strokeBorder(Color.primary.opacity(0.2), lineWidth: 2)
                .background(
                    RoundedRectangle(cornerRadius: 28, style: .continuous)
                        .fill(Color(.secondarySystemBackground))
                )

            if showLabels {
                VStack(alignment: .leading, spacing: 14) {
                    Text("WhatsApp").font(.title3.bold())
                    Text("Signal").font(.title3.bold())
                    Text("Safari").font(.title3.bold())
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(28)
            }
        }
        .padding(.horizontal, 40)
    }
}

private struct WidgetSetupIllustration: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .strokeBorder(Color.primary.opacity(0.2), lineWidth: 2)
                .frame(width: 160, height: 220)

            VStack(spacing: 8) {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.primary.opacity(0.85))
                    .frame(width: 120, height: 56)
                Image(systemName: "arrow.down")
                    .font(.title2)
                    .foregroundStyle(.secondary)
                RoundedRectangle(cornerRadius: 8)
                    .strokeBorder(style: StrokeStyle(lineWidth: 2, dash: [6]))
                    .frame(width: 120, height: 56)
            }
        }
    }
}

private struct MinimalWallpaperIllustration: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(Color.black)
                .frame(width: 160, height: 220)
                .overlay {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("WhatsApp").foregroundStyle(.white).font(.caption.bold())
                        Text("Spotify").foregroundStyle(.white).font(.caption.bold())
                        Spacer()
                    }
                    .padding(16)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                }

            Image(systemName: "photo.on.rectangle.angled")
                .font(.largeTitle)
                .foregroundStyle(.white)
                .offset(x: 90, y: 90)
                .background(
                    Circle()
                        .fill(Color.accentColor)
                        .frame(width: 56, height: 56)
                )
        }
    }
}
