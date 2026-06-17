import Foundation
import Observation
import Photos
import UIKit

enum WallpaperSize: String, CaseIterable, Identifiable {
    case iPhone15ProMax
    case universal

    var id: String { rawValue }

    var title: String {
        switch self {
        case .iPhone15ProMax:
            return String(localized: "iPhone 15 Pro Max")
        case .universal:
            return String(localized: "Universal Square")
        }
    }

    var dimensions: CGSize {
        switch self {
        case .iPhone15ProMax:
            return CGSize(width: 1290, height: 2796)
        case .universal:
            return CGSize(width: 2048, height: 2048)
        }
    }
}

enum WallpaperSaveState: Equatable {
    case idle
    case saving
    case success
    case denied
    case failed
}

@Observable
final class WallpaperViewModel {
    private let store = SharedStore()

    var selectedSize: WallpaperSize = .iPhone15ProMax
    var saveState: WallpaperSaveState = .idle

    var backgroundColorHex: String {
        store.loadConfig().backgroundColor
    }

    func saveWallpaper() {
        saveState = .saving

        PHPhotoLibrary.requestAuthorization(for: .addOnly) { [weak self] status in
            DispatchQueue.main.async {
                guard let self else { return }

                switch status {
                case .authorized, .limited:
                    self.performSave()
                case .denied, .restricted:
                    self.saveState = .denied
                default:
                    self.saveState = .failed
                }
            }
        }
    }

    private func performSave() {
        let hex = backgroundColorHex
        let size = selectedSize.dimensions
        let renderer = UIGraphicsImageRenderer(size: size)
        let image = renderer.image { context in
            UIColor(hex: hex).setFill()
            context.fill(CGRect(origin: .zero, size: size))
        }

        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        saveState = .success
        HapticManager.success()
    }

    func resetSaveState() {
        saveState = .idle
    }
}
