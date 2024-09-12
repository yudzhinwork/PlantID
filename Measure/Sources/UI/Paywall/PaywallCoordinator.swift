import UIKit

class PaywallCoordinator: Coordinator {
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let vc = PaywallViewController()
        navigationController.setViewControllers(
            [vc], animated: false
        )
    }
}

extension PaywallCoordinator: PaywallRouterDelegate {
    func routeToMainView() {
        MainCoordinator(
            navigationController: navigationController
        ).start()
    }
}
