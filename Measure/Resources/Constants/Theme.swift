//
//  Theme.swift

//
//   on 04.01.2024.
//

import UIKit

struct Theme {

    static var backgroundColor: UIColor = UIColor(hexString: "#EBEBEB")!
    static var darkBlueLabelColor: UIColor = UIColor(hexString: "#161822")!
    static var perpleColor: UIColor = UIColor(hexString: "#433BA1")!
    static var lightBlueLabelColor: UIColor = UIColor(hexString: "#1C5794")!
    static var whiteColor: UIColor = UIColor(hexString: "#FFFFFF")!
    static var blackColor: UIColor = UIColor(hexString: "#000000")!
    static var grayColor: UIColor = UIColor(hexString: "#999999")!
    static var darkGrayColor: UIColor = UIColor(hexString: "#202020")!
    static var cyanColor: UIColor = UIColor(hexString: "#2DB8D5")!
    static var yellowColor: UIColor = UIColor(hexString: "#F3A325")!
    static var gradientColor: [UIColor] = [UIColor(hexString: "#2DFF75")!, UIColor(hexString: "#12AD5C")!]
    static var cornflowerBlue: UIColor = UIColor(hexString: "#1C5794")!
    static var altoColor = UIColor(hexString: "#D9D9D9")!
    static var jumboColor = UIColor(hexString: "#787880")!
    static var simplicityColor = UIColor(hexString: "#D0D0DB")!
    
    static func buttonStyle(_ button: UIButton, title: String = "") {
        button.setTitleColor(Theme.whiteColor, for: .normal)
        button.layer.cornerRadius = 12
        button.titleLabel?.font = Fonts.bold.addFont(20)
        button.setTitle(title, for: .normal)
        button.clipsToBounds = true

        let gradient = CAGradientLayer()
        gradient.frame = CGRect(origin: .zero, size: button.bounds.size)
        gradient.colors = Theme.gradientColor.map { $0.cgColor }
        gradient.startPoint = .topCenter
        gradient.endPoint = .bottomCenter

        let renderer = UIGraphicsImageRenderer(size: gradient.bounds.size)
        let gradientImage = renderer.image { context in
            gradient.render(in: context.cgContext)
        }
        
        button.setBackgroundImage(gradientImage, for: .normal)
    }
    
    static func image(fromLayer layer: CALayer) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, layer.isOpaque, 0.0)
        guard let context = UIGraphicsGetCurrentContext() else { fatalError("Failed to get the current context") }
        layer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
        UIGraphicsEndImageContext()
        return image
    }
}
