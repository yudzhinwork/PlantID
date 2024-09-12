//
//  ScannerPlantIsHealthyController.swift
//  PlantID

import UIKit

class ScannerPlantIsHealthyController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.popToRootViewController(animated: true)
    }

}
