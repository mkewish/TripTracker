//
//  TripTableViewCell.swift
//  PA7
//
//  Created by Makoto Kewish on 11/8/20.
//

import UIKit

class TripTableViewCell: UITableViewCell {

    @IBOutlet var tripLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var cellImageLabel: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // Updates the cell labels
    func update(with trip: Trip) {
        tripLabel.text = trip.destinationName
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        
        if let startOp = trip.startDate, let endOp = trip.endDate {
            let start = dateFormatter.string(from: startOp)
            let end = dateFormatter.string(from: endOp)
            dateLabel.text = "\(start) - \(end)"
        }
        
        if let image = trip.imageFileName {
            cellImageLabel.image = UIImage(contentsOfFile: image)
        }
    }

}
