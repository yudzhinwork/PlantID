//import Foundation
//import Adapty
//import SwiftUI
//import AlertKit
//
//let kUserIsPremium = "userIsPremiumKey"
//let WEEKLY_PRICE = 6.99
//let MONTHLY_PRICE = 17.99
//let ANNUAL_PRICE = 49.99
//
//enum ProductType {
//    case week
//    case annual
//    case month
//}
//
//fileprivate struct Constants {
//    static let placementID = "placementYearMonthWeek"
//    static let defaultErrorText = "Purchase are canceled or we cannot provide you with the product (check your internet connection or try later please)"
//}
//
//final class PremiumManager: ObservableObject {
//    static let shared = PremiumManager()
//    
//    var weeklyProduct: AdaptyPaywallProduct?
//    var annualProduct: AdaptyPaywallProduct?
//    var monthProduct: AdaptyPaywallProduct?
//    
//    @AppStorage("weeklyPrice") private var weeklyPrice = "$\(WEEKLY_PRICE)"
//    @AppStorage("annualPrice") private var annualPrice = "$\(ANNUAL_PRICE)"
//    @AppStorage("monthPrice") private var monthPrice = "$\(MONTHLY_PRICE)"
//    
//    @Published var weeklyPricePublished = "\(WEEKLY_PRICE)"
//    @Published var annualPricePublished = "\(ANNUAL_PRICE)"
//    @Published var monthPricePublished = "\(MONTHLY_PRICE)"
//    @Published var isUserPremium: Bool {
//        didSet {
//            UserDefaults.standard.set(isUserPremium, forKey: kUserIsPremium)
//        }
//    }
//    
//    private init() {
//        self.isUserPremium = UserDefaults.standard.bool(forKey: kUserIsPremium)
//        self.weeklyPricePublished = self.weeklyPrice
//        self.annualPricePublished = self.annualPrice
//        self.monthPricePublished = self.monthPrice
//    }
//        
//    private func updatePrice(
//        appStoragePrice: inout String,
//        publishedPirce: inout String,
//        actualPrice: String?
//    ) {
//        if actualPrice != nil {
//            appStoragePrice = actualPrice!
//            publishedPirce = actualPrice!
//        }
//    }
//    
//    // MARK: - Public
//    
//    func collectProducts() {
//        print("--SubscriptionManager: collectProducts()")
//        syncPremiumFromAdapty()
//        Adapty.getPaywall(placementId: Constants.placementID, locale: "en") { result in
//            switch result {
//            case .success(let paywall):
//                Adapty.getPaywallProducts(paywall: paywall) { result in
//                    switch result {
//                    case let .success(products):
//                        if products.count == 3 {
//                            self.weeklyProduct = products[0]
//                            self.updatePrice(
//                                appStoragePrice: &self.weeklyPrice,
//                                publishedPirce: &self.weeklyPricePublished,
//                                actualPrice: self.weeklyProduct?.localizedPrice
//                            )
//                            
//                            self.monthProduct = products[1]
//                            self.updatePrice(
//                                appStoragePrice: &self.monthPrice,
//                                publishedPirce: &self.monthPricePublished,
//                                actualPrice: self.monthProduct?.localizedPrice
//                            )
//                            
//                            self.annualProduct = products[2]
//                            self.updatePrice(
//                                appStoragePrice: &self.annualPrice,
//                                publishedPirce: &self.annualPricePublished,
//                                actualPrice: self.annualProduct?.localizedPrice
//                            )
//                        }
//
//                    case .failure(let error):
//                        AppDelegate.sendEvent(
//                            event: .internalError,
//                            parameters: [
//                                "description": error.debugDescription
//                            ]
//                        )
//                    }
//                }
//            case .failure(let error):
//                AppDelegate.sendEvent(
//                    event: .internalError,
//                    parameters: [
//                        "description": error.debugDescription
//                    ]
//                )
//            }
//        }
//    }
//    
//    func syncPremiumFromAdapty() {
//        Adapty.getProfile { result in
//            if let profile = try? result.get(),
//                   profile.accessLevels["premium"]?.isActive ?? false {
//                self.isUserPremium = true
//            } else {
//                // TODO: Change to false, to user not be premium
//                self.isUserPremium = true
//            }
//        }
//    }
//    
//    func subscribe(type: ProductType, action: @escaping () -> (), errorAction: @escaping (String) -> () ) {
//        print("--SubscriptionManager: subscribe()")
//        if weeklyProduct == nil || annualProduct == nil || monthProduct == nil {
//            collectProducts()
//        }
//        let product = switch type {
//            case .week: weeklyProduct
//            case .annual: annualProduct
//            case .month: monthProduct
//        }
//        guard let product = product else {
//            AppDelegate.sendEvent(
//                event: .internalError,
//                parameters: [
//                    "description": Constants.defaultErrorText
//                ]
//            )
//            AlertKitAPI.present(
//                title: Constants.defaultErrorText,
//                icon: .error,
//                style: .iOS17AppleMusic,
//                haptic: .error
//            )
//            errorAction(Constants.defaultErrorText)
//            return
//        }
//        Adapty.makePurchase(product: product) { result in
//            switch result {
//            case .success(let info):
//                if info.profile.accessLevels["premium"]?.isActive ?? false {
//                    AppDelegate.sendEvent(event: .purchase)
//                    AlertKitAPI.present(
//                        title: "Subscription is successful",
//                        icon: .done,
//                        style: .iOS17AppleMusic,
//                        haptic: .success
//                    )
//                    self.isUserPremium = true
//                    action()
//                } else {
//                    AppDelegate.sendEvent(
//                        event: .failedPurchase,
//                        parameters: ["info": "\(info)"]
//                    )
//                    AlertKitAPI.present(
//                        title: "Seems like you subscribe, but we cannot handle it (try to re-launch app and tap restore purchase)",
//                        icon: .error,
//                        style: .iOS17AppleMusic,
//                        haptic: .error
//                    )
//                    errorAction("Seems like you subscribe, but we cannot handle it (try to re-launch app and tap restore purchase)")
//                    self.isUserPremium = false
//                }
//
//            case .failure(let error):
//                AppDelegate.sendEvent(
//                    event: .internalError,
//                    parameters: [
//                        "description": error.debugDescription
//                    ]
//                )
//                AlertKitAPI.present(
//                    title: Constants.defaultErrorText,
//                    icon: .error,
//                    style: .iOS17AppleMusic,
//                    haptic: .error
//                )
//                errorAction(Constants.defaultErrorText)
//            }
//        }
//    }
//    
//    func restore(action: @escaping () -> (), errorAction: @escaping (String) -> ()) {
//        print("--SubscriptionManager: restore()")
//        Adapty.restorePurchases { result in
//            switch result {
//            case .success(let profile):
//                if profile.accessLevels["premium"]?.isActive ?? false {
//                    AppDelegate.sendEvent(event: .restorePurchase)
//                        AlertKitAPI.present(
//                            title: "Restored",
//                            icon: .done,
//                            style: .iOS17AppleMusic,
//                            haptic: .success
//                        )
//                        self.isUserPremium = true
//                        action()
//                    } else {
//                        AppDelegate.sendEvent(event: .failedRestorePurchase)
//                        AlertKitAPI.present(
//                            title: "Nothing to restore",
//                            icon: .error,
//                            style: .iOS17AppleMusic,
//                            haptic: .error
//                        )
//                        self.isUserPremium = false
//                        errorAction("Nothing to restore")
//                    }
//            case .failure(let error):
//                AppDelegate.sendEvent(
//                    event: .internalError,
//                    parameters: [
//                        "description": error.debugDescription
//                    ]
//                )
//                AlertKitAPI.present(
//                    title: Constants.defaultErrorText,
//                    icon: .error,
//                    style: .iOS17AppleMusic,
//                    haptic: .error
//                )
//                errorAction(Constants.defaultErrorText)
//            }
//        }
//    }
//}

import ApphudSDK
import SwiftUI
import StoreKit

//annual.s
//weekly.s

final class PremiumManager {
    
    static let shared = PremiumManager()
    
    @Published var weeklyPrice = "$6.99"
    @Published var annuallyPrice = "$49.99"
    
    static var weeklyProduct: ApphudProduct?
    static var annuallyProduct: ApphudProduct?
    
    @MainActor func setup() {
        Apphud.start(apiKey: "app_BpHKoAdFjBJttxsY84QPRKd3Mx7Wqh")
    }
    
    @MainActor func collectProducts() {
        Task {
            let products = try await Apphud.fetchProducts()
            products.forEach { product in
                let p = Apphud.apphudProductFor(product)
                switch product.id {
                case "annual.s":
                    PremiumManager.annuallyProduct = p
                    PremiumManager.shared.annuallyPrice = product.displayPrice
                case "weekly.s":
                    PremiumManager.weeklyProduct = p
                    PremiumManager.shared.weeklyPrice = product.displayPrice
                default:
                    break
                }
            }
        }
    }
}

extension SKProduct {
    func localizedPrice() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = self.priceLocale
        return formatter.string(from: self.price) ?? ""
    }
}
