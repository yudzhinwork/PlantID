//
//  SettingsHeader.swift

//
//   on 11.01.2024.
//

import UIKit

class SettingsHeader: UITableViewHeaderFooterView {

    //MARK: - Outlets

    private var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .light)
        label.textColor = UIColor.dynamicColor(light: Theme.grayColor, dark: Theme.whiteColor.withAlphaComponent(0.3))
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Initializers

    override init(reuseIdentifier reuseIndentifier: String?) {
        super.init(reuseIdentifier: reuseIndentifier)
        setupHierarchy()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setupHierarchy() {
        contentView.addSubview(titleLabel)
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -7)
        ])
    }

    func configure(with title: String) {
        titleLabel.text = title
    }
}
