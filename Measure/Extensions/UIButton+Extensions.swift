//
//  UIButton+Extensions.swift

//
//  Created by  on 13.06.2024.
//

import UIKit

extension UIButton {
    
    func applyGradientToText(_ colors: [UIColor]) {
        guard let titleLabel = self.titleLabel, let title = titleLabel.text else {
            return
        }
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors.map { $0.cgColor }
        gradientLayer.startPoint = .centerLeft
        gradientLayer.endPoint = .centerRight
        
        UIGraphicsBeginImageContext(titleLabel.frame.size)
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        gradientLayer.frame = titleLabel.bounds
        gradientLayer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        self.setTitleColor(UIColor(patternImage: image!), for: .normal)
    }
}
