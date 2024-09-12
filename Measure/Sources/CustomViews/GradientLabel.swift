//
//  GradientLabel.swift


import UIKit

final class GradientLabel: UILabel {
    
    private var colors: [UIColor] = [UIColor(hexString: "#433BA1")!, UIColor(hexString: "#2AC5DA")!]
    private var startPoint: CGPoint = .centerLeft
    private var endPoint: CGPoint = .centerRight
    private var textColorLayer: CAGradientLayer = CAGradientLayer()
    
    // MARK: - Life cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    // MARK: - Public
    
    func update(colors: [UIColor], startPoint: CGPoint, endPoint: CGPoint) {
        
        self.colors = colors
        self.startPoint = startPoint
        self.endPoint = endPoint
        applyColors()
    }
    
    // MARK: - Private functions
    
    func setup() {
        isAccessibilityElement = true
        applyColors()
    }
    
    private func applyColors() {
        let gradient = getGradientLayer(bounds: self.bounds)
        textColor = gradientColor(bounds: self.bounds, gradientLayer: gradient)
    }
    
    private func getGradientLayer(bounds: CGRect) -> CAGradientLayer {
        textColorLayer.frame = bounds
        textColorLayer.colors = colors.map{ $0.cgColor }
        textColorLayer.startPoint = startPoint
        textColorLayer.endPoint = endPoint
        return textColorLayer
    }
}

extension UIView {
    func gradientColor(bounds: CGRect, gradientLayer: CAGradientLayer) -> UIColor? {
        guard !bounds.isEmpty else {
            return nil
        }
        
        UIGraphicsBeginImageContext(bounds.size)
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        gradientLayer.render(in: context)
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else {
            return nil
        }
        UIGraphicsEndImageContext()
        return UIColor(patternImage: image)
    }
}

