//

//
//   on 07.01.2024.
//

import UIKit
import AVFoundation

class MeasureIdeasCell: UICollectionViewCell {
    // MARK: - Outlets
    private var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.whiteColor
        view.layer.cornerRadius = 34
        view.clipsToBounds = true
        let gradient = CAGradientLayer()
        gradient.frame = UIScreen.main.bounds
        gradient.colors = Theme.gradientColor.map { $0.cgColor }
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 0.2, y: 0.5)
        view.backgroundColor = UIColor(
            patternImage: Theme.image(
                fromLayer: gradient
            )
        )
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var image: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.layer.cornerRadius = 34
        imageView.clipsToBounds = true
        imageView.layer.borderColor = UIColor.dynamicColor(
            light: Theme.whiteColor,
            dark: Theme.blackColor
        ).cgColor
        imageView.layer.borderWidth = 2
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
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
        containerView.addSubview(image)
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            image.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 2),
            image.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 2),
            image.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -2),
            image.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -2)
        ])
    }

    // MARK: - Configuration
    func configuration(item: MainViewItems) {
        self.image.image = UIImage(
            named: item.image ?? ""
        ) ?? UIImage()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.image.image = nil
    }
}
