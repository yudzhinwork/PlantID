//
//  HistoryDataViewController.swift

//
//  Created by  on 11.08.2024.
//

import UIKit
import AlertKit

protocol HistoryDataViewControllerDelegate: AnyObject {
    func didUpdateHistory()
}

enum ResultType {
    case measure
    case history
}

final class HistoryDataViewController: BaseViewController {
    
    // MARK: - UI
    
    private lazy var backButton: UIButton = {
        let button = IncreasedTapAreaButton()
        button.setImage(
            UIImage(named: "NavigationButton-Back"),
            for: .normal
        )
        button.addTarget(
            self,
            action: #selector(backButtonTapped),
            for: .touchUpInside
        )
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let measureImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 24
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.backgroundColor = .red
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private var buttonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 96
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let saveButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Result-Save")!, for: .normal)
        button.addTarget(HistoryDataViewController.self, action: #selector(saveAction), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let shareButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Result-Share")!, for: .normal)
        button.addTarget(HistoryDataViewController.self, action: #selector(shareAction), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
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
    
    // MARK: - Properties
    
    weak var delegate: HistoryDataViewControllerDelegate?
    var resultType: ResultType = .measure
    
    private var historyData: History?
    private var image: UIImage!
    private var date: Date!
    private var comment = ""
    
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM.dd.yy 'at' hh:mm a"
        return formatter
    }()
    
    // MARK: - Life cycle
    
    init(image: UIImage, date: Date, comment: String = "") {
        self.image = image
        self.date = date
        self.comment = comment
        super.init(nibName: nil, bundle: nil)
    }
    
    init?(historyData: History) {
        guard let image = UIImage(data: historyData.image!),
              let date = historyData.date,
              let comment = historyData.comment else {
                return nil
              }
        self.historyData = historyData
        self.image = image
        self.date = date
        self.comment = comment
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(notification:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(notification:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - Private

private extension HistoryDataViewController {
    
    func configure() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            customView: backButton
        )
        setupHierarchy()
        setupConstraints()
        commentTextField.delegate = self
        commentTextField.addTarget(self, action: #selector(commentTextChanged), for: .editingChanged)
        if resultType == .history {
            if let historyData = historyData {
                measureImageView.image = UIImage(data: historyData.image!)
                commentTextField.text = historyData.comment
            }
        } else if resultType == .measure {
            measureImageView.image = image
            commentTextField.text = comment
        }
    }
    
    func setupHierarchy() {
        [shareButton, saveButton].forEach { button in
            buttonsStackView.addArrangedSubview(button)
        }
        view.addSubviews([measureImageView,
                          buttonsStackView,
                          commentTextField])
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            measureImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 48),
            measureImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -48),
            measureImageView.bottomAnchor.constraint(equalTo: buttonsStackView.topAnchor, constant: -24),
            measureImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            
            buttonsStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonsStackView.bottomAnchor.constraint(equalTo: commentTextField.topAnchor, constant: -24),
            
            commentTextField.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            commentTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            commentTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            commentTextField.heightAnchor.constraint(equalToConstant: 52),
        ])
    }
    
    @objc func shareAction() {
        guard let image = image else {
            return
        }
        let date = dateFormatter.string(from: date ?? Date())
        let activityViewController = UIActivityViewController(activityItems: [date, comment, image], applicationActivities: nil)
        activityViewController.excludedActivityTypes = [.addToReadingList, .assignToContact, .saveToCameraRoll]
        present(activityViewController, animated: true, completion: nil)
    }
    
    @objc func saveAction() {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        
        if resultType == .history {
            historyData!.comment = commentTextField.text
        } else {
            let newHistory = History(context: context)
            newHistory.comment = commentTextField.text
            newHistory.date = date
            if let imageData = image.jpegData(compressionQuality: 1.0) {
                newHistory.image = imageData
            }
        }
        
        do {
            try context.save()
            delegate?.didUpdateHistory()
            
            AlertKitAPI.present(
                title: "Measure has saved to history",
                style: .iOS17AppleMusic,
                haptic: .success
            )
        } catch {
            print("Failed to save measurement: \(error.localizedDescription)")
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.navigationController?.popViewController(animated: true)
        }
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
    
    @objc func commentTextChanged(_ textField: UITextField) {
        self.comment = textField.text ?? ""
//        saveHistoryData()
    }
    
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardHeight = keyboardFrame.cgRectValue.height
            
            UIView.animate(withDuration: 0.3) {
                self.view.transform = CGAffineTransform(translationX: 0, y: -keyboardHeight)
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.3) {
            self.view.transform = .identity
        }
    }
}

extension HistoryDataViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
