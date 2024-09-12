import UIKit

enum ScannerType: Int {
    case identify
    case diagnose
}

@objc protocol ScannerFirstViewControllerDelegate: AnyObject {
    func scannerFirstViewController(_ controller: ScannerFirstViewController, scannerType type: Int)
}

class ScannerFirstViewController: BaseViewController {

    private var blurEffectView: UIVisualEffectView!
    private var scannerType: ScannerType = .identify
    
    weak var delegate: ScannerFirstViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        setupBlurEffect()
    }

    private func setupBlurEffect() {
        let blurEffect = UIBlurEffect(style: .dark)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.backgroundColor = .clear
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)
        view.sendSubviewToBack(blurEffectView)
    }
    
    @objc func identifyAction(_ sender: UIButton) {
        scannerType = .identify
        delegate?.scannerFirstViewController(self, scannerType: ScannerType.identify.rawValue)
        dismiss(animated: true)
    }

    @objc func diagnoseAction(_ sender: UIButton) {
        scannerType = .diagnose
        delegate?.scannerFirstViewController(self, scannerType: ScannerType.diagnose.rawValue)
        dismiss(animated: true)
    }
}
