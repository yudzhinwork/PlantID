//
//  TabsControl.swift


import Foundation
import UIKit

@objc protocol TabsControlDelegate: AnyObject {
    func tabsControl(_ tabsControl: TabsControl, didSelectTabAtIndex index: Int)
}

final class TabsControl: UIView {
    
    // MARK: -
    private var gradientLayers: [CAGradientLayer] = []
    
    private var buttons: [UIButton] = []
    
    private var buttonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.layoutMargins = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        stackView.isLayoutMarginsRelativeArrangement = true
        
        return stackView
    }()
    
    private var selectionIndicatorView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 7
        view.backgroundColor = .red
        return view
    }()
    
    // MARK: - Private Properties
    
    fileprivate var previewIndex: Int = 0
    
    fileprivate var selectedTabIndex: Int = 0 {
        didSet {
            delegate?.tabsControl(self, didSelectTabAtIndex: selectedTabIndex)
        }
    }
    
    // MARK: -
    
    init(titles: [String]) {
        super.init(frame: .zero)
        setupView(titles)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateGradientLayers()
    }
    
    // MARK: - Public Properties
    
    weak var delegate: TabsControlDelegate?
    
    var numberOfSegments: Int {
        return buttons.count
    }
    
    // MARK: - Public Functions
    
    func setSelectedTabIndex(_ index: Int, animated: Bool = true) {
        
        previewIndex = selectedTabIndex
        selectedTabIndex = index
        
        if animated {
            UIView.animate(withDuration: 0.25) { [weak self] in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.updateButtonColors()
                strongSelf.layoutIfNeeded()
            }
        }
    }
}

// MARK: - Private

private extension TabsControl {
    
    func setupView(_ titles: [String]) {
        backgroundColor = UIColor.dynamicColor(
            light: Theme.blackColor.withAlphaComponent(0.08),
            dark: Theme.whiteColor.withAlphaComponent(0.08)
        )
        layer.cornerRadius = 9
        
        addSubviews([selectionIndicatorView, buttonsStackView])
        
        NSLayoutConstraint.activate([
            buttonsStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            buttonsStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            buttonsStackView.topAnchor.constraint(equalTo: topAnchor),
            buttonsStackView.heightAnchor.constraint(equalToConstant: 32),
        ])
    
        titles.enumerated().forEach { index, title in
            let button = createButton(with: title, tag: index)
            buttons.append(button)
            buttonsStackView.addArrangedSubview(button)
        }
    }
    
    func updateGradientLayers() {
        gradientLayers.forEach { gradientLayer in
            gradientLayer.frame = gradientLayer.superlayer!.bounds
        }
    }
    
    func updateButtonColors() {
       buttons.enumerated().forEach { index, button in
           if index == selectedTabIndex {
               let textColor = UIColor.dynamicColor(
                   light: Theme.whiteColor,
                   dark: Theme.blackColor
               )
               button.setTitleColor(textColor, for: .normal)
               button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
               gradientLayers[index].isHidden = false
           } else {
               let textColor = UIColor.dynamicColor(
                   light: Theme.blackColor.withAlphaComponent(0.7),
                   dark: Theme.whiteColor.withAlphaComponent(0.7)
               )
               button.setTitleColor(textColor, for: .normal)
               button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
               gradientLayers[index].isHidden = true
           }
       }
    }

    @objc func buttonAction(_ button: UIButton) {
        guard let index = buttons.firstIndex(of: button) else {
            return
        }
        setSelectedTabIndex(index, animated: true)
    }
    
    func createButton(with title: String, tag: Int) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.titleLabel?.numberOfLines = 1
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.setTitleColor(Theme.blackColor, for: .normal)
        button.isExclusiveTouch = true
        button.tag = tag
        button.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = Theme.gradientColor.map { $0.cgColor }
        gradientLayer.startPoint = .centerLeft
        gradientLayer.endPoint = .centerRight
        gradientLayer.frame = button.bounds
        gradientLayer.cornerRadius = 7
        button.layer.insertSublayer(gradientLayer, at: 0)
        gradientLayer.isHidden = true
        gradientLayers.append(gradientLayer)
        
        return button
    }
    
}
