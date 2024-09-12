//
//  OnboardingItems.swift

//
//   on 04.01.2024.
//

import Foundation

struct OnboardingItems: Hashable {
    let image: String
    let pageImage: String
    let title: String
    let description: String
}

extension OnboardingItems {
    static let itemsArray = [
        OnboardingItems(
            image: "cow",
            pageImage: "page1",
            title: "Measure anything\n you want",
            description: "Check size, shop smarter,\n or just satisfy your curiosity"
        ),
        OnboardingItems(
            image: "windTurbine",
            pageImage: "page2",
            title: "Take measurements\n wherever you go",
            description: "Use highly accurate digital\n ruler anywhere, anytime"
        ),
        OnboardingItems(
            image: "compoundMicroscope",
            pageImage: "page3",
            title: "Get accurate result\n in seconds",
            description: "Trust AI measuring for precise,\n fast and easy results"
        ),
        OnboardingItems(
            image: "Intro-bubleLevelAndRuler",
            pageImage: "page4",
            title: "Discover \n more features!",
            description: "Our app includes a ruler and a spirit level \nfor your convenience"
        )
    ]
}
