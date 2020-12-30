//
//  ViewController.swift
//  PA7
//
//  This application logs trips using a table view controller and tracks data using
//      core data. Utilizes image picking.
//  CPSC 315-01, Fall 2020
//  Programming Assignment #7
//  Sources: App Development with Swift iOS 11 edition
//
//  Created by Makoto Kewish on 11/5/20.
//

import UIKit
import CoreData

class TripTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var tableView: UITableView!
    
    var trips = [Trip]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        print(documentsDirectoryURL)
        
        loadTrips()
    }
    
    // Returns the number of cells in the table (or instances of Trip)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return trips.count
        }
        return 0
    }
    
    // Allows for scrolling (dequeues cells outside view)
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let trip = trips[row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TripCell", for: indexPath) as! TripTableViewCell
        
        cell.update(with: trip)
        return cell
    }
    
    // Allows to sort and rearrange table cells in edit mode
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let trip = trips.remove(at: sourceIndexPath.row)
        trips.insert(trip, at: destinationIndexPath.row)
        
        tableView.reloadData()
    }
    
    // Allows for the deletion of a table cell in edit mode
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            context.delete(trips[indexPath.row])
            trips.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        saveTrips()
    }
    
    // Prepares for a segue depending on the destination
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "DetailSegue" {
                if let tripDetailVC = segue.destination as? TripDetailViewController {
                    if let indexPath = tableView.indexPathForSelectedRow {
                        let trip = trips[indexPath.row]
                        let totalTrips = trips.count
                        let tripNum = indexPath.row + 1
                        
                        tripDetailVC.tripOptional = trip
                        tripDetailVC.totalTripsOp = totalTrips
                        tripDetailVC.tripNumOp = tripNum
                    }
                }
            }
            else if identifier == "AddSegue" {
                if let tripDetailVC = segue.destination as? AddTripViewController {
                    let addNum = trips.count + 1
                    
                    tripDetailVC.addNumOp = addNum
                    if let indexPath = tableView.indexPathForSelectedRow {
                        tableView.deselectRow(at: indexPath, animated: true)
                    }
                }
            }
        }
    }
    
    // Unwinds to TripTableViewController after segue
    @IBAction func unwindToTripTableViewController(segue: UIStoryboardSegue) {
        if let identifier = segue.identifier {
            if identifier == "SaveUnwindSegue" {
                if let tripDetailVC = segue.source as? AddTripViewController {
                    if let destination = tripDetailVC.destinationName, let start = tripDetailVC.startDate, let end = tripDetailVC.endDate {
                        let newTrip = Trip(context: self.context)
                        
                        newTrip.destinationName = destination
                        newTrip.startDate = start
                        newTrip.endDate = end
                        newTrip.imageFileName = tripDetailVC.imageFileName
                        
                        trips.append(newTrip)
                    }
                    saveTrips()
                }
            }
        }
    }
    
    // Puts the table into edit mode
    @IBAction func editButtonPressed(_ sender: UIBarButtonItem) {
        let newEditingMode = !tableView.isEditing
        tableView.setEditing(newEditingMode, animated: true)
    }
    
    // Save contents to database
    func saveTrips() {
        do {
            try context.save()
        }
        catch {
            print("Error saving trips \(error)")
        }
        tableView.reloadData()
    }
    
    // Load (fetch) contents from database
    func loadTrips() {
        let request: NSFetchRequest<Trip> = Trip.fetchRequest()
        do {
            trips = try context.fetch(request)
        }
        catch {
            print("Error loading trips \(error)")
        }
        tableView.reloadData()
    }
    
}

