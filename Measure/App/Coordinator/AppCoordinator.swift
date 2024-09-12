import UIKit
import SwiftUI
import Combine
import ApphudSDK

class AppCoordinator: Coordinator {
    let window: UIWindow
    let rootViewController: UINavigationController
    
    let hasSeenOnboarding = CurrentValueSubject<Bool, Never>(false)
    var subscriptions = Set<AnyCancellable>()
    
    @AppStorage("isStartApp") var isStartApp = true
    @AppStorage("isLaunchedBefore") var isLaunchedBefore = false
    
    init(window: UIWindow) {
        self.window = window
        rootViewController = UINavigationController()
        rootViewController.setViewControllers([], animated: true)
    }

    func start() {
        initRootViewControllerAndMakeKeyAndVisible()
        if isLaunchedBefore {
            if isStartApp {
                if Apphud.hasPremiumAccess() {
                    showMainViewController()
                } else {
                    showTrialViewController()
                }
            } else {
                showMainViewController()
            }
        } else {
            showOnboardingViewController()
        }
    }

    private func showMainViewController() {
        MainCoordinator(
            navigationController: rootViewController
        ).start()
    }

    private func showOnboardingViewController() {
        OnboardingCoordinator(
            navigationController: rootViewController
        ).start()
    }
    
    private func showPraparingViewController() {
        OnboardingCoordinator(
            navigationController: rootViewController
        ).preparingScreen()
    }
    
    private func showTrialViewController() {
        PaywallCoordinator(
            navigationController: rootViewController
        ).start()
    }
    
    private func initRootViewControllerAndMakeKeyAndVisible() {
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
    }
}
