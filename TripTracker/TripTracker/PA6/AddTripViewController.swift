//
//  AddTripViewController.swift
//  PA7
//
//  Created by Makoto Kewish on 11/8/20.
//

import UIKit
import CoreData

class AddTripViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet var addTripNumLabel: UILabel!
    @IBOutlet var destinationTextField: UITextField!
    @IBOutlet var startDateTextField: UITextField!
    @IBOutlet var endDateTextField: UITextField!
    @IBOutlet var imagePicked: UIImageView!
    
    var tripOp: Trip? = nil
    
    var destinationName: String?
    var startDate: Date?
    var endDate: Date?
    var imageFilePath: String?
    var imageFileName: String?
    var tripNumOp: Int?
    var totalTripsOp: Int?
    var addNumOp: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("In add view controller")
        // Do any additional setup after loading the view.
        changeAddNum()
    }
    
    // Checks if all inputs are valid before performing segue back to TripTableViewController
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "SaveUnwindSegue" {
            if let destination = destinationTextField.text {
                if destination != "" {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "MM/dd/yyyy"
            
                    if let startOp = startDateTextField.text, let start = dateFormatter.date(from: startOp) {
                        if let endOp = endDateTextField.text, let end = dateFormatter.date(from: endOp) {
                            destinationName = destination
                            startDate = start
                            endDate = end
                        
                            if let imagePath = imageFilePath {
                                imageFileName = imagePath
                            }
                            else {
                                imageFileName = nil
                            }
                        
                            return true
                        }
                        else {
                            endDateError()
                        }
                    }
                    else {
                        startDateError()
                    }
                }
                else {
                    destinationError()
                }
            }
        }
        else if identifier == "CancelUnwindSegue" {
            print("User Pressed Cancel")
            return true
        }
        return false
    }
        
    // Destination alert
    func destinationError() {
        let errorMessage = "Missing Destination"
        let alertController = UIAlertController(title: "Invalid Input", message: errorMessage, preferredStyle: .alert)
    
        alertController.addAction(UIAlertAction(title: "Okay", style: .default, handler: { (action) -> Void in
            print("User pressed okay")
            
        }))
        present(alertController, animated: true, completion: { () -> Void in
            print("Presented the destinationError alert")
        })
    }
    
    // Start date alert
    func startDateError() {
        let errorMessage = "Invalid Start Date. Date must be entered mm/dd/yyyy."
        let alertController = UIAlertController(title: "Invalid Input", message: errorMessage, preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Okay", style: .default, handler: { (action) -> Void in
            print("User pressed okay")
                
        }))
        present(alertController, animated: true, completion: { () -> Void in
            print("Presented the startDateError alert")
        })
    }
    
    // End date alert
    func endDateError() {
        let errorMessage = "Invalid End Date. Date must be entered mm/dd/yyyy"
        let alertController = UIAlertController(title: "Invalid Input", message: errorMessage, preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Okay", style: .default, handler: { (action) -> Void in
            print("User pressed okay")
                
        }))
        present(alertController, animated: true, completion: { () -> Void in
            print("Presented endDateError alert")
        })
    }
    
    // Changes text for addTripNumLabel UILabel (called when view loads)
    func changeAddNum() {
        if let addNum = addNumOp {
            addTripNumLabel.text = "Add Trip \(addNum)"
        }
    }
    
    // Executes when imagePicker button is pressed 
    @IBAction func photosButtonTapped(_ sender: UIBarItem) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
    
        let alertController = UIAlertController(title: "Choose Image Source", message: nil, preferredStyle: .actionSheet)
    
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
    
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: "Camera", style:
           .default, handler: { action in
                imagePicker.sourceType = .camera
                self.present(imagePicker, animated: true, completion: nil)
            })
        alertController.addAction(cameraAction)
        }
            
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default, handler: { action in
                    imagePicker.sourceType = .photoLibrary
                    self.present(imagePicker, animated: true, completion: nil)
            })
            alertController.addAction(photoLibraryAction)
        }
            
        present(alertController, animated: true, completion: nil)
    }
    
    // Controller for image picker option
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let selectedImage = info[.originalImage] as? UIImage
        else { return }
    
        writeImage(imageOptional: selectedImage)
        dismiss(animated: true, completion: nil)
    }
    
    // Writes image and displays selected image in AddTripViewController
    func writeImage(imageOptional: UIImage?) {
        if let image = imageOptional {
            let imageName = UUID().uuidString
            let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            
            let imagePath = paths[0].appendingPathComponent(imageName)
            if let jpegData = image.jpegData(compressionQuality: 0.5) {
                try? jpegData.write(to: imagePath)
            }
            
            self.imageFilePath = imagePath.path
            imagePicked.image = UIImage(contentsOfFile: imageFilePath!)
        }
    }
}
