//
//  SettingsListCell.swift
//  PlantID

import UIKit

class SettingsListCell: UITableViewCell {
    
    @IBOutlet private weak var itemTextLabel: UILabel!
    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var shadowView: ShadowViewItem!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        iconImageView.image = nil
    }
    
    func configure(_ item: SettingsItems) {
        itemTextLabel.text = item.title
        iconImageView.image = UIImage(named: item.image)!
    }
}
