//
//  SettingsItems.swift

import Foundation

struct SettingsItems: Hashable {
    var image: String
    var title: String
}

extension SettingsItems {
    static let itemsArray = [
        SettingsItems(image: "notifications-icon", title: "Notifications"),
        SettingsItems(image: "support-icon", title: "Support"),
        SettingsItems(image: "privacy-icon", title: "Privacy Policy"),
        SettingsItems(image: "terms-icon", title: "Terms of Use")
    ]
}
