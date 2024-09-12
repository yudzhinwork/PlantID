import UIKit

final class ChecklistCollectionViewCell: UICollectionViewCell {
    
    // MARK: - UI
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // MARK: - Life cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private
    
    private func setupUI() {
        contentView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 48),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0)
        ])
    }
    
    // MARK: - Configuration
    
    func configure(with items: [(UIImage, String)]) {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for (image, text) in items {
            let itemStackView = UIStackView()
            itemStackView.axis = .horizontal
            itemStackView.spacing = 12
            itemStackView.alignment = .center
            
            let imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFit
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.widthAnchor.constraint(equalToConstant: 28).isActive = true
            imageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
            
            let label = UILabel()
            label.text = text
            label.font = Fonts.regular.addFont(16)
            label.textColor = UIColor.dynamicColor(
                light: Theme.blackColor,
                dark: Theme.whiteColor
            )
            label.translatesAutoresizingMaskIntoConstraints = false
            
            itemStackView.addArrangedSubview(imageView)
            itemStackView.addArrangedSubview(label)
            
            stackView.addArrangedSubview(itemStackView)
        }
    }
}
