//
//  MyGardenViewController.swift
//  PlantID


import UIKit
import RealmSwift

final class MyGardenViewController: BaseViewController {
    
    private lazy var myGardenTableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.register(UINib(nibName: "MyGardenCell", bundle: nil), forCellReuseIdentifier: "MyGardenCell")
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "My garden"
        label.textColor = UIColor(hexString: "#404A3E")
        label.font = Fonts.bold.addFont(24)
        label.textAlignment = .left
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private(set) lazy var addButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .clear
        button.setImage(UIImage(named: "MyGarden-Add"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        return button
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
        label.text = "Your garden is empty"
        label.font = Fonts.bold.addFont(24)
        label.textColor = UIColor(hexString: "#404A3E")
        label.textAlignment = .left
        label.numberOfLines = 1
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var emptyBottomLabel: UILabel = {
        let label = UILabel()
        label.text = "Add your first plant to growing \nyour garden"
        label.font = Fonts.medium.addFont(18)
        label.textColor = UIColor(hexString: "#8F9A8C")
        label.textAlignment = .left
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var plantResponses: Results<PlantIdentificationResponse>?
    private var notificationToken: NotificationToken?
    
    fileprivate var isEmpty = true {
        didSet {
            myGardenTableView.reloadData()
            updateEmptyStateVisibility()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        updateAllPlantsFlag()
    }
    
    private func fetchPlantIdentificationResponses() {
        plantResponses = mainRealm.objects(PlantIdentificationResponse.self).filter("isAddedToGarden == true")
            .sorted(byKeyPath: "scanDate", ascending: false)
        isEmpty = plantResponses?.isEmpty ?? true
        myGardenTableView.reloadData()
    }
    
    private func updateAllPlantsFlag() {
        guard let plants = plantResponses else { return }
        do {
            try mainRealm.write {
                for plant in plants {
                    plant.isNewPlant = false
                }
            }
        } catch {
            print("Error updating plants: \(error.localizedDescription)")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        fetchPlantIdentificationResponses()
    }
}

private extension MyGardenViewController {
    
    func configure() {
        view.addSubviews([myGardenTableView, titleLabel, addButton, 
                          emptyImageView, emptyTopLabel, emptyBottomLabel])
        setupConstraints()
        updateEmptyStateVisibility()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            
            addButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            addButton.heightAnchor.constraint(equalToConstant: 32),
            addButton.widthAnchor.constraint(equalToConstant: 32),
            
            myGardenTableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            myGardenTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            myGardenTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            myGardenTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            emptyImageView.bottomAnchor.constraint(equalTo: emptyTopLabel.topAnchor, constant: -80),
            emptyImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            emptyTopLabel.bottomAnchor.constraint(equalTo: emptyBottomLabel.topAnchor, constant: -24),
            emptyTopLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            emptyBottomLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -114),
            emptyBottomLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

        ])
    }

    func updateEmptyStateVisibility() {
        let shouldShowEmptyState = isEmpty
        emptyImageView.isHidden = !shouldShowEmptyState
        emptyTopLabel.isHidden = !shouldShowEmptyState
        emptyBottomLabel.isHidden = !shouldShowEmptyState
        myGardenTableView.isHidden = shouldShowEmptyState
    }
    
    @objc func addButtonTapped() {
        tabBarController?.selectedIndex = 1
    }
}

// MARK: - UITableViewDelegate

extension MyGardenViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let obj = plantResponses?[indexPath.row] {
            let vc = ScannerResultViewController()
            vc.result = obj
            vc.scannerType = .identify
            vc.image = UIImage(data: obj.localImageData!)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 361
    }
}

// MARK: - UITableViewDataSource

extension MyGardenViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return plantResponses?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let myGardenCell = tableView.dequeueReusableCell(withIdentifier: "MyGardenCell", for: indexPath) as! MyGardenCell
        myGardenCell.delegate = self
        myGardenCell.configure()
        if let obj = plantResponses?[indexPath.row] {
            myGardenCell.fill(obj)
        }
        return myGardenCell
    }
}

extension MyGardenViewController: MyGardenRemoveViewControllerDelegate {
    
    func myGardenRemoveViewControllerDelet(_ controller: MyGardenRemoveViewController, at indexPath: IndexPath) {
        guard let plantToDelete = plantResponses?[indexPath.row] else {
            return
        }        
        do {
            try mainRealm.write {
                mainRealm.delete(plantToDelete)
            }
            myGardenTableView.deleteRows(at: [indexPath], with: .automatic)
        } catch {
            print("Error deleting plant: \(error.localizedDescription)")
        }
        isEmpty = plantResponses?.isEmpty ?? true
    }
}


// MARK: - MyGardenCellDelegate

extension MyGardenViewController: MyGardenCellDelegate {
    
    func myGardenCellRemove(_ myGardenCell: MyGardenCell) {
        let vc = MyGardenRemoveViewController()
        vc.delegate = self
        vc.indexPath = myGardenTableView.indexPath(for: myGardenCell)
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true)
    }
    
    func myGardenCellWatering(_ myGardenCell: MyGardenCell) {
        let vc = DataPickerViewController()
        vc.pickerType = .watering
        vc.indexPath = myGardenTableView.indexPath(for: myGardenCell)
        vc.delegate = self
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true)
    }
    
    func myGardenCellSpraying(_ myGardenCell: MyGardenCell) {
        let vc = DataPickerViewController()
        vc.indexPath = myGardenTableView.indexPath(for: myGardenCell)
        vc.pickerType = .spraying
        vc.delegate = self
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true)
    }
    
    func myGardenCellWFertilize(_ myGardenCell: MyGardenCell) {
        let vc = DataPickerViewController()
        vc.indexPath = myGardenTableView.indexPath(for: myGardenCell)
        vc.pickerType = .fertilize
        vc.delegate = self
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true)
    }
}

extension MyGardenViewController: DataPickerDelegate {
    func didSelectDate(_ controller: DataPickerViewController, date: Date, pickerType: DatePickerType) {
        guard let plant = plantResponses?[controller.indexPath.row] else {
            return
        }
            
        do {
            try mainRealm.write {
                switch pickerType {
                case .watering:
                    plant.wateringDate = date  // Обновляем дату полива
                case .spraying:
                    plant.sprayingDate = date  // Обновляем дату опрыскивания
                case .fertilize:
                    plant.fertilizeDate = date  // Обновляем дату удобрения
                case .time:
                    break
                }
            }
            myGardenTableView.reloadRows(at: [controller.indexPath], with: .automatic)
        } catch {
            print("Ошибка при обновлении даты: \(error.localizedDescription)")
        }
    }
}

