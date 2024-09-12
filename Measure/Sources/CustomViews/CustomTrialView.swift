//
//  CustomTrialView.swift

import UIKit

protocol CustomTrialViewDelegate: AnyObject {
    func premiumButtonTapped()
}

class CustomTrialView: UIView {

    weak var delegate: CustomTrialViewDelegate?

    // MARK: - Properties

    private var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "PRO")
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private var proIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ProIcon")
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var verticalStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .leading
        stack.distribution = .equalSpacing
        stack.spacing = 2
        stack.backgroundColor = .clear
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.addArrangedSubview(titleLabel)
        stack.addArrangedSubview(subtitleLabel)
        return stack
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Upgrade PRO".uppercased()
        label.font = Fonts.bold.addFont(22)
        label.textAlignment = .left
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Take care your plants"
        label.font = Fonts.medium.addFont(16)
        label.textAlignment = .left
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private(set) lazy var customButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .clear
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(premiumButtonTapped), for: .touchUpInside)
        return button
    }()

    init(theme: ThemeEnumForTrialView) {
        super.init(frame: .zero)
        setupUI(theme: theme)
        setupHierarchy()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI(theme: ThemeEnumForTrialView) {
        titleLabel.textColor = Theme.whiteColor
        subtitleLabel.textColor = Theme.whiteColor
    }
    
    private func setupHierarchy() {
        addSubview(backgroundImageView)
        addSubview(proIconImageView)
        addSubview(verticalStack)
        addSubview(customButton)
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            proIconImageView.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            proIconImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),

            verticalStack.centerYAnchor.constraint(equalTo: centerYAnchor),
            verticalStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            customButton.topAnchor.constraint(equalTo: topAnchor),
            customButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            customButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            customButton.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }

    // MARK: - Actions

    @objc func premiumButtonTapped() {
        delegate?.premiumButtonTapped()
    }
    
    
}
