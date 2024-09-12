//
//  UIColor+Extensions.swift

//
//   on 04.01.2024.
//

import UIKit
import CoreGraphics

// For custom colors
extension UIColor {
    convenience init?(hexString: String) {
        var start: String.Index

        if hexString.hasPrefix("#") {
            start = hexString.index(hexString.startIndex, offsetBy: 1)
        }else{
            start = hexString.startIndex
        }
        let hexColor = hexString.substring(from: start)

        let hex = hexColor.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            return nil
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}

// For Dinamic theme colors
extension UIColor {
    static func dynamicColor(light: UIColor, dark: UIColor) -> UIColor {
        if #available(iOS 13.0, *) {
            return UIColor { (trait) -> UIColor in
                return trait.userInterfaceStyle == .light ? light : dark
            }
        } else {
            return light
        }
    }
}
