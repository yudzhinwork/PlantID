//
//  ChildView.swift

//
//   on 06.01.2024.
//

import UIKit

class ChildView: UIView {

    // MARK: - Outlets

    private lazy var stackImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var stackTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.dynamicColor(light: Theme.darkBlueLabelColor, dark: Theme.whiteColor)
        label.font = Fonts.regular.addFont(16)
        label.textAlignment = .center
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Initialization

    init() {
        super.init(frame: .zero)
        setupHierarchy()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    func configure(with item: ChildViewItems) {
        stackImageView.image = UIImage(named: item.image)
        stackTitleLabel.text = item.title
    }

    private func setupHierarchy() {
        addSubviews([stackImageView, stackTitleLabel])
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            stackImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackImageView.leadingAnchor.constraint(equalTo: leadingAnchor),

            stackImageView.widthAnchor.constraint(equalToConstant: 28),
            stackImageView.heightAnchor.constraint(equalToConstant: 20),

            stackTitleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackTitleLabel.leadingAnchor.constraint(equalTo: stackImageView.trailingAnchor, constant: 10)
        ])
    }
}

