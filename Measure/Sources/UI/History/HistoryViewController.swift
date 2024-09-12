//
//  HistoryViewController.swift


import UIKit
import CoreData
import RealmSwift

final class HistoryViewController: BaseViewController {
    
    // MARK: - UI
    
    private lazy var backButton: UIButton = {
        let button = IncreasedTapAreaButton(type: .system)
        button.setImage(UIImage(named: "NavigationButton-Back"), for: .normal)
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var historyTableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.register(UINib(nibName: "HistoryCell", bundle: nil), forCellReuseIdentifier: HistoryCell.identifier)
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "History"
        label.font = Fonts.bold.addFont(24)
        label.textColor = UIColor(hexString: "#404A3E")
        label.textAlignment = .left
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var emptyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "MyGarden-Empty")
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var emptyTopLabel: UILabel = {
        let label = UILabel()
        label.text = "Your history is empty"
        label.font = Fonts.bold.addFont(24)
        label.textColor = UIColor(hexString: "#404A3E")
        label.textAlignment = .left
        label.numberOfLines = 1
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Properties
    
    private var historyData: Results<ScanHistoryRealm>?
    
    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchData()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
}

// MARK: - Private

private extension HistoryViewController {
    
    func configure() {
        view.addSubviews([titleLabel, historyTableView, emptyImageView, emptyTopLabel])
        setupConstraints()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            
            historyTableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            historyTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            historyTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            historyTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            emptyImageView.bottomAnchor.constraint(equalTo: emptyTopLabel.topAnchor, constant: -80),
            emptyImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            emptyTopLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyTopLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -180),
        ])
    }
    
    func fetchData() {
        let realm = try! Realm()
        historyData = realm.objects(ScanHistoryRealm.self).sorted(byKeyPath: "scanDate", ascending: false)
        historyTableView.reloadData()
        updateEmptyDataLabelVisibility()
    }
    
    func deleteObjectAt(_ indexPath: IndexPath) {
        guard let objectToDelete = historyData?[indexPath.section] else { return }
        
        let realm = try! Realm()
        do {
            try realm.write {
                realm.delete(objectToDelete)
            }
            historyTableView.deleteSections([indexPath.section], with: .fade)
            updateEmptyDataLabelVisibility()
        } catch {
            print("Failed to delete history data: \(error)")
        }
    }
    
    func updateEmptyDataLabelVisibility() {
        let isEmpty = historyData?.isEmpty ?? true
        emptyImageView.isHidden = !isEmpty
        emptyTopLabel.isHidden = !isEmpty
    }
    
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - UITableViewDelegate

extension HistoryViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "") { (action, view, completionHandler) in
            self.deleteObjectAt(indexPath)
            completionHandler(true)
        }
        deleteAction.backgroundColor = UIColor(hexString: "#FCFFFA")
        deleteAction.image = UIImage(named: "History-Remove")
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let historyItem = historyData?[indexPath.section] else { return }
                
        // Найдем объект PlantIdentificationResponse по ID из истории
        let realm = try! Realm()
        if let plant = realm.object(ofType: PlantIdentificationResponse.self, forPrimaryKey: historyItem.id) {
            
            let type = ScannerType(rawValue: historyItem.scanType)
            
            if type == .identify {
                let vc = ScannerResultViewController()
                vc.result = plant
                vc.scannerType = .identify
                vc.image = UIImage(data: historyItem.imageData!)
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                if let plantHealth = realm.object(ofType: PlantIdentificationResponse.self, forPrimaryKey: historyItem.id) {
                    if let plantResponse = realm.object(ofType: PlantResponse.self, forPrimaryKey: historyItem.relatedObjectId) {
                        if plantResponse.healthAssessment!.isHealthy {
                            let vc = ScannerPlantIsHealthyController()
                            self.navigationController?.pushViewController(vc, animated: true)
                        } else {
                            let vc = ScannerResultViewController()
                            vc.resultHealty = plantResponse
                            vc.result = plantHealth
                            vc.scannerType = .diagnose
                            vc.image = UIImage(data: historyItem.imageData!)
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                    }
                }
            }

        } else {
            print("PlantIdentificationResponse with id \(historyItem.id) not found")
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 24
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = .clear
        return footerView
    }
}

// MARK: - UITableViewDataSource

extension HistoryViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return historyData?.count ?? 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let historyCell = tableView.dequeueReusableCell(withIdentifier: HistoryCell.identifier, for: indexPath) as! HistoryCell
        if let historyItem = historyData?[indexPath.section] {
            historyCell.fill(historyItem)
        }
        return historyCell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteObjectAt(indexPath)
        }
    }
}

// MARK: - HistoryDetailViewControllerDelegate

extension HistoryViewController: HistoryDataViewControllerDelegate {
    func didUpdateHistory() {
        fetchData()
    }
}
