//
//  MainCellHeader.swift

//
//   on 07.01.2024.
//

import UIKit

class MainCellHeader: UICollectionReusableView {

    // MARK: - Outlets

    private var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.dynamicColor(light: Theme.lightBlueLabelColor, dark: Theme.cyanColor)
        label.font = Fonts.medium.addFont(16)
        label.textAlignment = .left
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        setupHierarchy()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    func configure(title: String) {
        titleLabel.text = title
    }

    private func setupHierarchy() {
        addSubview(titleLabel)
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor)
        ])
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
    }
}
