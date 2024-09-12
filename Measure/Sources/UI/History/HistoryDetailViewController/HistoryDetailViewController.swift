//
//  HistoryDetailViewController.swift



import UIKit

protocol HistoryDetailViewControllerDelegate: AnyObject {
    func didUpdateHistory()
}

final class HistoryDetailViewController: UIViewController {
    
    // MARK: - UI
    
    private let shareButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "share")!, for: .normal)
        button.addTarget(self, action: #selector(share), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let measureImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 16
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let linePageView: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.grayColor.withAlphaComponent(0.3)
        view.layer.cornerRadius = 2.5
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let resultTextField: UITextField = {
        let textField = UITextField()
        textField.textColor = UIColor.dynamicColor(light: Theme.perpleColor, dark: Theme.cyanColor)
        textField.font = Fonts.bold.addFont(48)
        textField.placeholder = "Title..."
        textField.returnKeyType = .done
        textField.textAlignment = .center
        textField.isUserInteractionEnabled = false
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let commentTextField: UITextField = {
        let textField = UITextField()
        textField.textColor = UIColor.dynamicColor(light: Theme.perpleColor, dark: Theme.cyanColor)
        textField.font = Fonts.regular.addFont(16)
        textField.placeholder = "Comment..."
        textField.textAlignment = .left
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.textColor = UIColor.dynamicColor(light: Theme.blackColor, dark: Theme.whiteColor)
        textField.layer.borderColor = UIColor.dynamicColor(light: Theme.blackColor.withAlphaComponent(0.24),
                                                           dark: Theme.whiteColor.withAlphaComponent(0.24)).cgColor
        textField.layer.borderWidth = 1.0
        textField.layer.cornerRadius = 12.0
        textField.returnKeyType = .done
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        return textField
    }()
    
    private let measuredDateLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.dynamicColor(light: Theme.darkBlueLabelColor, dark: Theme.whiteColor)
        label.font = Fonts.bold.addFont(18)
        label.textAlignment = .center
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let totalLenghtLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.dynamicColor(
            light: Theme.darkBlueLabelColor.withAlphaComponent(0.5),
            dark: Theme.whiteColor.withAlphaComponent(0.5)
        )
        label.font = Fonts.medium.addFont(16)
        label.textAlignment = .center
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK - Properties
    
    var historyData: History!
    
    weak var delegate: HistoryDetailViewControllerDelegate?
    
    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
}

// MARK: - Private

private extension HistoryDetailViewController {
    
    func configure() {
        setupHierarchy()
        setupLayout()
        resultTextField.delegate = self
        commentTextField.delegate = self
        commentTextField.addTarget(self, action: #selector(commentTextChanged), for: .editingChanged)
        measureImageView.image = UIImage(data: historyData.image!)
        commentTextField.text = historyData.comment
    }
    
    func setupHierarchy() {
        view.addSubviews([linePageView, 
                          measureImageView,
                          shareButton,
                          resultTextField,
                          measuredDateLabel,
                          totalLenghtLabel, 
                          commentTextField])
    }
    
    func setupLayout() {
        view.layer.cornerRadius = 24
        view.backgroundColor = UIColor.dynamicColor(light: Theme.whiteColor, dark: Theme.blackColor)
        
        NSLayoutConstraint.activate([
            
            linePageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 5),
            linePageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            linePageView.heightAnchor.constraint(equalToConstant: 5),
            linePageView.widthAnchor.constraint(equalToConstant: 36),
            
            measureImageView.topAnchor.constraint(equalTo: linePageView.bottomAnchor, constant: 16),
            measureImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            measureImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            measureImageView.heightAnchor.constraint(equalToConstant: view.frame.size.height - 362),
            
            shareButton.topAnchor.constraint(equalTo: measureImageView.topAnchor, constant: 16),
            shareButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            shareButton.heightAnchor.constraint(equalToConstant: 44),
            shareButton.widthAnchor.constraint(equalToConstant: 48),
            
            resultTextField.topAnchor.constraint(equalTo: measureImageView.bottomAnchor, constant: 32),
            resultTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            resultTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            resultTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            measuredDateLabel.topAnchor.constraint(equalTo: resultTextField.bottomAnchor, constant: 6),
            measuredDateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            totalLenghtLabel.topAnchor.constraint(equalTo: measuredDateLabel.bottomAnchor, constant: 6),
            totalLenghtLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            commentTextField.topAnchor.constraint(equalTo: totalLenghtLabel.bottomAnchor, constant: 32),
            commentTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            commentTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            commentTextField.heightAnchor.constraint(equalToConstant: 52),
        ])
    }
}

// MARK: - Private

private extension HistoryDetailViewController {
    
    @objc func share() {
        guard let image = UIImage(data: historyData.image!) else {
            return
        }
        let comment = historyData.comment ?? ""
        let activityViewController = UIActivityViewController(activityItems: [image, title, comment], applicationActivities: nil)
        activityViewController.excludedActivityTypes = [.addToReadingList, .assignToContact, .saveToCameraRoll]
        present(activityViewController, animated: true, completion: nil)
    }
    
    @objc func commentTextChanged(_ textField: UITextField) {
        historyData.comment = textField.text
        saveHistoryData()
    }
    
    func saveHistoryData() {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        do {
            delegate?.didUpdateHistory()
            try context.save()
        } catch {
            print("Failed to save comment: \(error)")
        }
    }
}

// MARK: - UITextFieldDelegate

extension HistoryDetailViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
