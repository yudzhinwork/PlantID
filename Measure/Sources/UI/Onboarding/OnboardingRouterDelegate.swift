//
//  OnboardingDelegate.swift

//
//   on 04.01.2024.
//

import Foundation

protocol OnboardingRouterDelegate: AnyObject {
    func routeToTrialView()
    func routeToPreparing()
    func routeToMainView()
}
