import UIKit

class CameraCoordinator: Coordinator {

    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
//        let vc = AreaViewController()
//        vc.delegateRouting = self
//        
//        navigationController.pushViewController(
//            vc, animated: false
//        )
    }
}

// MARK: - CameraRoutingDelegate

extension CameraCoordinator: CameraRouterDelegate {
    func routeToTrial() {
        PaywallCoordinator(navigationController: navigationController).start()
    }
}
