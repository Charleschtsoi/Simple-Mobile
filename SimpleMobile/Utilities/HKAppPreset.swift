import Foundation

struct HKAppPreset: Identifiable, Hashable {
    let id: String
    let labelEN: String
    let labelZH: String
    let launchMode: LaunchMode
    let urlScheme: String?
    let suggestedShortcutName: String
    let shortcutsAppName: String

    func localizedLabel(locale: Locale = .current) -> String {
        if locale.identifier.hasPrefix("zh") {
            return labelZH
        }
        return labelEN
    }

    static let all: [HKAppPreset] = [
        HKAppPreset(
            id: "kmb",
            labelEN: "KMB",
            labelZH: "九巴",
            launchMode: .shortcutOnly,
            urlScheme: nil,
            suggestedShortcutName: "Open KMB",
            shortcutsAppName: "App1933 - KMB ‧ LWB"
        ),
        HKAppPreset(
            id: "mtr",
            labelEN: "MTR Mobile",
            labelZH: "MTR Mobile",
            launchMode: .shortcutOnly,
            urlScheme: nil,
            suggestedShortcutName: "Open MTR",
            shortcutsAppName: "MTR Mobile"
        ),
        HKAppPreset(
            id: "octopus",
            labelEN: "Octopus",
            labelZH: "八達通",
            launchMode: .shortcutOnly,
            urlScheme: nil,
            suggestedShortcutName: "Open Octopus",
            shortcutsAppName: "Octopus"
        ),
        HKAppPreset(
            id: "mytransport",
            labelEN: "MyTransport.HK",
            labelZH: "我的運輸",
            launchMode: .shortcutOnly,
            urlScheme: nil,
            suggestedShortcutName: "Open MyTransport",
            shortcutsAppName: "MyTransport.HK"
        ),
        HKAppPreset(
            id: "citymapper",
            labelEN: "Citymapper",
            labelZH: "Citymapper",
            launchMode: .urlScheme,
            urlScheme: "citymapper://",
            suggestedShortcutName: "",
            shortcutsAppName: "Citymapper"
        ),
        HKAppPreset(
            id: "payme",
            labelEN: "PayMe",
            labelZH: "PayMe",
            launchMode: .urlScheme,
            urlScheme: "payme://",
            suggestedShortcutName: "",
            shortcutsAppName: "PayMe"
        ),
        HKAppPreset(
            id: "alipayhk",
            labelEN: "AlipayHK",
            labelZH: "支付寶HK",
            launchMode: .urlScheme,
            urlScheme: "alipayhk://",
            suggestedShortcutName: "",
            shortcutsAppName: "AlipayHK"
        ),
        HKAppPreset(
            id: "uber",
            labelEN: "Uber",
            labelZH: "Uber",
            launchMode: .urlScheme,
            urlScheme: "uber://",
            suggestedShortcutName: "",
            shortcutsAppName: "Uber"
        ),
        HKAppPreset(
            id: "openrice",
            labelEN: "OpenRice",
            labelZH: "OpenRice",
            launchMode: .urlScheme,
            urlScheme: "openrice://",
            suggestedShortcutName: "",
            shortcutsAppName: "OpenRice"
        ),
        HKAppPreset(
            id: "foodpanda",
            labelEN: "foodpanda",
            labelZH: "foodpanda",
            launchMode: .urlScheme,
            urlScheme: "foodpanda://",
            suggestedShortcutName: "",
            shortcutsAppName: "foodpanda"
        ),
        HKAppPreset(
            id: "deliveroo",
            labelEN: "Deliveroo",
            labelZH: "Deliveroo",
            launchMode: .urlScheme,
            urlScheme: "deliveroo://",
            suggestedShortcutName: "",
            shortcutsAppName: "Deliveroo"
        ),
        HKAppPreset(
            id: "hktvmall",
            labelEN: "HKTVmall",
            labelZH: "HKTVmall",
            launchMode: .urlScheme,
            urlScheme: "hktvmall://",
            suggestedShortcutName: "",
            shortcutsAppName: "HKTVmall"
        )
    ]

    static func preset(withID id: String) -> HKAppPreset? {
        all.first { $0.id == id }
    }
}
