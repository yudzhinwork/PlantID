enum AnalyticEvent: String {
    case purchase, failedPurchase
    case restorePurchase, failedRestorePurchase
    case qrScanned, qrCreated
    case paywallShowed, paywallClosed
    case internalError
    case cantSendMail
    case cantSetUniqueID
}
