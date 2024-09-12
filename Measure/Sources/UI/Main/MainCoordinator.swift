//
//  MainCoordinator.swift

import UIKit

fileprivate enum TabItem: Int {
    case myGarden
    case scanner
    case history
    case profile
}

class MainCoordinator: Coordinator {

    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {

        let tabBar = getTabBarContoller()
        navigationController.isNavigationBarHidden = true
        navigationController.setViewControllers([tabBar], animated: false)
    }
    
    private func getTabBarContoller() -> UITabBarController {
        let gardenViewController = MyGardenViewController()
        let gardenNavigationController = UINavigationController(rootViewController: gardenViewController)
        
        let scannerViewController = ScannerViewController()
        let scannerNavigationConntroller = UINavigationController(rootViewController: scannerViewController)
        
        let historyViewController = HistoryViewController()
        let historyNavigationConntroller = UINavigationController(rootViewController: historyViewController)
        
        gardenNavigationController.tabBarItem = UITabBarItem(title: "My garden",
                                                  image: UIImage(named: "TabBar-MyGarden"),
                                                  selectedImage: UIImage(named: "TabBar-MyGarden"))
        gardenNavigationController.tabBarItem.tag = TabItem.myGarden.rawValue
        
        scannerNavigationConntroller.tabBarItem = UITabBarItem(title: "Scanner",
                                                  image: UIImage(named: "TabBar-Scanner"),
                                                  selectedImage: UIImage(named: "TabBar-Scanner"))
        scannerNavigationConntroller.tabBarItem.tag = TabItem.scanner.rawValue
        
        historyNavigationConntroller.tabBarItem = UITabBarItem(title: "History",
                                                            image: UIImage(named: "TabBar-History"),
                                                            selectedImage: UIImage(named: "TabBar-History"))
        historyNavigationConntroller.tabBarItem.tag = TabItem.history.rawValue
        
        let profileViewController = SettingsViewController()
        profileViewController.tabBarItem = UITabBarItem(title: "Profile",
                                                            image: UIImage(named: "TabBar-Profile"),
                                                            selectedImage: UIImage(named: "TabBar-Profile"))
        let profileNavigationConntroller = UINavigationController(rootViewController: profileViewController)
        profileNavigationConntroller.tabBarItem.tag = TabItem.profile.rawValue
        
        let tabBarController = CustomTabBarController()
        
        tabBarController.viewControllers = [gardenNavigationController,
                                            scannerNavigationConntroller,
                                            historyNavigationConntroller,
                                            profileNavigationConntroller]
        
        tabBarController.tabBar.unselectedItemTintColor = UIColor.dynamicColor(
            light: UIColor(hexString: "#8F9A8C")!,
            dark: UIColor(hexString: "#8F9A8C")!
        )
        
        tabBarController.tabBar.tintColor = UIColor.dynamicColor(
            light: UIColor(hexString: "#12AD5C")!,
            dark: UIColor(hexString: "#12AD5C")!
        )
        
        tabBarController.mainCoordinator = self
        
        return tabBarController
    }
    
    func showRulerScreen() {
        let rulerViewController = UIViewController()
        navigationController.pushViewController(rulerViewController, animated: true)
    }
    
    func showBubbleLevelScreen() {
        let bubbleLevelViewController = UIViewController()
        navigationController.pushViewController(bubbleLevelViewController, animated: true)
    }
}

// MARK: - OnboardingRoutingDelegate

extension MainCoordinator: MainRouterDelegate {
    func routeToSettings() {
        SettingsCoordinator(navigationController: navigationController).start()
    }

    func routeToCamera() {
        CameraCoordinator(navigationController: navigationController).start()
    }
    
    func routeToTrial() {
        PaywallCoordinator(navigationController: navigationController).start()
    }
}

final class CustomTabBarController: UITabBarController, UITabBarControllerDelegate {

    var mainCoordinator: MainCoordinator?
    private var previousIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground() // Устанавливаем непрозрачный фон
        appearance.backgroundColor = .white // Устанавливаем белый фон
        
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard let mainCoordinator = mainCoordinator,
        let tabItem = TabItem(rawValue: item.tag) else { return }
        switch tabItem {
        case .scanner:
            selectedIndex = tabItem.rawValue
        default:
            previousIndex = selectedIndex
        }
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if let _ = viewControllers?.firstIndex(of: viewController) {
            previousIndex = selectedIndex
        }
        if let navController = viewController as? UINavigationController {
              if navController.viewControllers.count > 1 {
                  navController.popToRootViewController(animated: false)
              }
        }
        return true
     }
}
