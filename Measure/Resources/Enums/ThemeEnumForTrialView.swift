//
//  ThemeEnum.swift

//
//   on 12.01.2024.
//

import UIKit

enum ThemeEnumForTrialView {
    case light
    case dark
    case gradient
}

extension ThemeEnumForTrialView {
    var backgroundColor: UIColor {
        switch self {
        case .light:
            return Theme.whiteColor
        case .dark:
            return .black
        case .gradient:
            let gradient = CAGradientLayer()
            gradient.frame = UIScreen.main.bounds
            gradient.colors = Theme.gradientColor.map { $0.cgColor }
            gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
            return UIColor(patternImage: Theme.image(fromLayer: gradient))
        }
    }

    var titleLabelColor: UIColor {
        switch self {
        case .light:
            return Theme.perpleColor
        case .dark:
            return .white
        case .gradient:
            return Theme.whiteColor
        }
    }

    var subtitleLabelColor: UIColor {
        switch self {
        case .light:
            return Theme.lightBlueLabelColor.withAlphaComponent(0.5)
        case .dark:
            return .gray
        case .gradient:
            return Theme.whiteColor.withAlphaComponent(0.5)
        }
    }

    var buttonBackgroundColor: UIColor {
        switch self {
        case .light, .dark:
            let gradient = CAGradientLayer()
            gradient.colors = Theme.gradientColor.map { $0.cgColor }
            gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
            gradient.frame = CGRect(x: 0, y: 0, width: 130, height: 50)
            return UIColor(patternImage: Theme.image(fromLayer: gradient))
        case .gradient:
            return Theme.whiteColor
        }
    }

    var buttonTitleColor: UIColor {
        switch self {
        case .light:
            return Theme.whiteColor
        case .dark:
            return .purple
        case .gradient:
            return Theme.perpleColor
        }
    }
}
