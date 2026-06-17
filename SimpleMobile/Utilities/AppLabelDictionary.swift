import Foundation

enum AppLabelDictionary {
    private static let labels: [String: [String: String]] = [
        "whatsapp://": ["en": "WhatsApp", "zh-HK": "WhatsApp"],
        "barcelona://": ["en": "Threads", "zh-HK": "Threads"],
        "sgnl://": ["en": "Signal", "zh-HK": "Signal"],
        "spotify://": ["en": "Spotify", "zh-HK": "Spotify"],
        "https://": ["en": "Safari", "zh-HK": "Safari"],
        "sms://": ["en": "Messages", "zh-HK": "訊息"],
        "tel://": ["en": "Phone", "zh-HK": "電話"],
        "maps://": ["en": "Maps", "zh-HK": "地圖"],
        "music://": ["en": "Music", "zh-HK": "音樂"],
        "photos-redirect://": ["en": "Photos", "zh-HK": "相片"],
        "citymapper://": ["en": "Citymapper", "zh-HK": "Citymapper"],
        "payme://": ["en": "PayMe", "zh-HK": "PayMe"],
        "alipayhk://": ["en": "AlipayHK", "zh-HK": "支付寶HK"],
        "uber://": ["en": "Uber", "zh-HK": "Uber"],
        "openrice://": ["en": "OpenRice", "zh-HK": "OpenRice"],
        "foodpanda://": ["en": "foodpanda", "zh-HK": "foodpanda"],
        "deliveroo://": ["en": "Deliveroo", "zh-HK": "Deliveroo"],
        "hktvmall://": ["en": "HKTVmall", "zh-HK": "HKTVmall"]
    ]

    static func label(for urlScheme: String, languageMode: String) -> String? {
        let normalized = URLSchemeValidator.normalize(urlScheme)
        guard let localized = labels[normalized] else { return nil }
        return localized[languageMode] ?? localized["en"]
    }

    static func applyLanguageMode(to config: inout WidgetConfig) {
        guard config.languageMode != "custom" else { return }

        for index in config.slots.indices {
            let scheme = config.slots[index].urlScheme
            if let label = label(for: scheme, languageMode: config.languageMode) {
                config.slots[index].label = label
            }
        }
    }
}
