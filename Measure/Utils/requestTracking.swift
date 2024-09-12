import AppTrackingTransparency

func requestTracking(completion: @escaping () -> Void) {
    ATTrackingManager.requestTrackingAuthorization(
        completionHandler: { status in
            switch status {
            case .authorized:
                // Tracking authorization dialog was shown
                // and we are authorized
                print("ATTrackingManager: Authorized")
            case .denied:
                // Tracking authorization dialog was
                // shown and permission is denied
                print("ATTrackingManager: Denied")
            case .notDetermined:
                // Tracking authorization dialog has not been shown
                print("ATTrackingManager: Not Determined")
            case .restricted:
                print("ATTrackingManager: Restricted")
            @unknown default:
                print("ATTrackingManager: Unknown")
            }
            DispatchQueue.main.async {
                print("ATTrackingManager: completion call")
                completion()
            }
        }
    )
}
