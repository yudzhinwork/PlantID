//
//  SettingsCoordinator.swift

//
//   on 09.01.2024.
//

import UIKit

class SettingsCoordinator: Coordinator {

    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let vc = SettingsViewController()

        vc.delegateRouting = self
        vc.viewModel = SettingsViewModel()
        navigationController.pushViewController(vc, animated: false)
    }
}

// MARK: - SettingsRoutingDelegate

extension SettingsCoordinator: SettingsRouterDelegate {
    
}
