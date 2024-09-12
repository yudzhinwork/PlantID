import UIKit
import SwiftUI
import UserNotifications

@main // Analytics initialization lives here
class AppDelegate: UIResponder, UIApplicationDelegate {
    @AppStorage("isStartApp") var isStartApp = true
    var window: UIWindow?
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [
            UIApplication.LaunchOptionsKey: Any
        ]?
    ) -> Bool {
        window?.overrideUserInterfaceStyle = .light
        requestNotificationAuthorization()
        
        RealmController.shared.setup()
        PremiumManager.shared.setup()
        PremiumManager.shared.collectProducts()
        return true
    }
    
    func requestNotificationAuthorization() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Permission granted")
            } else {
                print("Permission denied")
            }
        }
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func onConversionDataFail(_ error: Error) {}
    
    func applicationWillTerminate(_ application: UIApplication) {
        isStartApp = true
    }
}
