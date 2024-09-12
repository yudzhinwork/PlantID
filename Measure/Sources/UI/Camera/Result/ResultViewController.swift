//
//  ResultViewController.swift

//
//   on 19.01.2024.
//

import UIKit
import SwiftUI

class ResultViewController: UIViewController {

    // MARK: - Properties

    private var distanceInInches: String = ""
    private var distanceInCm: String = ""
    private var image: UIImage!
    @AppStorage("timesMeasured") var timesMeasured = 0
    
    init(distanceInInches: String, distanceInCm: String, image: UIImage) {
        self.distanceInInches = distanceInInches
        self.distanceInCm = distanceInCm
        self.image = image
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Outlets

    private let linePageView: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.grayColor.withAlphaComponent(0.3)
        view.layer.cornerRadius = 2.5
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let resultInLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.dynamicColor(light: Theme.perpleColor, dark: Theme.cyanColor)
        label.font = Fonts.bold.addFont(48)
        label.textAlignment = .center
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let resultTextField: UITextField = {
        let textField = UITextField()
        textField.textColor = UIColor.dynamicColor(light: Theme.perpleColor, dark: Theme.cyanColor)
        textField.font = Fonts.bold.addFont(48)
        textField.placeholder = "Title..."
        textField.returnKeyType = .done
        textField.textAlignment = .center
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
    
    private let completeLabel: UILabel = {
        let label = UILabel()
        label.text = "Measure complete"
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

    private lazy var measureAgainButton: UIButton = {
        let button = UIButton(type: .system)
        Theme.buttonStyle(button, title: "Measure Again")
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(measureAgainButtonPressed), for: .touchUpInside)
        return button
    }()
    
    private lazy var saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "saveMeasurement"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(saveAction), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupHierarchy()
        setupLayout()
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        view.layer.cornerRadius = 24
        view.backgroundColor = UIColor.dynamicColor(light: Theme.whiteColor, dark: Theme.blackColor)
        resultTextField.delegate = self
        commentTextField.delegate = self
        resultTextField.text = distanceInInches + " in"
        totalLenghtLabel.text = "Total lenght is " + distanceInInches + " in or " + distanceInCm
    }
    
    private func setupHierarchy() {
        view.addSubviews([linePageView, resultTextField, completeLabel, totalLenghtLabel, commentTextField, saveButton, measureAgainButton])
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            linePageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 5),
            linePageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            linePageView.heightAnchor.constraint(equalToConstant: 5),
            linePageView.widthAnchor.constraint(equalToConstant: 36),
            
            resultTextField.topAnchor.constraint(equalTo: linePageView.bottomAnchor, constant: 32),
            resultTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            resultTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            resultTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            completeLabel.topAnchor.constraint(equalTo: resultTextField.bottomAnchor, constant: 32),
            completeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            totalLenghtLabel.topAnchor.constraint(equalTo: completeLabel.bottomAnchor, constant: 6),
            totalLenghtLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            commentTextField.topAnchor.constraint(equalTo: totalLenghtLabel.bottomAnchor, constant: 32),
            commentTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            commentTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            commentTextField.heightAnchor.constraint(equalToConstant: 52),
            
            saveButton.topAnchor.constraint(equalTo: commentTextField.bottomAnchor, constant: 32),
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveButton.widthAnchor.constraint(equalToConstant: 200),
            saveButton.heightAnchor.constraint(equalToConstant: 44),
            
            measureAgainButton.topAnchor.constraint(equalTo: saveButton.bottomAnchor, constant: 32),
            measureAgainButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            measureAgainButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            measureAgainButton.heightAnchor.constraint(equalToConstant: 64)
        ])
    }

    // MARK: - Actions
    
    @objc func measureAgainButtonPressed() {
        timesMeasured += 1
        dismiss(animated: true)
    }
    
    @objc func saveAction() {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        
        let newHistory = History(context: context)
        newHistory.comment = commentTextField.text
        newHistory.date = Date()
        if let imageData = image.jpegData(compressionQuality: 1.0) {
            newHistory.image = imageData
        }
        
        do {
            saveButton.setImage(UIImage(named: "saved"), for: .normal)
            try context.save()
        } catch {
            print("Failed to save measurement: \(error.localizedDescription)")
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.dismiss(animated: true)
        }
    }
}

extension ResultViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
