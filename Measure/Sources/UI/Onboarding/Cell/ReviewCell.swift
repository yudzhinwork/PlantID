//
//  ReviewCell.swift
//  PlantID

import UIKit

class ReviewCell: UICollectionViewCell {
    
    @IBOutlet  private weak var userImageView: UIImageView!
//    @IBOutlet  private weak var userNameLabel: UILabel!
//    @IBOutlet  private weak var commentLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        userImageView.image = nil
//        userNameLabel.text = nil
    }
    
    func fill(_ review: Review) {
        userImageView.image = review.image
    }
}
