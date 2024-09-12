//
//  SettingsSwitchCell.swift
//  PlantID

import UIKit

protocol SettingsSwitchCellDelegate: AnyObject {
    func settingsSwitchCell(_ cell: SettingsSwitchCell, isOn: Bool)
}

class SettingsSwitchCell: UITableViewCell {
    
    @IBOutlet private weak var itemTextLabel: UILabel!
    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var shadowView: ShadowViewItem!
    @IBOutlet weak var switchControl: UISwitch!
    
    weak var delegate: SettingsSwitchCellDelegate?
    
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
    
    @IBAction func switchAction(_ sender: UISwitch) {
        delegate?.settingsSwitchCell(self, isOn: sender.isOn)
    }
    

}
