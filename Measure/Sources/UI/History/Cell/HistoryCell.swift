//
//  HistoryCell.swift


import UIKit

final class HistoryCell: UITableViewCell {
    
    // MARK: - @IBOutlets
    
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var historyImageView: UIImageView!
    @IBOutlet private weak var historyContentView: UIView!
    
    // MARK: - Properties
    
    static var identifier = "HistoryCell"
    
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM.dd.yy"
        return formatter
    }()
    
    fileprivate lazy var timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        return formatter
    }()
    
    // MARK: - Life cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configure()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        nameLabel.text = nil
        timeLabel.text = nil
        historyImageView.image = nil
    }
    
    // MARK: - Public Functions
    
    func fill(_ history: ScanHistoryRealm) {
        // Setup measure date
            
        // Setup measure time
        let formattedDate = history.plantName
        
        // Setup measure comment
        timeLabel.text = timeFormatter.string(from: history.scanDate)
        nameLabel.text = formattedDate
        
        // Setup measure image
        historyImageView.image = UIImage(data: history.imageData!)
    }
}

// MARK: - Private

private extension HistoryCell {
    
    func configure() {
        historyImageView.layer.cornerRadius = 4
        historyImageView.contentMode = .scaleAspectFill
        
        historyContentView.layer.cornerRadius = 16
        historyContentView.backgroundColor = Theme.whiteColor
        
        backgroundColor = .clear
    }
}
