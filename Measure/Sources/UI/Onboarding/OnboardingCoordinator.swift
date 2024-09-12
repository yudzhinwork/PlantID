//
//  OnboardingCoordinator.swift

//
//   on 04.01.2024.
//

import UIKit

class OnboardingCoordinator: Coordinator {

    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let vc = OnboardingFirstViewController()
        vc.delegateRouting = self
        vc.viewModel = OnboardingViewModel()
        navigationController.isNavigationBarHidden = true
        navigationController.setViewControllers([vc], animated: false)
    }
    
    func preparingScreen() {
        let vc = OnboardingViewController()
        vc.delegateRouting = self
        vc.viewModel = OnboardingViewModel()
        navigationController.setViewControllers([vc], animated: false)
    }
}

// MARK: - OnboardingRoutingDelegate

extension OnboardingCoordinator: OnboardingRouterDelegate {
    func routeToTrialView() {
        PaywallCoordinator(navigationController: navigationController).start()
    }
    
    func routeToPreparing() {
        OnboardingCoordinator.init(navigationController: navigationController).preparingScreen()
    }

    func routeToMainView() {
        MainCoordinator(navigationController: navigationController).start()
    }
}
