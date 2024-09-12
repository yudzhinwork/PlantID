//
//  ShadowView.swift
//  PlantID

import UIKit

class ShadowViewItem: UIView {
    
    override var bounds: CGRect {
        didSet {
            setupShadow()
        }
    }
    
    private func setupShadow() {
        self.layer.cornerRadius = 12
        self.layer.shadowOffset = CGSize(width: 0, height: 5)
        self.layer.shadowRadius = 16
        self.layer.shadowColor = UIColor(hexString: "#D4D7C9")!.withAlphaComponent(0.5).cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        self.layer.masksToBounds = false
        self.layer.rasterizationScale = UIScreen.main.scale
    }
}
