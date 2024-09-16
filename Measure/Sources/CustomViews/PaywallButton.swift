import UIKit

final class CustomButton: UIButton {

    // MARK: - UI Elements

    private let topLabel = UILabel()
    private let bottomLabel = UILabel()
    private let checkBoxImageView = UIImageView()
    
    // Свойство для определения, выбрана ли кнопка
    var isChoosen: Bool = false {
        didSet {
            updateCheckBoxState()
        }
    }

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }

    // MARK: - Setup

    private func setupViews() {
        layer.cornerRadius = 8
        clipsToBounds = true
        backgroundColor = .white
        
        topLabel.textAlignment = .left
        topLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        topLabel.textColor = UIColor(hexString: "#404A3E")

        bottomLabel.textAlignment = .left
        bottomLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        bottomLabel.textColor = UIColor.red

        checkBoxImageView.contentMode = .scaleAspectFit

        // Добавляем элементы на кнопку
        addSubview(topLabel)
        addSubview(bottomLabel)
        addSubview(checkBoxImageView)
        
        // Устанавливаем Auto Layout для элементов
        topLabel.translatesAutoresizingMaskIntoConstraints = false
        bottomLabel.translatesAutoresizingMaskIntoConstraints = false
        checkBoxImageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            // TopLabel сверху, левая часть
            topLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            topLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            topLabel.trailingAnchor.constraint(lessThanOrEqualTo: checkBoxImageView.leadingAnchor, constant: -8),

            // BottomLabel снизу, левая часть
            bottomLabel.topAnchor.constraint(equalTo: topLabel.bottomAnchor, constant: 4),
            bottomLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            bottomLabel.trailingAnchor.constraint(lessThanOrEqualTo: checkBoxImageView.leadingAnchor, constant: -8),
            bottomLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),

            // CheckBox справа по центру вертикали
            checkBoxImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            checkBoxImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            checkBoxImageView.widthAnchor.constraint(equalToConstant: 24),
            checkBoxImageView.heightAnchor.constraint(equalToConstant: 24)
        ])

        // Настраиваем начальное состояние чекбокса
        updateCheckBoxState()
    }

    // MARK: - Public Methods

    func configure(topText: String, price: String, periodText: String, period: String, isChosen: Bool) {
        topLabel.text = topText
        
        let attributedText = createAttributedString(price: price, periodText: periodText, period: period)
        bottomLabel.attributedText = attributedText
        
        self.isChoosen = isChosen
    }

    // MARK: - Private Methods

    private func createAttributedString(price: String, periodText: String, period: String) -> NSAttributedString {
        let fullText = NSMutableAttributedString()
        
        let regularAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 14, weight: .medium),
            .foregroundColor: UIColor(hexString: "#8F9A8C")!
        ]
        let priceAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 14, weight: .heavy),
            .foregroundColor: UIColor(hexString: "#4AA151")!
        ]
        
        let yearlyText = NSAttributedString(string: "\(period) ", attributes: regularAttributes)
        fullText.append(yearlyText)
        
        let priceText = NSAttributedString(string: price, attributes: priceAttributes)
        fullText.append(priceText)
        
        let period = NSAttributedString(string: " / \(periodText)", attributes: regularAttributes)
        fullText.append(period)
        
        return fullText
    }

    // Обновляем изображение чекбокса и обводку в зависимости от выбранного состояния
    private func updateCheckBoxState() {
        let checkBoxImage = isChoosen ? UIImage(named: "Paywall-Checked") : UIImage(named: "Paywall-Unchecked")
        checkBoxImageView.image = checkBoxImage

        // Устанавливаем обводку в зависимости от состояния кнопки
        if isChoosen {
            layer.borderColor = UIColor(hexString: "#D4D7C9")?.cgColor // Обводка активной кнопки
            layer.borderWidth = 1.0
        } else {
            layer.borderColor = UIColor(hexString: "#8F9A8C")?.withAlphaComponent(0.1).cgColor // Обводка неактивной кнопки
            layer.borderWidth = 1.0
        }
    }
}
