//
//  ScannerNotFoundViewController.swift
//  PlantID

import UIKit

class ScannerNotFoundViewController: BaseViewController {
    
    @IBOutlet private weak var againButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Scanner"
    }
    
    @IBAction func retryAction(_ sender: UIButton) {
        tabBarController?.selectedIndex = 1
        
//        if let navController = tabBarController?.viewControllers?[1] as? UINavigationController {
//            navController.popToRootViewController(animated: true)
//        }
//        let scannerViewController = storyboard.instantiateViewController(withIdentifier: "ScannerViewController") as! ScannerViewController
         
         // Устанавливаем ScannerViewController как корневой контроллер
        navigationController!.setViewControllers([ScannerViewController()], animated: true)
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
    
}
