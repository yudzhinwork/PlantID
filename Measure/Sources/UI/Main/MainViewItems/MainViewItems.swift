import UIKit

struct MainViewItems: Hashable {
    var image: String?
    var video: String?
    let title: String
    var subtitle: String?
    var thumbnailImage: UIImage?

    static let itemsArray = [
        [
            MainViewItems(image: "plane", video: "plane-video", title: "Plane"),
            MainViewItems(image: "flower", video: "flower-video", title: "Flower"),
            MainViewItems(image: "room", video: "room-video", title: "Room"),
            MainViewItems(image: "dog", video: "dog-video", title: "Dog"),
            MainViewItems(image: "computer", video: "computer-video", title: "Computer"),
            MainViewItems(image: "grape", video: "grape-video", title: "Grape"),
            MainViewItems(image: "building", video: "building-video", title: "Building"),
            MainViewItems(image: "bag", video: "bag-video", title: "Bag"),
            MainViewItems(image: "human", video: "human-video", title: "Human")
        ],
        [
            MainViewItems(
                image: "measure",
                title: "Measure anything",
                subtitle: "Measure objects with ease. Shop smarter, DIY better, and just satisfy your curiosity!"
            ),
            MainViewItems(
                image: "three",
                title: "Measure whenever you want",
                subtitle: "The digital ruler is always in your pocket, wherever you go."
            ),
            MainViewItems(
                image: "paywall",
                title: "Get precise measurements",
                subtitle: "Always! Our app guarantees accuracy and reliability. No more guesswork!")
        ]
    ]
}
