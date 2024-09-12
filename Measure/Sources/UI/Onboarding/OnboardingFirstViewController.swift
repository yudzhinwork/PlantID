//
//  OnboardingFirstViewController.swift
//  PlantID

import UIKit
import SwiftUI

final class OnboardingFirstViewController: BaseViewController {
    
    // MARK: -
    
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "onboardingFirst")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let rectangleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "ScanningRectangle")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = Theme.whiteColor
        label.font = Fonts.medium.addFont(32)
        label.textAlignment = .center
        label.text = "Identify plant"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private var subtitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = Theme.whiteColor
        label.font = Fonts.regular.addFont(18)
        label.textAlignment = .center
        label.numberOfLines = 2
        label.text = "Discover how to identify and care for \nplants from all over the world"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var skipButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "NavigationButton-Skip")!, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(skipPressed), for: .touchUpInside)
        button.tintColor = Theme.whiteColor
        return button
    }()
    
    private lazy var continueButton: UIButton = {
        let button = UIButton(type: .system)
        Theme.buttonStyle(button, title: "Continue")
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(continuePressed), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Properties
    
    var viewModel: OnboardingViewModel?
    var delegateRouting: OnboardingRouterDelegate?
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        Theme.buttonStyle(continueButton, title: "Continue")
    }

}

private extension OnboardingFirstViewController {
    
    func configure() {
        setupHierarchy()
        setupConstraints()
    }
    
    func setupHierarchy() {
        view.addSubviews([backgroundImageView,
                          skipButton,
                          rectangleImageView,
                          titleLabel,
                          subtitleLabel,
                          continueButton])
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            skipButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            skipButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            skipButton.heightAnchor.constraint(equalToConstant: 38),
            
            continueButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            continueButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            continueButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24),
            continueButton.heightAnchor.constraint(equalToConstant: 60),
            
            rectangleImageView.bottomAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -56),
            rectangleImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            titleLabel.bottomAnchor.constraint(equalTo: subtitleLabel.topAnchor, constant: -4),
            
            subtitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            subtitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            subtitleLabel.bottomAnchor.constraint(equalTo: continueButton.topAnchor, constant: -56),
        ])
    }
    
    @objc func continuePressed() {
        self.delegateRouting?.routeToPreparing()
    }
    
    @objc func skipPressed() {
        self.delegateRouting?.routeToTrialView()
    }
}
