//
//  DiscountManager.swift

//

import Foundation

//final class DiscountManager {
//    
//    static let shared = DiscountManager()
//    
//    func calculateDiscount(_ firstPrice: String, weeklyPrice: String, secondPeriod: ProductType) -> (weeklyPrice: Double, discountPercentage: Int, currencySymbolPrice: String) {
//        
//        let cleanedYearlyPriceString = firstPrice.replacingOccurrences(of: "[^0-9.,]", with: "", options: .regularExpression)
//        let cleanedWeeklyPriceString = weeklyPrice.replacingOccurrences(of: "[^0-9.,]", with: "", options: .regularExpression)
//        
//        let normalizedYearlyPriceString = cleanedYearlyPriceString.replacingOccurrences(of: ",", with: ".")
//        let normalizedWeeklyPriceString = cleanedWeeklyPriceString.replacingOccurrences(of: ",", with: ".")
//        
//        if let yearlyPrice = Double(normalizedYearlyPriceString),
//        let weeklyPrice = Double(normalizedWeeklyPriceString) {
//            let period: Double = secondPeriod == .annual ? 52.0 : 4.0 // year or month
//            let yearlyWeeklyPrice = yearlyPrice / period
//            
//            let discountPercentage = (1 - (yearlyWeeklyPrice / weeklyPrice)) * 100
//            
//            let roundedWeeklyPrice = (yearlyWeeklyPrice * 100).rounded() / 100
//            let roundedDiscountPercentage = Int(discountPercentage.rounded())
//            
//            let isCurrencySymbolLeadingPrice = PremiumManager.shared.annualPricePublished.first?.isNumber == false
//            var currencySymbolPrice = ""
//            if let annualProduct = PremiumManager.shared.annualProduct {
//                currencySymbolPrice = isCurrencySymbolLeadingPrice
//                ? "\(annualProduct.currencySymbol ?? "$") \(roundedWeeklyPrice)"
//                : "\(roundedWeeklyPrice) \(annualProduct.currencySymbol ?? "$")"
//            }
//            
//            return (roundedWeeklyPrice, roundedDiscountPercentage, currencySymbolPrice)
//        } else {
//            return (6.99, 0, "$ 6.99")
//        }
//    }
//    
//    func calculateDiscount(_ price: String, forPrice: ProductType) -> (weeklyPrice: Double, discountPercentage: Int, currencySymbolPrice: String) {
//        let cleanedWeeklyPriceString = PremiumManager.shared.weeklyPricePublished.extractNumbers()
//        let cleanedPriceString = price.extractNumbers()
//        
//        if let price = Double(cleanedPriceString),
//           let weeklyPrice = Double(cleanedWeeklyPriceString) {
//            let weekCount: Double = forPrice == .annual ? 52 : 4
//            let priceInWeek = price / weekCount
//            
//            let discountPercentage = max(0, (1 - (priceInWeek / weeklyPrice)) * 100)
//            let roundedWeeklyPrice = (priceInWeek * 100).rounded() / 100
//            let roundedDiscountPercentage = Int(discountPercentage.rounded())
//            
//            let isCurrencySymbolLeadingPrice = PremiumManager.shared.annualPricePublished.first?.isNumber == false
//            var currencySymbolPrice = "$ \(roundedWeeklyPrice)"
//            if let annualProduct = PremiumManager.shared.annualProduct {
//                currencySymbolPrice = isCurrencySymbolLeadingPrice
//                ? "\(annualProduct.currencySymbol ?? "$") \(roundedWeeklyPrice)"
//                : "\(roundedWeeklyPrice) \(annualProduct.currencySymbol ?? "$")"
//            }
//            return (roundedWeeklyPrice, roundedDiscountPercentage, currencySymbolPrice)
//        }
//        return (6.99, 0, "$ 6.99")
//    }
//}

extension String {
    func extractNumbers() -> String {
        do {
            let regex = try NSRegularExpression(pattern: "[^0-9.]", options: .caseInsensitive)
            return regex.stringByReplacingMatches(
                in: self.replacingOccurrences(of: ",", with: "."),
                options: [], range: NSRange(location: 0, length: self.count),
                withTemplate: "")
        } catch {
            print("Error while extracting numbers: \(error.localizedDescription)")
            return ""
        }
    }
}
