//
//  OnboardingButton.swift


import UIKit

final class OnboardingButton: UIButton {
    
    // MARK: -
    
    private let topLabel = UILabel()
    private let bottomLabel = UILabel()
    
    // MARK: -
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    // MARK: - Public
    
    func setupWithTitle(_ title: String, subtitle: String) {
        self.topLabel.text = title
        self.bottomLabel.text = subtitle
    }
    
    // MARK: - Private
    
    private func setupViews() {
        
        layer.cornerRadius = 12
        clipsToBounds = true
        layer.borderWidth = 1
        layer.borderColor = UIColor.dynamicColor(
            light: Theme.blackColor.withAlphaComponent(0.2),
            dark: Theme.whiteColor.withAlphaComponent(0.2)
        ).cgColor
        topLabel.font = Fonts.medium.addFont(24)
        bottomLabel.font = Fonts.regular.addFont(14)
        
        addSubview(topLabel)
        addSubview(bottomLabel)
        
        for view in [topLabel, bottomLabel] {
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            topLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            topLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            bottomLabel.topAnchor.constraint(equalTo: topLabel.bottomAnchor, constant: 2),
            bottomLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])
        
        topLabel.textColor = UIColor.dynamicColor(
            light: Theme.blackColor,
            dark: Theme.whiteColor
        )
        bottomLabel.textColor = UIColor.dynamicColor(
            light: Theme.blackColor.withAlphaComponent(0.5),
            dark: Theme.whiteColor.withAlphaComponent(0.5)
        )
    }
}
