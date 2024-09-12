//
//  ScannerResultViewController.swift
//  PlantID

import UIKit
import RealmSwift

class ScannerResultViewController: BaseViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var addToGardenButton: UIButton!
    
    var result: PlantIdentificationResponse!
    var resultHealty: PlantResponse!
    var image: UIImage!
    var scannerType: ScannerType = .identify
    
    var plantToSaving: PlantIdentificationResponse!

    override func viewDidLoad() {
        super.viewDidLoad()
                
        let backButton = UIBarButtonItem(image: UIImage(named: "chevron-left")!, style: .plain, target: self, action: #selector(backButtonTapped))
        navigationItem.leftBarButtonItem = backButton
        title = result.suggestions.first!.plantName

        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 300
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(UINib(nibName: "ScannerResultCell", bundle: nil), forCellReuseIdentifier: "ScannerResultCell")
        tableView.register(UINib(nibName: "ScannerResultNotHealthyCell", bundle: nil), forCellReuseIdentifier: "ScannerResultNotHealthyCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        if let tabBarController = self.tabBarController {
            tabBarController.tabBar.isHidden = true
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let tabBarController = self.tabBarController {
            tabBarController.tabBar.isHidden = false
        }
    }
    
    @IBAction func addToGarden(_ sender: UIButton) {
        if let existingResponse = mainRealm.object(ofType: PlantIdentificationResponse.self, forPrimaryKey: result.id) {
            try? mainRealm.write {
                existingResponse.isAddedToGarden = true
            }
            tabBarController?.selectedIndex = 0
            return
        }
        saveToDatabase(result)
        navigationController?.popToRootViewController(animated: true)
        tabBarController?.selectedIndex = 0
    }
    
    func saveToDatabase(_ response: PlantIdentificationResponse) {
        response.isAddedToGarden = true
        guard let imageData = image.jpegData(compressionQuality: 0.8) else { return }
        response.localImageData = imageData
        realmWrite {
            mainRealm.add(response, update: .modified)
        }
    }
    
    @objc func backButtonTapped() {
        navigationController?.popToRootViewController(animated: true)
    }

}

extension ScannerResultViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if scannerType == .identify {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ScannerResultCell", for: indexPath) as! ScannerResultCell
            let text = result.suggestions.first?.plantDetails?.wikiDescription?.value ?? ""
            cell.fill(image, text: text)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ScannerResultNotHealthyCell", for: indexPath) as! ScannerResultNotHealthyCell
            cell.fill(image, response: resultHealty)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
}
