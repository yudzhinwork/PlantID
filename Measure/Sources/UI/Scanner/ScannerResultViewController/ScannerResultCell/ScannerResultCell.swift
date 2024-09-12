//
//  ScannerResultCell.swift
//  PlantID

import UIKit

class ScannerResultCell: UITableViewCell {
    
    @IBOutlet private weak var resultImageView: UIImageView!
    @IBOutlet private weak var resutText: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func fill(_ image: UIImage, text: String) {
        resultImageView.image = image
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
