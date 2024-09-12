//
//  MyGardenRemoveViewController.swift
//  PlantID

import UIKit

@objc protocol MyGardenRemoveViewControllerDelegate: AnyObject {
    func myGardenRemoveViewControllerDelet(_ controller: MyGardenRemoveViewController, at indexPath: IndexPath)
}

class MyGardenRemoveViewController: BaseViewController {
    
    @IBOutlet private weak var cancelButton: UIButton!
    @IBOutlet private weak var deleteButton: UIButton!
    
    weak var delegate: MyGardenRemoveViewControllerDelegate?
    var indexPath: IndexPath!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.borderColor = UIColor(hexString: "#8F9A8C")?.cgColor
        
        deleteButton.layer.borderWidth = 1
        deleteButton.layer.borderColor = UIColor(hexString: "#FF0000")?.withAlphaComponent(0.5).cgColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        UIView.animate(withDuration: 0.6) {
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        }
    }
    
    @IBAction func deleteAction() {
        self.dismiss(animated: true)
        delegate?.myGardenRemoveViewControllerDelet(self, at: indexPath)
    }
    
    @IBAction func closeAction() {
        self.dismiss(animated: true)
    }
}
