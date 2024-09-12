//
//  BaseViewController.swift


import UIKit
import SafariServices

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        setupNavigationBar()
    }
    
    func openURL(_ urlString: String) {
        if let url = URL(string: urlString) {
            let safariVC = SFSafariViewController(url: url)
            present(safariVC, animated: true, completion: nil)
        }
    }
}

// MARK: - Private

private extension BaseViewController {
    
    func configure() {
        view.backgroundColor = UIColor(hexString: "#FCFFFA")
    }
    
    func setupNavigationBar() {
        let color = UIColor(hexString: "#404A3E")
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: color
        ]
        navigationController?.navigationBar.tintColor = color
    }

}
