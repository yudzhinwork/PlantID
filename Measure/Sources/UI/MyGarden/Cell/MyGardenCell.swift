//
//  MyGardenCell.swift
//  PlantID

import UIKit

fileprivate struct Colors {
    static let activeColor = UIColor(hexString: "#2DFF75")
    static let defaultColor = UIColor(hexString: "#CDCFCC")
}

@objc protocol MyGardenCellDelegate: AnyObject {
    func myGardenCellRemove(_ myGardenCell: MyGardenCell)
    func myGardenCellWatering(_ myGardenCell: MyGardenCell, isOverdue: Bool)
    func myGardenCellSpraying(_ myGardenCell: MyGardenCell, isOverdue: Bool)
    func myGardenCellWFertilize(_ myGardenCell: MyGardenCell, isOverdue: Bool)
}

class MyGardenCell: UITableViewCell {
    
    @IBOutlet private var optionsViews: [UIView]!
    @IBOutlet private var timesLabel: [UILabel]!
    @IBOutlet private var categoryLabel: [UILabel]!
    @IBOutlet private var categoryImages: [UIImageView]!
    
    @IBOutlet private weak var isNewView: UIView!
    @IBOutlet private weak var plantImageView: CornerImageView!
    @IBOutlet private weak var plantNameLabel: UILabel!
    
    weak var delegate: MyGardenCellDelegate?
    
    var wateringDateOverdue = false
    var sprayingDateOverdue = false
    var fertilizeDateOverdue = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        isNewView.isHidden = true
        plantImageView.image = nil
        plantNameLabel.text = nil
        optionsViews.forEach { view in view.layer.borderColor = UIColor.clear.cgColor }
        timesLabel.forEach { text in text.textColor = nil }
        categoryLabel.forEach { text in text.textColor = nil }
        categoryImages.forEach { view in view.tintColor = nil }
        wateringDateOverdue = false
        sprayingDateOverdue = false
        fertilizeDateOverdue = false
    }
    
    func configure() {
        plantImageView.corners = [.topLeft, .topRight]
        optionsViews.forEach { view in
            view.layer.borderColor = Colors.defaultColor?.cgColor
        }
        timesLabel.forEach { label in
            label.textColor = Colors.defaultColor
        }
        categoryLabel.forEach { label in
            label.textColor = Colors.defaultColor
        }
        categoryImages.forEach { image in
            image.tintColor = Colors.defaultColor
        }
    }
    
    @IBAction func removeAction(_ sender: UIButton) {
        delegate?.myGardenCellRemove(self)
    }
    
    @IBAction func wateringAction(_ sender: UIButton) {
        delegate?.myGardenCellWatering(self, isOverdue: wateringDateOverdue)
    }
    
    @IBAction func sprayingAction(_ sender: UIButton) {
        delegate?.myGardenCellSpraying(self, isOverdue: sprayingDateOverdue)
    }
    
    @IBAction func fertilizAction(_ sender: UIButton) {
        delegate?.myGardenCellWFertilize(self, isOverdue: fertilizeDateOverdue)
    }
    
    func fill(_ object: PlantIdentificationResponse) {
        plantImageView.image = UIImage(data: object.localImageData!)
        plantNameLabel.text = object.suggestions.first?.plantName
        isNewView.isHidden = !object.isNewPlant
        
        let currentDate = Date()
        let calendar = Calendar.current
        
        if let wateringDate = object.wateringDate {
            timesLabel[0].textColor = UIColor(hexString: "#8F9A8C")!
            let components = calendar.dateComponents([.day], from: currentDate, to: wateringDate)
            let daysDifference = components.day ?? 0
            if daysDifference == 0 {
                timesLabel[0].text = "Today"
                wateringDateOverdue = true
            } else if daysDifference < 0 {
                timesLabel[0].text = "\(-daysDifference) days ago"
                wateringDateOverdue = true
            } else {
                timesLabel[0].text = "in \(daysDifference) days"
                wateringDateOverdue = false
            }
            if daysDifference <= 0 {
                optionsViews[0].layer.borderColor = UIColor(hexString: "#FF0000")!.cgColor
            }
            categoryLabel[0].textColor = UIColor(hexString: "#8F9A8C")!
            categoryImages[0].tintColor = UIColor(hexString: "#12AD5C")!
        } else {
            timesLabel[0].textColor = UIColor(hexString: "#CDCFCC")!
            categoryLabel[0].textColor = UIColor(hexString: "#CDCFCC")!
            categoryImages[0].tintColor = UIColor(hexString: "#CDCFCC")!
        }
        
        if let wateringDate = object.sprayingDate {
            timesLabel[1].textColor = UIColor(hexString: "#8F9A8C")!
            let components = calendar.dateComponents([.day], from: currentDate, to: wateringDate)
            let daysDifference = components.day ?? 0
            if daysDifference == 0 {
                timesLabel[1].text = "Today"
                sprayingDateOverdue = true
            } else if daysDifference < 0 {
                timesLabel[1].text = "\(-daysDifference) days ago"
                sprayingDateOverdue = true
            } else {
                timesLabel[1].text = "in \(daysDifference) days"
                sprayingDateOverdue = false
            }
            if daysDifference <= 0 {
                optionsViews[1].layer.borderColor = UIColor(hexString: "#FF0000")!.cgColor
            }
            categoryLabel[1].textColor = UIColor(hexString: "#8F9A8C")!
            categoryImages[1].tintColor = UIColor(hexString: "#12AD5C")!
        } else {
            timesLabel[1].textColor = UIColor(hexString: "#CDCFCC")!
            categoryLabel[1].textColor = UIColor(hexString: "#CDCFCC")!
            categoryImages[1].tintColor = UIColor(hexString: "#CDCFCC")!
        }
        
        if let fertilizeDate = object.fertilizeDate {
            timesLabel[2].textColor = UIColor(hexString: "#8F9A8C")!
            let components = calendar.dateComponents([.day], from: currentDate, to: fertilizeDate)
            let daysDifference = components.day ?? 0
            if daysDifference == 0 {
                timesLabel[2].text = "Today"
                fertilizeDateOverdue = true
            } else if daysDifference < 0 {
                timesLabel[2].text = "\(-daysDifference) days ago"
                fertilizeDateOverdue = true
            } else {
                timesLabel[2].text = "in \(daysDifference) days"
                fertilizeDateOverdue = false
            }
            if daysDifference <= 0 {
                optionsViews[2].layer.borderColor = UIColor(hexString: "#FF0000")!.cgColor
            }
            categoryLabel[2].textColor = UIColor(hexString: "#8F9A8C")!
            categoryImages[2].tintColor = UIColor(hexString: "#12AD5C")!
        } else {
            timesLabel[2].textColor = UIColor(hexString: "#CDCFCC")!
            categoryLabel[2].textColor = UIColor(hexString: "#CDCFCC")!
            categoryImages[2].tintColor = UIColor(hexString: "#CDCFCC")!
        }
    }
}
