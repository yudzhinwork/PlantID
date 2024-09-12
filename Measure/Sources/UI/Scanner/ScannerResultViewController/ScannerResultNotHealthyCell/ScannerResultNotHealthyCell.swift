//
//  ScannerResultNotHealthyCell.swift
//  PlantID

import UIKit

class ScannerResultNotHealthyCell: UITableViewCell {

    @IBOutlet private weak var resultImageView: UIImageView!
    @IBOutlet private weak var resutText: UILabel!
    @IBOutlet private weak var warningText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func fill(_ image: UIImage, response: PlantResponse) {
        resultImageView.image = image
        warningText.text = response.healthAssessment!.diseases.first!.diseaseDetails?.localName.capitalized
        
        var text = "\(response.healthAssessment!.diseases.first!.diseaseDetails!.plantDescription) \n\n Treatment:\n"
        
        if let bio = response.healthAssessment!.diseases.first!.diseaseDetails!.treatment?.biological {
            if !bio.isEmpty {
                text.append("Biological: \n")
            }
            
            for (ind, str) in bio.enumerated() {
                text.append("   \(ind + 1). \(str)\n")
            }
        }
        
        if let bio = response.healthAssessment!.diseases.first!.diseaseDetails!.treatment?.chemical {
            
            if !bio.isEmpty {
                if !bio.isEmpty {
                    text.append("Biological: \n")
                }
            }
            
            for (ind, str) in bio.enumerated() {
                text.append("   \(ind + 1). \(str)\n")
            }
        }
        
        if let bio = response.healthAssessment!.diseases.first!.diseaseDetails!.treatment?.prevention {
            if !bio.isEmpty {
                if !bio.isEmpty {
                    text.append("Prevention: \n")
                }
            }
            for (ind, str) in bio.enumerated() {
                text.append("   \(ind + 1). \(str)\n")
            }
        }
        
        resutText.text = text
        setLineSpacing(for: resutText, with: text, lineSpacing: 8)
    }
    
    func setLineSpacing(for label: UILabel, with text: String, lineSpacing: CGFloat) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing

        let attributedString = NSAttributedString(
            string: text,
            attributes: [
                .paragraphStyle: paragraphStyle
            ]
        )
        
        label.attributedText = attributedString
    }
}
