//
//  Device.swift

import UIKit

struct Device {
    // Размер экрана iPhone SE
    static var isSmallScreen: Bool {
        UIScreen.main.bounds.height <= 667
    }
}
