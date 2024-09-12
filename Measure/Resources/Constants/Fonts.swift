//
//  Fonts.swift

//
//   on 04.01.2024.
//

import UIKit

enum Fonts: String {
    case thin = "SFProDisplay-ThinItalic"
    case regular = "SFProDisplay-Regular"
    case ultraLight = "SFProDisplay-UltraLightItalic"
    case light = "SFProDisplay-LightItalic"
    case medium = "SFProDisplay-Medium"
    case semibold = "SFProDisplay-SemiBoldItalic"
    case bold = "SFProDisplay-Bold"
    case heavy = "SFProDisplay-HeavyItalic"

    func addFont(_ size: CGFloat) -> UIFont {
        UIFont(name: rawValue, size: size) ?? UIFont()
    }
}
