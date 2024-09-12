//
//  ChildViewItems.swift

//
//   on 06.01.2024.
//

import Foundation

struct ChildViewItems: Hashable {
    let image: String
    let title: String
}

extension ChildViewItems {
    static let itemsArray = [
        ChildViewItems(image: "check-icon", title: "Check sizes fast and accurately"),
        ChildViewItems(image: "arrows-icon", title: "Measure anything and anywhere"),
        ChildViewItems(image: "mesure-icon", title: "Get digital ruler in your pocket"),
        ChildViewItems(image: "Paywall-BubbleLevel", title: "Use as a bubble level")
    ]
}
