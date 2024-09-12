//
//  HowToUseCell.swift

//
//   on 07.01.2024.
//

import UIKit

class HowToUseCell: UICollectionViewCell {
    // MARK: - Outlets
    private var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.dynamicColor(
            light: Theme.whiteColor,
            dark: Theme.darkGrayColor
        )
        view.layer.cornerRadius = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let image: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.dynamicColor(
            light: Theme.darkBlueLabelColor,
            dark: Theme.whiteColor
        )
        let fontSize = UIDevice.current.name.contains("SE") ? 16.0 : 18.0
        label.font = Fonts.medium.addFont(fontSize)
        label.textAlignment = .left
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private var subtitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.dynamicColor(
            light: Theme.darkBlueLabelColor.withAlphaComponent(0.5),
            dark: Theme.whiteColor.withAlphaComponent(0.5)
        )
        let fontSize = UIDevice.current.name.contains("SE") ? 14.0 : 16.0
        label.font = Fonts.regular.addFont(fontSize)
        label.textAlignment = .left
        label.numberOfLines = 3
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHierarchy()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup
    private func setupHierarchy() {
        contentView.addSubview(containerView)
        containerView.addSubviews([
            image, titleLabel, subtitleLabel
        ])
    }

    private func setupLayout() {
        
        let imageHeightMultiplier = UIDevice.current.name.contains("SE") ? 0.37 : 0.47
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            image.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            image.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            image.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            image.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: imageHeightMultiplier),

            titleLabel.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),

            titleLabel.heightAnchor.constraint(equalToConstant: 21),

            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6),
            subtitleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            subtitleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16)
        ])
    }

    // MARK: - Configuration
    func configuration(item: MainViewItems) {
        self.image.image = UIImage(
            named: item.image ?? ""
        )
        self.titleLabel.text = item.title
        self.subtitleLabel.text = item.subtitle
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.image.image = nil
    }
}
