//
//  TripDetailViewController.swift
//  PA7
//
//  Created by Makoto Kewish on 11/8/20.
//

import UIKit

class TripDetailViewController: UIViewController {

    @IBOutlet var tripNumLabel: UILabel!
    @IBOutlet var destinationLabel: UILabel!
    @IBOutlet var startDateLabel: UILabel!
    @IBOutlet var endDateLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    
    var tripOptional: Trip? = nil
    var tripNumOp: Int?
    var totalTripsOp: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print("In trip detail view controller")
        displayTrip()
    }
    
    // Displays the contains of a trip
    func displayTrip() {
        if let trip = tripOptional {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy"
            
            if let tripNum = tripNumOp, let totalTrips = totalTripsOp {
                tripNumLabel.text = "Trip \(tripNum) of \(totalTrips)"
            }
            if let destination = trip.destinationName {
                destinationLabel.text = "Destination: \(destination)"
            }
            if let startDate = trip.startDate as Date? {
                startDateLabel.text = "Start Date: \(dateFormatter.string(from: startDate))"
            }
            if let endDate = trip.endDate as Date? {
                endDateLabel.text = "End Date: \(dateFormatter.string(from: endDate))"
            }
            if let image = trip.imageFileName {
                imageView.image = UIImage(contentsOfFile: image)
            }
        }
    }
}
